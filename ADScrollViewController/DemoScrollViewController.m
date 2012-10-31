//
//  DemoScrollViewController.m
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 18.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import "DemoScrollViewController.h"
#import "ADItemView.h"

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


- (NSInteger)numberOfItemsInScrollView:(ADScrollView *)scrollView
{
    return 40;
}

- (ADItemView *)scrollView:(ADScrollView *)scrollView itemAtIndex:(NSInteger)index
{
    ADItemView *itemView = [scrollView dequeueRecycledItem];
    if (!itemView)
    {
        itemView = [[ADItemView alloc] init];
    }
    
    CGRect itemFrame = CGRectMake(10 + (100 * index) , 10, 80, 80);
    [itemView setFrame:itemFrame];
    
    itemView.backgroundColor = [UIColor yellowColor];
    
    return itemView;
}

@end
