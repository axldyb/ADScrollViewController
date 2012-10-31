//
//  ADItemViewMoveDelegate.h
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 30.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADItemView;

@protocol ADItemViewMoveDelegate <NSObject>

@required
- (void)itemViewLeftParentScrollView:(ADItemView*)itemView;

@end
