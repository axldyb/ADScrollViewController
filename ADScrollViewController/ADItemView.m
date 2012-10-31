//
//  ADItemView.m
//  ADScrollViewController
//
//  Created by Aksel Dybdal on 17.10.12.
//  Copyright (c) 2012 Aksel Dybdal. All rights reserved.
//

static const int kADItemViewDragThreshold = 10;

#import "ADItemView.h"

@interface ADItemView ()

@property (nonatomic, assign) CGPoint homeInSuperview;
@property (nonatomic, assign) BOOL dragging;

@end

@implementation ADItemView


- (void)setHome:(CGRect)home
{
    _home = home;
}


#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // store the location of the starting touch so we can decide when we've moved far enough to drag
    self.touchLocation = [[touches anyObject] locationInView:self];
    self.homeInSuperview = [[touches anyObject] locationInView:self.superview.superview.superview.superview]; // ? to many
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // we want to establish a minimum distance that the touch has to move before it counts as dragging,
    // so that the slight movement involved in a tap doesn't cause the frame to move.
    
    CGPoint newTouchLocation = [[touches anyObject] locationInView:self];
    
    // if we're already dragging, move our frame
    if (self.dragging)
    {
        float deltaX = newTouchLocation.x - self.touchLocation.x;
        float deltaY = newTouchLocation.y - self.touchLocation.y;
        [self moveByOffset:CGPointMake(deltaX, deltaY)];
    }
    
    // if we're not dragging yet, check if we've moved far enough from the initial point to start
    else if (distanceBetweenPoints(self.touchLocation, newTouchLocation) > kADItemViewDragThreshold)
    {
        self.touchLocation = newTouchLocation;
        self.dragging = YES;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.dragging) {
        
        CGPoint activePoint = [[touches anyObject] locationInView:self.superview.superview.superview.superview];
        CGPoint pointOnTileTouched = [[touches anyObject] locationInView:self];
        
        int pointForTileCopyX = activePoint.x - pointOnTileTouched.x;
        int pointForTileCopyY = activePoint.y - pointOnTileTouched.y;
        
        //Point used to make sure tile is outside shelf
        CGPoint pointInSuperview = self.superview.superview.superview.frame.origin;
        
            
        if (activePoint.y < pointInSuperview.y)
        {
            //[_delegate tileDroppedOnBoard:self withXPos:pointForTileCopyX withYPos:pointForTileCopyY withCode:NO];
        }

        
        //if ([self.editModeDelegate respondsToSelector:@selector(userHasLetGoOfTile:)])
        //{
        //    [self.editModeDelegate userHasLetGoOfTile:self];
        //}
        
        [self goHome];
        
        self.dragging = NO;
        
    }
    else if ([[touches anyObject] tapCount] == 1)
    {
        NSLog(@"Single tap!");
    }
    else if ([[touches anyObject] tapCount] == 2)
    {
        NSLog(@"Double tap!");
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self goHome];
    self.dragging = NO;
    
    // Do we need this?
    //if ([_delegate respondsToSelector:@selector(thumbImageViewStoppedTracking:)])
    //  [_delegate thumbImageViewStoppedTracking:self];
}


#pragma mark - Go Home

- (void)goHome
{
    // distance is in pixels
    float distanceFromHome = distanceBetweenPoints([self frame].origin, [self home].origin);
    
    // duration is in seconds, so each additional pixel adds only 1/1000th of a second.
    float animationDuration = 0.1 + distanceFromHome * 0.001;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    [self setFrame:[self home]];
    [UIView commitAnimations];
}

#pragma mark - Move By Offset

- (void)moveByOffset:(CGPoint)offset
{
    CGRect frame = [self frame];
    frame.origin.x += offset.x;
    frame.origin.y += offset.y;
    [self setFrame:frame];
}


#pragma mark - Distance between points

float distanceBetweenPoints(CGPoint a, CGPoint b)
{
    float deltaX = a.x - b.x;
    float deltaY = a.y - b.y;
    return sqrtf( (deltaX * deltaX) + (deltaY * deltaY) );
}

@end
