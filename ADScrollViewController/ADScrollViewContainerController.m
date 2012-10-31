//
//  ADScrollViewContainerController.m
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 15.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import "ADScrollViewContainerController.h"

@interface ADScrollViewContainerController ()

@end

@implementation ADScrollViewContainerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.scrollViews = [[NSMutableArray alloc] init];
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


#pragma mark - Scroll View Add/Remove

- (void)addScrollView:(ADScrollViewController *)scrollViewController
{
    [self.scrollViews addObject:scrollViewController];
    [self.view addSubview:scrollViewController.view];
    [self addDelegateForItemsInScrollView:scrollViewController];
}

- (void)removeScrollView:(ADScrollViewController *)scrollViewController
{
    [self.scrollViews removeObject:scrollViewController];
    [scrollViewController removeFromParentViewController];
    scrollViewController = nil;
}


#pragma mark - Set ADItemViewMoveDelegate

- (void)addDelegateForItemsInScrollView:(ADScrollViewController *)scrollViewController
{
    for (ADItemView *itemView in scrollViewController.scrollView.visibleItems)
    {
        itemView.moveDelegate = self;
    }
}


#pragma mark - ADItemViewMoveDelegate

- (void)itemView:(ADItemView *)itemView leftParentScrollView:(ADScrollView *)scrollView
{
    NSLog(@"I leave now");
    for (ADScrollViewController *scrollViewController in self.scrollViews)
    {
        if (scrollViewController.scrollView == scrollView)
        {
            itemView.originParentView = scrollView;
            //[itemView removeFromSuperview];
            [scrollView.visibleItems removeObject:itemView];
            [scrollViewController removeItemView:itemView];
        }
        else
        {
            NSLog(@"Just trolling around in space");
        }
    }
}

- (void)itemView:(ADItemView *)itemView droppedOutsideParentScrollView:(ADScrollView *)scrollView
{
    NSLog(@"Poff!");
}

@end
