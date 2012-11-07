//
//  ADScrollView.h
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 15.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADScrollViewDelegate.h"
#import "ADScrollViewDataSource.h"

@interface ADScrollView : UIScrollView <ADItemViewDelegate>

@property (unsafe_unretained) id<ADScrollViewDelegate> ADDelegate;

@property (unsafe_unretained) id<ADScrollViewDataSource> dataSource;

@property (nonatomic, strong) NSMutableSet *visibleItems;

#warning Add standard margins with option to adjust

- (void)setUpScrollView;

- (void)reloadItems;

- (ADItemView *)dequeueRecycledItem;

- (void)makeSpaceForHooveringItem:(ADItemView *)itemView;

- (void)makeSpaceForNewItemAtIndex:(NSInteger)index;

- (void)sendAllItemViewsHome;

@end
