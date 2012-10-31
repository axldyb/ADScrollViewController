//
//  ADItemViewDelegate.h
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 10/31/12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADItemView;

@protocol ADItemViewDelegate <NSObject>

- (void)itemViewStartedTracking:(ADItemView *)itemView;

- (void)itemViewMoved:(ADItemView *)itemView;

- (void)itemViewStoppedTracking:(ADItemView *)itemView;

- (NSInteger)scrollViewContentOffset;

@end
