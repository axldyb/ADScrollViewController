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

@interface ADScrollView : UIScrollView

@property (nonatomic, assign) id<ADScrollViewDelegate> ADDelegate;

@property (nonatomic, assign) id<ADScrollViewDataSource> dataSource;

#warning Add standard margins with option to adjust

- (void)setUpScrollView;

- (void)reloadItems;

- (ADItemView *)dequeueRecycledItem;

@end
