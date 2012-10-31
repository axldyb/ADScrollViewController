//
//  ADScrollView.m
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 15.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

static const int kTempItemWidth = 45;
static const int kTempItemMargin = 10;

#import "ADScrollView.h"

#define THUMB_H_PADDING 12 // Put this into a delegate
#define AUTOSCROLL_THRESHOLD 30

@interface ADScrollView () <UIScrollViewDelegate>

// Recycling properties
@property (nonatomic, strong) NSMutableSet *visibleItems;
@property (nonatomic, strong) NSMutableSet *recycledItems;

// Autoscrolling properties
@property (nonatomic, strong) NSTimer *autoscrollTimer;
@property (nonatomic, assign) float autoscrollDistance;

@end

@implementation ADScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = frame;
    }
    return self;
}


#pragma mark - Setup

- (void)setUpScrollView
{
    // Scrollview setup
    self.bounces = YES;
    self.canCancelContentTouches = NO;
    self.clipsToBounds = NO;
    self.delegate = self;
    
    //[self initializeVisibleItems];
    
    self.visibleItems = [[NSMutableSet alloc] init];
    self.recycledItems = [[NSMutableSet alloc] init];
    
    [self loadItems];
}

- (void)reloadItems
{
    [self loadItems];
}


#pragma mark - Load Items

- (void)loadItems
{
    NSInteger numberOfItems;
    
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInScrollView:)])
    {
        numberOfItems = [self.dataSource numberOfItemsInScrollView:self];
    }
    
    // Calculate which items are visible
    CGRect visibleBounds = self.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / 100);
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / 100);
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, numberOfItems - 1);
    
    // Recycle no-longer-visible items
    for (ADItemView *itemView in self.visibleItems)
    {
        if (itemView.index < firstNeededPageIndex || itemView.index > lastNeededPageIndex)
        {
            [self.recycledItems addObject:itemView];
            [itemView removeFromSuperview];
        }
    }
    [self.visibleItems minusSet:self.recycledItems];
    
    // add missing items
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++)
    {
        if (![self isDisplayingItemForIndex:index])
        {
            ADItemView *item;
            if ([self.dataSource respondsToSelector:@selector(scrollView:itemAtIndex:)])
            {
                item = [self.ADDelegate scrollView:self itemAtIndex:index];
            }
            
            // All generic attributes updated here
            item.index = index;
            item.home = item.frame;
            
            [self addSubview:item];
            [self.visibleItems addObject:item];
        }
    }
    
    // Set content size. Should it be set every time?
    ADItemView *item = [self.visibleItems anyObject];
    self.contentSize = CGSizeMake(numberOfItems * item.frame.size.width + item.frame.size.width / 5, self.frame.size.height);
}

- (ADItemView *)dequeueRecycledItem // Make public
{
    ADItemView *item = [self.recycledItems anyObject];
    if (item)
    {
        [self.recycledItems removeObject:item];
    }
    return item;
}

- (BOOL)isDisplayingItemForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (ADItemView *item in self.visibleItems)
    {
        if (item.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}


#pragma mark - ThumbImageViewDelegate methods

- (void)thumbImageViewStartedTracking:(ADItemView *)tiv {
    
    //[self bringSubviewToFront:tiv];
}

- (void)thumbImageViewMoved:(ADItemView *)itemView {
    
    // check if we've moved close enough to an edge to autoscroll, or far enough away to stop autoscrolling
    [self maybeAutoscrollForThumb:itemView];
    
    // we'll reorder only if the item view is overlapping the scroll view
    if (CGRectIntersectsRect([itemView frame], [self bounds])) {
        
        BOOL draggingRight = [itemView frame].origin.x > [itemView home].origin.x ? YES : NO;

        NSMutableArray *itemsToShift = [[NSMutableArray alloc] init];
        
        // get the touch location in the coordinate system of the scroll view
        CGPoint touchLocation = [itemView convertPoint:[itemView touchLocation] toView:self];
        
        // calculate minimum and maximum boundaries of the affected area
        float minX = draggingRight ? CGRectGetMaxX([itemView home]) : touchLocation.x;
        float maxX = draggingRight ? touchLocation.x : CGRectGetMinX([itemView home]);
        
        // iterate through item views and see which ones need to move over
        for (ADItemView *item in self.recycledItems) {
            
            // skip the thumb being dragged
            if (item == itemView) continue;
            
            // skip non-thumb subviews of the scroll view (such as the scroll indicators)
            if (! [item isMemberOfClass:[ADItemView class]]) continue;
            
            float itemMidpoint = CGRectGetMidX([item home]);
            if (itemMidpoint >= minX && itemMidpoint <= maxX) {
                [itemsToShift addObject:item];
            }
        }
        
        // shift over the other thumbs to make room for the dragging thumb. (if we're dragging right, they shift to the left)
        float otherItemShift = ([itemView home].size.width + THUMB_H_PADDING) * (draggingRight ? -1 : 1);
        
        // as we shift over the other thumbs, we'll calculate how much the dragging thumb's home is going to move
        float draggingItemShift = 0.0;
        
        // send each of the shifting thumbs to its new home
        for (ADItemView *otherItem in itemsToShift) {
            CGRect home = [otherItem home];
            home.origin.x += otherItemShift;
            [otherItem setHome:home];
            
            [otherItem goHome];
            draggingItemShift += ([otherItem frame].size.width + THUMB_H_PADDING) * (draggingRight ? 1 : -1);
        }
        
        // change the home of the dragging thumb, but don't send it there because it's still being dragged
        CGRect home = [itemView home];
        home.origin.x += draggingItemShift;
        [itemView setHome:home];
        
    }
}

- (void)thumbImageViewStoppedTracking:(ADItemView *)tiv {
    // if the user lets go of the thumb image view, stop autoscrolling
    [self.autoscrollTimer invalidate];
    self.autoscrollTimer = nil;
}


#pragma mark - Autoscrolling methods

- (void)maybeAutoscrollForThumb:(ADItemView *)thumb {
    
    self.autoscrollDistance = 0;
    
    // only autoscroll if the thumb is overlapping the thumbScrollView
    if (CGRectIntersectsRect([thumb frame], [self bounds])) {
        
        CGPoint touchLocation = [thumb convertPoint:[thumb touchLocation] toView:self];
        float distanceFromLeftEdge  = touchLocation.x - CGRectGetMinX([self bounds]);
        float distanceFromRightEdge = CGRectGetMaxX([self bounds]) - touchLocation.x;
        
        if (distanceFromLeftEdge < AUTOSCROLL_THRESHOLD) {
            self.autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceFromLeftEdge] * -1; // if scrolling left, distance is negative
        } else if (distanceFromRightEdge < AUTOSCROLL_THRESHOLD) {
            self.autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceFromRightEdge];
        }
    }
    
    // if no autoscrolling, stop and clear timer
    if (self.autoscrollDistance == 0) {
        [self.autoscrollTimer invalidate];
        self.autoscrollTimer = nil;
    }
    
    // otherwise create and start timer (if we don't already have a timer going)
    else if (self.autoscrollTimer == nil) {
        self.autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                           target:self
                                                         selector:@selector(autoscrollTimerFired:)
                                                         userInfo:thumb
                                                          repeats:YES];
    }
}

- (float)autoscrollDistanceForProximityToEdge:(float)proximity {
    // the scroll distance grows as the proximity to the edge decreases, so that moving the thumb
    // further over results in faster scrolling.
    return ceilf((AUTOSCROLL_THRESHOLD - proximity) / 5.0);
}

- (void)legalizeAutoscrollDistance {
    // makes sure the autoscroll distance won't result in scrolling past the content of the scroll view
    float minimumLegalDistance = [self contentOffset].x * -1;
    float maximumLegalDistance = [self contentSize].width - ([self frame].size.width + [self contentOffset].x);
    self.autoscrollDistance = MAX(self.autoscrollDistance, minimumLegalDistance);
    self.autoscrollDistance = MIN(self.autoscrollDistance, maximumLegalDistance);
}

- (void)autoscrollTimerFired:(NSTimer*)timer {
    [self legalizeAutoscrollDistance];
    
    // autoscroll by changing content offset
    CGPoint contentOffset = [self contentOffset];
    contentOffset.x += self.autoscrollDistance;
    [self setContentOffset:contentOffset];
    
    // adjust thumb position so it appears to stay still
    ADItemView *item = (ADItemView *)[timer userInfo];
    [item moveByOffset:CGPointMake(self.autoscrollDistance, 0)];
}



#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadItems];
}

@end
