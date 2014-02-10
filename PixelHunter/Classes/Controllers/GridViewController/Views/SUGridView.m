//
//  SUGridView.m
//  PixelHunter
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridView.h"
#import "SUPixelHunterConstants.h"
#import "SUGridViewController.h"


@implementation SUGridView

- (id)init
{
    self = [super init];
    if (self) {
        self.opaque = NO;
        self.userInteractionEnabled = NO;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    CGColorRef lineColor = [UIColor colorWithWhite:0.5f alpha:0.5f].CGColor;
    
    [self drawVerticalLinesWithColor:lineColor];
    [self drawHorizontalLinesWithColor:lineColor];
}

- (void)drawVerticalLinesWithColor:(CGColorRef)lineColor
{
    CGFloat coord = 0.0f;
    CGFloat startCoord = self.startPoint.x;
    NSInteger numberOfLines = self.frame.size.width / self.gridStepSize + 1;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (NSInteger i = 0; i < numberOfLines; i++) {
        CGPoint startPoint = CGPointMake(coord + startCoord, 0);
        CGPoint endPoint = CGPointMake(coord + startCoord, self.frame.size.height);
        [self draw1PxStrokeWithContext:context withStartPoint:startPoint
                          withEndPoint:endPoint withColor:lineColor];
        coord += self.gridStepSize;
    }
}

- (void)drawHorizontalLinesWithColor:(CGColorRef)lineColor
{
    CGFloat coord = 0.0f;
    CGFloat startCoord = self.startPoint.y;
    NSInteger numberOfLines = self.frame.size.height / self.gridStepSize + 1;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (NSInteger i = 0; i < numberOfLines; i++) {
        CGPoint startPoint = CGPointMake(0, coord + startCoord);
        CGPoint endPoint = CGPointMake(self.frame.size.width, coord + startCoord);
        [self draw1PxStrokeWithContext:context withStartPoint:startPoint
                          withEndPoint:endPoint withColor:lineColor];
        coord += self.gridStepSize;
    }
}

- (void)draw1PxStrokeWithContext:(CGContextRef)context
                  withStartPoint:(CGPoint)startPoint
                    withEndPoint:(CGPoint)endPoint
                       withColor:(CGColorRef)color
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0f);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
