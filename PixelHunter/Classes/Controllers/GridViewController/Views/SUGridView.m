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


@interface SUGridView ()

@property (nonatomic, readwrite) BOOL isSmallGrid;

@end


@implementation SUGridView

- (id)initWithSmallGrid:(BOOL)isSmallGrid
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        self.hidden = YES;
        self.isSmallGrid = isSmallGrid;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat stepSize = kSUStepSize;
    if (self.isSmallGrid) {
        stepSize = kSUSmallStepSize;
    }
    [self drawGridLinesWithCellSize:stepSize andLineColor:[UIColor colorWithWhite:0.5f alpha:0.5f]];
}

- (void)drawGridLinesWithCellSize:(CGFloat)cellSize andLineColor:(UIColor *)lineColor
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSInteger startLinePoint = 0;
    NSInteger numberOfVeticalLines = ceil(self.frame.size.width / cellSize);
    if (self.isSmallGrid) {
        numberOfVeticalLines += 1;
        
        for (NSInteger i = 0; i < numberOfVeticalLines; i++) {
            CGPoint startPoint = CGPointMake(startLinePoint + self.startVerticalPoint, 0);
            CGPoint endPoint = CGPointMake(startLinePoint + self.startVerticalPoint, self.frame.size.height);
            [self draw1PxStrokeWithContext:context withStartPoint:startPoint withEndPoint:endPoint withColor:lineColor.CGColor];
            startLinePoint = startLinePoint + cellSize;
        }
    } else {
        for (NSInteger i = 0; i < numberOfVeticalLines; i++) {
            CGPoint startPoint = CGPointMake(startLinePoint, 0);
            CGPoint endPoint = CGPointMake(startLinePoint, self.frame.size.height);
            [self draw1PxStrokeWithContext:context withStartPoint:startPoint withEndPoint:endPoint withColor:lineColor.CGColor];
            startLinePoint = startLinePoint + cellSize;
        }
    }
    
    startLinePoint = 0;
    NSInteger numberOfHorizontalLines = ceil(self.frame.size.height / cellSize);
    if (self.isSmallGrid) {
        numberOfHorizontalLines += 1;
        
        for (NSInteger i = 0; i < numberOfHorizontalLines; i++) {
            CGPoint startPoint = CGPointMake(0, startLinePoint + self.startHorizontalPoint);
            CGPoint endPoint = CGPointMake(self.frame.size.width, startLinePoint + self.startHorizontalPoint);
            [self draw1PxStrokeWithContext:context withStartPoint:startPoint withEndPoint:endPoint withColor:lineColor.CGColor];
            startLinePoint = startLinePoint + cellSize;
        }
    } else {
        for (NSInteger i = 0; i < numberOfHorizontalLines; i++) {
            CGPoint startPoint = CGPointMake(0, startLinePoint);
            CGPoint endPoint = CGPointMake(self.frame.size.width, startLinePoint);
            [self draw1PxStrokeWithContext:context withStartPoint:startPoint withEndPoint:endPoint withColor:lineColor.CGColor];
            startLinePoint = startLinePoint + cellSize;
        }

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
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

@end
