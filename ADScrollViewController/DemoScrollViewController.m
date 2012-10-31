//
//  DemoScrollViewController.m
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 18.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import "DemoScrollViewController.h"
#import "ADItemView.h"

static const int kADItemViewPadding = 10;
static const int kADItemViewWidth = 80;
static const int kADItemViewHeight = 80;

@interface DemoScrollViewController ()

@end

@implementation DemoScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - ADScrollView Data Source

- (NSInteger)numberOfItemsInScrollView:(ADScrollView *)scrollView
{
    return 40;
}


#pragma mark - ADScrollView Delegate

- (ADItemView *)scrollView:(ADScrollView *)scrollView itemAtIndex:(NSInteger)index
{
    ADItemView *itemView = [scrollView dequeueRecycledItem];
    if (!itemView)
    {
        itemView = [[ADItemView alloc] init];
    }
    
    CGRect itemFrame;
    itemFrame.origin.x = kADItemViewPadding + (100 * index);
    itemFrame.origin.y = kADItemViewPadding;
    itemFrame.size.width = kADItemViewWidth;
    itemFrame.size.height = kADItemViewHeight;
    
    [itemView setFrame:itemFrame];
    itemView.backgroundColor = [UIColor yellowColor];
    
    return itemView;
}

- (NSInteger)itemViewPaddingForScrollview:(ADScrollView *)scrollView
{
    return kADItemViewPadding;
}

- (CGSize)itemViewSizeForScrollview:(ADScrollView *)scrollView
{
    return CGSizeMake(kADItemViewWidth, kADItemViewHeight);
}

- (NSInteger)autoscrollingThresholdForScrollview:(ADScrollView *)scrollView
{
    return 30;
}

- (NSInteger)itemViewDragThresholdForScrollview:(ADScrollView *)scrollView
{
    return 10;
}

@end
