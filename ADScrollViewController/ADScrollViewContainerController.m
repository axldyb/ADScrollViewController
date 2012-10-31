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
    
    for (ADScrollViewController *scrollViewController in self.scrollViews)
    {
        if (scrollViewController.scrollView != scrollView)
        {
            CGRect itemViewInSuperview;
            itemViewInSuperview.origin = [itemView.superview convertPoint:itemView.frame.origin toView:nil];
            itemViewInSuperview.size.width = itemView.frame.size.width;
            itemViewInSuperview.size.height = itemView.frame.size.height;
            
            CGRect scrollViewInSuperview = scrollViewController.scrollView.frame;
            scrollViewInSuperview.size.width = scrollViewController.scrollView.frame.size.width;
            scrollViewInSuperview.size.height = scrollViewController.scrollView.frame.size.height;
            
            //NSLog(@"Scroll %@: %@, Item: %@", scrollViewController.levelNameString, NSStringFromCGRect(scrollViewInSuperview), NSStringFromCGRect(itemViewInSuperview));
            
            if (CGRectIntersectsRect(itemViewInSuperview, scrollViewInSuperview))
            {
                //NSLog(@"I leave now");
                itemView.originParentView = scrollView;
                
                [itemView removeFromSuperview];
                [self.view addSubview:itemView];
                
                [scrollView.visibleItems removeObject:itemView];
                [scrollViewController removeItemView:itemView];
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

@end
