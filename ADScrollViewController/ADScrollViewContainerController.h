//
//  ADScrollViewContainerController.h
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 15.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADScrollViewController.h"

@interface ADScrollViewContainerController : UIViewController

@property (nonatomic, strong) NSMutableArray *scrollViews;

/**
 Adds a new scrollview to the container.
 
 The ADScrollViews represent levels in the hierarcy and the first to be added is the first level. The second is the second, and so on.
 
 @param scrollView The ADScrollView to be added to the container
 */
- (void)addScrollView:(ADScrollViewController *)scrollView;

/**
 Removes a scrollview from the container.
 
 @param scrollView The ADScrollView to be removed from the container
 */
#warning Remove at index?
- (void)removeScrollView:(ADScrollViewController *)scrollView;

@end
