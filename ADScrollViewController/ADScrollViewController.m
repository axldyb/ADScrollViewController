//
//  ADScrollViewController.m
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 15.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import "ADScrollViewController.h"
#import "ADItemView.h"

@interface ADScrollViewController ()

@end

@implementation ADScrollViewController

- (id)initWithFrame:(CGRect)frame andLevelName:(NSString *)levelName
{
    self = [super init];
    if (self)
    {
        self.items = [[NSMutableArray alloc] init];
        
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

- (void)addItemView:(UIView *)itemView
{
    [self.items addObject:itemView];
    
    [self.scrollView addSubview:itemView];
    //[self.scrollView reloadItems];
}

- (void)removeItemView:(UIView *)itemView
{
    [self.items removeObject:itemView];
    
    //[self.scrollView reloadItems];
}


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


#pragma mark - Content Cross Level Modification Delegate

- (void)addItemView:(ADItemView *)itemView atIndex:(NSInteger)index
{
    // Do I need the item index or can i just use - (void)addItemView:(UIView *)itemView
}

- (void)removeItemView:(ADItemView *)itemView atIndex:(NSInteger)index
{
    
}

#pragma mark - Content Reorder Delegate

@end
