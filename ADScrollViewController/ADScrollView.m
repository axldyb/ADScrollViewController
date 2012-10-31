//
//  ADScrollView.m
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 15.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import "ADScrollView.h"

@interface ADScrollView () <UIScrollViewDelegate>

// Recycling property
@property (nonatomic, strong) NSMutableSet *recycledItems;

// Autoscrolling properties
@property (nonatomic, strong) NSTimer *autoscrollTimer;
@property (nonatomic, assign) float autoscrollDistance;

// Apparence properties
@property (nonatomic, assign) NSInteger itemPadding;
@property (nonatomic, assign) NSInteger autoscrollThreshold;
@property (nonatomic, assign) NSInteger numberOfItems;

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

- (NSInteger)itemPadding
{
    if (!_itemPadding)
    {
        if ([self.ADDelegate respondsToSelector:@selector(itemViewPaddingForScrollview:)])
        {
        _itemPadding = [self.ADDelegate itemViewPaddingForScrollview:self] * 2;
        }
        else
        {
            _itemPadding = 12;
        }
    }
    
    return _itemPadding;
}

- (NSInteger)autoscrollThreshold
{
    if (!_autoscrollThreshold)
    {
        if ([self.ADDelegate respondsToSelector:@selector(autoscrollingThresholdForScrollview:)])
        {
        _autoscrollThreshold = [self.ADDelegate autoscrollingThresholdForScrollview:self];
        }
        else 
        {
            _autoscrollThreshold = 30;
        }
    }
    
    return _autoscrollThreshold;
}

- (NSInteger)numberOfItems
{
    if (!_numberOfItems)
    {
        if ([self.dataSource respondsToSelector:@selector(numberOfItemsInScrollView:)])
        {
            _numberOfItems = [self.dataSource numberOfItemsInScrollView:self];
        }
        else
        {
            _numberOfItems = 3; // Some random default
        }
    }
    
    return _numberOfItems;
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
    // Calculate which items are visible
    CGRect visibleBounds = self.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / 100);
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / 100);
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, self.numberOfItems - 1);
    
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
            ADItemView *itemView;
            if ([self.dataSource respondsToSelector:@selector(scrollView:itemAtIndex:)])
            {
                itemView = [self.ADDelegate scrollView:self itemAtIndex:index];
            }
            
            // All generic attributes updated here
            itemView.index = index;
            itemView.home = itemView.frame;
            itemView.delegate = self;
            itemView.dragThreshold = [self.ADDelegate itemViewDragThresholdForScrollview:self];
            
            [self addSubview:itemView];
            [self.visibleItems addObject:itemView];
        }
    }
    
    [self updateContentSize];
}

- (ADItemView *)dequeueRecycledItem // Make public
{
    ADItemView *itemView = [self.recycledItems anyObject];
    if (itemView)
    {
        [self.recycledItems removeObject:itemView];
    }
    return itemView;
}

- (BOOL)isDisplayingItemForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (ADItemView *itemView in self.visibleItems)
    {
        if (itemView.index == index)
        {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}


#pragma mark - Calculate Index For Item

- (void)orderRearrangedByItem:(ADItemView *)itemView
{
    NSInteger itemViewSpace = [self singleItemViewTotalWidth];
    
    // New index calculation
    NSInteger newIndex = itemView.frame.origin.x / itemViewSpace;
    
    // Only set new index if the index changes
    if (itemView.index != newIndex)
    {
        NSLog(@"%@, old:%i, new:%i <-", itemView.name, itemView.index, newIndex);
        
        // Update data source
        if ([self.ADDelegate respondsToSelector:@selector(scrollView:itemWithIndex:changedToIndex:)])
        {
            [self.ADDelegate scrollView:self itemWithIndex:itemView.index changedToIndex:newIndex];
        }
        else
        {
            NSLog(@"ERROR: Delegate doesn't respond. Item indexes may be wrong!");
        }
        
        // Set view new index
        itemView.index = newIndex;
        
        // Update database here as well
    }
    
    for (ADItemView *visibleItemView in self.visibleItems)
    {
        NSInteger newVisibleIndex = visibleItemView.frame.origin.x / itemViewSpace;
        visibleItemView.index = newVisibleIndex;
    }
}


#pragma mark - ADItemViewDelegate methods

- (void)itemViewStartedTracking:(ADItemView *)itemView
{
    //[self bringSubviewToFront:tiv];
}

- (void)itemViewMoved:(ADItemView *)itemView
{
    // check if we've moved close enough to an edge to autoscroll, or far enough away to stop autoscrolling
    //[self maybeAutoscrollForItem:itemView];
    
    // we'll reorder only if the item view is overlapping the scroll view
    if (CGRectIntersectsRect([itemView frame], [self bounds]))
    {
        BOOL draggingRight = [itemView frame].origin.x > [itemView home].origin.x ? YES : NO;

        NSMutableArray *itemsToShift = [[NSMutableArray alloc] init];
        
        // get the touch location in the coordinate system of the scroll view
        CGPoint touchLocation = [itemView convertPoint:[itemView touchLocation] toView:self];
        
        // calculate minimum and maximum boundaries of the affected area
        float minX = draggingRight ? CGRectGetMaxX([itemView home]) : touchLocation.x;
        float maxX = draggingRight ? touchLocation.x : CGRectGetMinX([itemView home]);
        
        // iterate through item views and see which ones need to move over
        for (ADItemView *item in self.visibleItems)
        {
            
            // skip the item being dragged
            if (item == itemView) continue;
            
            // skip non-item subviews of the scroll view (such as the scroll indicators)
            if (! [item isMemberOfClass:[ADItemView class]]) continue;
            
            float itemMidpoint = CGRectGetMidX([item home]);
            if (itemMidpoint >= minX && itemMidpoint <= maxX)
            {
                [itemsToShift addObject:item];
            }
        }
        
        // shift over the other items to make room for the dragging item. (if we're dragging right, they shift to the left)
        float otherItemShift = ([itemView home].size.width + self.itemPadding) * (draggingRight ? -1 : 1);
        
        // as we shift over the other items, we'll calculate how much the dragging item's home is going to move
        float draggingItemShift = 0.0;
        
        // send each of the shifting items to its new home
        for (ADItemView *otherItem in itemsToShift)
        {
            CGRect home = [otherItem home];
            home.origin.x += otherItemShift;
            [otherItem setHome:home];
            
            [otherItem goHome];
            draggingItemShift += ([otherItem frame].size.width + self.itemPadding) * (draggingRight ? 1 : -1);
        }
        
        // change the home of the dragging item, but don't send it there because it's still being dragged
        CGRect home = [itemView home];
        home.origin.x += draggingItemShift;
        [itemView setHome:home];
    }
}

- (void)itemViewStoppedTracking:(ADItemView *)itemView
{
    // if the user lets go of the item view, stop autoscrolling
    [self.autoscrollTimer invalidate];
    self.autoscrollTimer = nil;
    
    [self orderRearrangedByItem:itemView];
}


#pragma mark - Autoscrolling methods

- (void)maybeAutoscrollForItem:(ADItemView *)item
{
    self.autoscrollDistance = 0;
    
    // only autoscroll if the item is overlapping the scroll view
    if (CGRectIntersectsRect([item frame], [self bounds]))
    {
        CGPoint touchLocation = [item convertPoint:[item touchLocation] toView:self];
        float distanceFromLeftEdge  = touchLocation.x - CGRectGetMinX([self bounds]);
        float distanceFromRightEdge = CGRectGetMaxX([self bounds]) - touchLocation.x;
        
        if (distanceFromLeftEdge < self.autoscrollThreshold)
        {
            self.autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceFromLeftEdge] * -1; // if scrolling left, distance is negative
        } else if (distanceFromRightEdge < self.autoscrollThreshold)
        {
            self.autoscrollDistance = [self autoscrollDistanceForProximityToEdge:distanceFromRightEdge];
        }
    }
    
    // if no autoscrolling, stop and clear timer
    if (self.autoscrollDistance == 0)
    {
        [self.autoscrollTimer invalidate];
        self.autoscrollTimer = nil;
    }
    
    // otherwise create and start timer (if we don't already have a timer going)
    else if (self.autoscrollTimer == nil)
    {
        self.autoscrollTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                                target:self
                                                              selector:@selector(autoscrollTimerFired:)
                                                              userInfo:item
                                                               repeats:YES];
    }
}

- (float)autoscrollDistanceForProximityToEdge:(float)proximity
{
    // the scroll distance grows as the proximity to the edge decreases, so that moving the item
    // further over results in faster scrolling.
    return ceilf((self.autoscrollThreshold - proximity) / 5.0);
}

- (void)legalizeAutoscrollDistance
{
    // makes sure the autoscroll distance won't result in scrolling past the content of the scroll view
    float minimumLegalDistance = [self contentOffset].x * -1;
    float maximumLegalDistance = [self contentSize].width - ([self frame].size.width + [self contentOffset].x);
    self.autoscrollDistance = MAX(self.autoscrollDistance, minimumLegalDistance);
    self.autoscrollDistance = MIN(self.autoscrollDistance, maximumLegalDistance);
}

- (void)autoscrollTimerFired:(NSTimer*)timer
{
    [self legalizeAutoscrollDistance];
    
    // autoscroll by changing content offset
    CGPoint contentOffset = [self contentOffset];
    contentOffset.x += self.autoscrollDistance;
    [self setContentOffset:contentOffset];
    
    // adjust item position so it appears to stay still
    ADItemView *item = (ADItemView *)[timer userInfo];
    [item moveByOffset:CGPointMake(self.autoscrollDistance, 0)];
}

- (NSInteger)scrollViewContentOffset
{
    return self.contentOffset.x;
}


#pragma mark - Scroll View Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadItems];
}


#pragma mark - Size Helpers

- (void)updateContentSize
{
    NSInteger itemViewSpace = [self singleItemViewTotalWidth];
    self.contentSize = CGSizeMake(self.numberOfItems * itemViewSpace, self.frame.size.height);
}

- (NSInteger)singleItemViewTotalWidth
{
    NSInteger itemViewPadding = [self.ADDelegate itemViewPaddingForScrollview:self];
    CGSize itemViewSize = [self.ADDelegate itemViewSizeForScrollview:self];
    NSInteger itemViewSpace = itemViewSize.width + (itemViewPadding * 2);
    
    return itemViewSpace;
}

@end
