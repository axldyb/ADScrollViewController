//
//  ADItemView.h
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 17.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADItemViewDelegate.h"
#import "ADItemViewMoveDelegate.h" 

@class ADScrollView;

@interface ADItemView : UIView

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) CGRect home;

// Location of touch in own coordinates (stays constant during dragging).
@property (nonatomic, assign) CGPoint touchLocation;

@property (nonatomic, assign) CGPoint locationInSuperview;

@property (nonatomic, assign) NSInteger dragThreshold;

@property (nonatomic, strong) ADScrollView *originParentView;

@property (nonatomic, strong) NSString *name;

@property (unsafe_unretained) id <ADItemViewDelegate> delegate;

@property (unsafe_unretained) id <ADItemViewMoveDelegate> moveDelegate;

- (void)goHome;

- (void)goToTempHome:(CGRect)tempHome;

- (void)moveByOffset:(CGPoint)offset;

@end
