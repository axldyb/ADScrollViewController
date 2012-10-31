//
//  ADItemView.h
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 17.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADItemView : UIView

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) CGRect home;

// Location of touch in own coordinates (stays constant during dragging).
@property (nonatomic, assign) CGPoint touchLocation;

- (void)goHome;

- (void)moveByOffset:(CGPoint)offset;

@end
