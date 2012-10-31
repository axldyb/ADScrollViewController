//
//  ADScrollViewDelegate.h
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 17.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADItemView.h"

@class ADScrollView;

@protocol ADScrollViewDelegate <NSObject>

@required
- (ADItemView *)scrollView:(ADScrollView *)scrollView itemAtIndex:(NSInteger)index;

@optional
- (void)scrollView:(ADScrollView *)scrollView didSelectItemAtIndex:(NSInteger)index;

@end
