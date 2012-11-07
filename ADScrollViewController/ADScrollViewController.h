//
//  ADScrollViewController.h
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 15.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADScrollView.h"
#import "ADScrollViewDelegate.h"
#import "ADScrollViewDataSource.h"

@interface ADScrollViewController : UIViewController <ADScrollViewDelegate, ADScrollViewDataSource>

@property (nonatomic, strong) NSString *levelNameString;

@property (nonatomic, strong) NSMutableArray *items;

@property (nonatomic, strong) ADScrollView *scrollView;

- (id)initWithFrame:(CGRect)frame andLevelName:(NSString *)levelName;

- (void)addItemView:(ADItemView *)itemView;

- (void)removeItemView:(ADItemView *)itemView;

@end
