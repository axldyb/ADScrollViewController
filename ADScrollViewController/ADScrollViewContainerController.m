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
    //NSLog(@"Parent: %@, self: %@", NSStringFromCGRect(parentFrame), NSStringFromCGRect(selfInSuperview));
    
    // Loop scroll view controllers to find the one to edit in
    for (ADScrollViewController *scrollViewController in self.scrollViews)
    {
        // Make sure it's not the one the item belongs to
        if (scrollViewController.scrollView != scrollView)
        {
            CGRect itemViewInSuperview = itemViewPositionInWindow(itemView);
            //CGRect scrollViewInSuperview = scrollViewPositionInWindow(scrollViewController.scrollView);
            
            //NSLog(@"Scroll %@: %@, Item: %@", scrollViewController.levelNameString, NSStringFromCGRect(scrollViewController.scrollView.frame), NSStringFromCGRect(itemViewInSuperview));
            
            // Check if the item view is intersecting with the scroll view 
            if (CGRectIntersectsRect(itemViewInSuperview, scrollViewController.scrollView.frame))
            {
                //[itemView setDelegate:scrollViewController.scrollView];
                
                // Keep a refrence to the parent scroll view in case we abort the edit.
                itemView.originParentView = scrollView;
                
                // Remove from old scroll view
                [itemView removeFromSuperview];
                //[self.view addSubview:itemView];
                [scrollView.visibleItems removeObject:itemView];
                
                // Remove from source located in scroll view controller and add to new
                for (ADScrollViewController *scrollViewControllerToRemoveItem in self.scrollViews)
                {
                    if (scrollViewControllerToRemoveItem.scrollView == scrollView)
                    {
                        [scrollViewControllerToRemoveItem removeItemView:itemView];
                        
                        
                        [scrollViewController addItemView:itemView];
                    }
                }
            }
            else
            {
                //NSLog(@"Just trolling around in space");
            }
        }
    }
}

- (void)itemView:(ADItemView *)itemView droppedOutsideParentScrollView:(ADScrollView *)scrollView
{
    NSLog(@"Poff!");
}


#pragma mark - Point in other view

CGRect itemViewPositionInWindow(UIView *itemView)
{
    CGRect itemViewInSuperview;
    itemViewInSuperview.origin = [itemView convertPoint:itemView.frame.origin toView:nil];
    itemViewInSuperview.size.width = itemView.frame.size.width;
    itemViewInSuperview.size.height = itemView.frame.size.height;
    NSLog(@"Pos: %@", NSStringFromCGRect(itemViewInSuperview));
    
    return itemViewInSuperview;
}

CGRect scrollViewPositionInWindow(UIScrollView *scrollView)
{
    CGRect scrollViewInSuperview = scrollView.frame;
    //scrollViewInSuperview.size.width = scrollView.frame.size.width;
    //scrollViewInSuperview.size.height = scrollView.frame.size.height;
    
    return scrollViewInSuperview;
}

@end
