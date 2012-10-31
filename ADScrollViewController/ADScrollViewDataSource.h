//
//  ADScrollViewDataSource.h
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 17.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADScrollView;

@protocol ADScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfItemsInScrollView:(ADScrollView *)scrollView;

@end
