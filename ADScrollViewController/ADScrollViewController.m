//
//  ADScrollViewController.m
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 15.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import "ADScrollViewController.h"
#import "ADItemView.h"

//static const int kStatusBarHeight = 30;

@interface ADScrollViewController ()

@end

@implementation ADScrollViewController

- (id)initWithFrame:(CGRect)frame andLevelName:(NSString *)levelName
{
    self = [super init];
    if (self)
    {
        //self.items = [[NSMutableArray alloc] init];
        
        self.scrollView = [[ADScrollView alloc] initWithFrame:frame];
        self.scrollView.dataSource = self;
        self.scrollView.ADDelegate = self;
        
        self.view = self.scrollView;
        [self.scrollView setUpScrollView];
        
        self.levelNameString = levelName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Item Add/Remove

- (void)addItemView:(ADItemView *)itemView // used for drop? rename?
{
    [self.items addObject:itemView];
    
    //NSInteger newIndex = [self calculateNewIndexForItemView:itemView]; ??
    //itemView.index = newIndex;
    
    // Persist here ?
    
    [self.scrollView addSubview:itemView]; // If not existing?
    //[self.scrollView reloadItems];
}

- (void)removeItemView:(ADItemView *)itemView
{
    [self.items removeObject:itemView];
    
    //[self.scrollView reloadItems];
}

/*
- (void)addHooveringItemView:(ADItemView *)itemView
{
    CGRect itemViewFrameInScrollView = [self calculateNewFrameForItemView:itemView];
    //NSLog(@"Item old pos: %@", NSStringFromCGRect(itemView.frame));
    itemView.frame = itemViewFrameInScrollView;
    //NSLog(@"Item NEW pos: %@", NSStringFromCGRect(itemView.frame));
    
    CGRect itemViewHomeInScrollView = [self calculateNewHomeForItemView:itemView];
    itemView.home = itemViewHomeInScrollView;
    
    // Move other tiles away
    NSInteger temporaryIndex = [self calculateNewIndexForItemView:itemView];
    [self.scrollView makeSpaceForNewItemAtIndex:temporaryIndex];
    
    [self.scrollView addSubview:itemView];
}*/


#pragma mark - ADScrollView Data Source

- (NSInteger)numberOfItemsInScrollView:(ADScrollView *)scrollView
{
    return self.items.count;
}


#pragma mark - ADScrollView Delegate

- (ADItemView *)scrollView:(ADScrollView *)scrollView itemAtIndex:(NSInteger)index
{
    return (ADItemView *)[self.items objectAtIndex:index];
}

- (void)scrollView:(ADScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index
{
#warning Selected state control
    
#warning send message to container to move levels up or down
    // [delegtae didSelectItemInScrollView];
}

- (void)scrollView:(ADScrollView *)scrollview itemWithIndex:(NSInteger)oldIndex changedToIndex:(NSInteger)newIndex
{
    id objectToMove = [self.items objectAtIndex:oldIndex];
    [self.items removeObject:objectToMove];
    [self.items insertObject:objectToMove atIndex:newIndex];
    
    //NSLog(@"%@, old:%i, new:%i", (NSString *)objectToMove, oldIndex, newIndex);
}

#warning Change standard values to be const
- (NSInteger)itemViewPaddingForScrollview:(ADScrollView *)scrollView
{
    return 0;
}

- (CGSize)itemViewSizeForScrollview:(ADScrollView *)scrollView
{
    return CGSizeMake(10, 10);
}

- (NSInteger)autoscrollingThresholdForScrollview:(ADScrollView *)scrollView
{
    return 30;
}

- (NSInteger)itemViewDragThresholdForScrollview:(ADScrollView *)scrollView
{
    return 10;
}


/*
#pragma mark - ItemView calculations

- (CGRect)calculateNewFrameForItemView:(ADItemView *)itemView
{
    int newX = itemView.locationInSuperview.x - self.scrollView.frame.origin.x + self.scrollView.contentOffset.x;
    int newY = itemView.locationInSuperview.y - self.scrollView.frame.origin.y - kStatusBarHeight;
    
    CGRect newFrame = itemView.frame;
    newFrame.origin = CGPointMake(newX, newY);
    
    return newFrame;
}

- (CGRect)calculateNewHomeForItemView:(ADItemView *)itemView
{
    NSInteger padding = [self itemViewPaddingForScrollview:self.scrollView];
    NSInteger index = [self calculateNewIndexForItemView:itemView];
    NSInteger itemWidth = [self itemWidthForItemView:itemView];
    
    CGRect newFrame = [self calculateNewFrameForItemView:itemView];
    newFrame.origin.y = padding;
    newFrame.origin.x = (index * itemWidth) + padding;
    
    return newFrame;
}

- (NSInteger)calculateNewIndexForItemView:(ADItemView *)itemView
{
    CGRect itemFrame = [self calculateNewFrameForItemView:itemView];
    NSInteger itemWidth = [self itemWidthForItemView:itemView];

    return itemFrame.origin.x / itemWidth;
}

- (NSInteger)itemWidthForItemView:(ADItemView *)itemView
{
    NSInteger padding = [self itemViewPaddingForScrollview:self.scrollView];
    CGSize itemViewSize = [self itemViewSizeForScrollview:self.scrollView];
    return itemViewSize.width + (padding * 2);
}
 */


#pragma mark - Content Cross Level Modification Delegate

- (void)addItemView:(ADItemView *)itemView atIndex:(NSInteger)index
{
    // Do I need the item index or can i just use - (void)addItemView:(UIView *)itemView
    // USing thie first one for now. calculation of index goes in this class.
}

- (void)removeItemView:(ADItemView *)itemView atIndex:(NSInteger)index
{
    
}


#pragma mark - Point in other view

CGRect itemViewPositionForWindow(ADItemView *itemView)
{
    CGRect itemViewInSuperview;
    itemViewInSuperview = itemView.frame;
    itemViewInSuperview.origin = CGPointMake(itemView.locationInSuperview.x , itemView.locationInSuperview.y);
    
    return itemViewInSuperview;
}

@end
