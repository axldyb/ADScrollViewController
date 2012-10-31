//
//  DemoScrollViewContainerController.m
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 17.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

enum {
    kLevelOne,
    kLevelTwo,
    KlevelThree
} kLevelName;

#import "DemoScrollViewContainerController.h"
#import "DemoScrollViewController.h"

@interface DemoScrollViewContainerController ()

@end

@implementation DemoScrollViewContainerController

- (id)init
{
    self = [super init];
    if (self) {
        self.view.frame = [[UIScreen mainScreen] bounds];
        self.view.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    for (NSInteger i = 0; i < 3; i++)
    {
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGRect scrollViewFrame = CGRectMake(10, 10 + (110 * i), screen.size.width - 20, 100);
        
        NSString *levelName = [self levelNameForIndex:i];
        DemoScrollViewController *scrollViewController = [[DemoScrollViewController alloc] initWithFrame:scrollViewFrame andLevelName:levelName];
        scrollViewController.scrollView.backgroundColor = [UIColor blueColor];
        scrollViewController.scrollView.contentSize = CGSizeMake(2000, 100);
        
        [self addScrollView:scrollViewController];
    }
}

- (NSString *)levelNameForIndex:(NSInteger)index
{
    NSString *levelName = nil;
    switch (kLevelName) {
        case kLevelOne:
            levelName = @"LevelOne";
            break;
        case kLevelTwo:
            levelName = @"LevelTwo";
            break;
        case KlevelThree:
            levelName = @"LevelThree";
            break;
            
        default:
            levelName = @"NoLevel";
            NSLog(@"Error no name");
            break;
    }
    return levelName;
}

@end
