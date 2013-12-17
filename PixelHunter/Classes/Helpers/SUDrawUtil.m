//
//  SUDrawUtil.m
//  PixelHunter
//
//  Created by Alex Saenko on 9/30/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUDrawUtil.h"


@implementation SUDrawUtil

+ (void)draw1PxStrokeWithContext:(CGContextRef)context
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
