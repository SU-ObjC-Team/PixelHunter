//
//  SUZGestureRecognizer.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/24/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUZGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>


@interface SUZGestureRecognizer ()

@property (nonatomic, readwrite) BOOL isFirstRightSwipe;
@property (nonatomic, readwrite) BOOL isSecondRightSwipe;
@property (nonatomic, readwrite) BOOL isDiagonalSwipe;

@end


@implementation SUZGestureRecognizer

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if ([self state] == UIGestureRecognizerStateFailed)
        return;
    
    CGPoint currentPoint = [[touches anyObject] locationInView:self.view];
    CGPoint previousPoint = [[touches anyObject] previousLocationInView:self.view];
    
    if (currentPoint.x >= previousPoint.x) {
        self.isFirstRightSwipe = YES;
    }
    if (self.isFirstRightSwipe) {
        if (currentPoint.x <= previousPoint.x && currentPoint.y >= previousPoint.y) {
            self.isDiagonalSwipe = YES;
        }
    }
    if (self.isDiagonalSwipe && self.isFirstRightSwipe) {
        if (currentPoint.x >= previousPoint.x) {
            self.isSecondRightSwipe = YES;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (self.isSecondRightSwipe) {
        self.state = UIGestureRecognizerStateRecognized;
    }
}

@end
