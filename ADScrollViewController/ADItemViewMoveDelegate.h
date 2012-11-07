//
//  ADItemViewMoveDelegate.h
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 30.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADItemView;
@class ADScrollView;

@protocol ADItemViewMoveDelegate <NSObject>

@required

- (void)itemView:(ADItemView *)itemView startedTrackingInScrollView:(ADScrollView *)scrollView;

- (void)itemView:(ADItemView *)itemView stoppedTrackingWithParentScrollView:(ADScrollView *)scrollView;

- (void)itemView:(ADItemView *)itemView isTrackingWithParentScrollView:(ADScrollView *)scrollView;

- (void)itemView:(ADItemView *)itemView isDroppedWithParentScrollView:(ADScrollView *)scrollView;

@end
