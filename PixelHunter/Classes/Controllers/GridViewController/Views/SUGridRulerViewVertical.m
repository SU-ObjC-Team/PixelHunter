//
//  SUGridRulerViewVertical.m
//  ExamplePixelHunter
//
//  Created by Rostyslav Druzhchenko on 1/26/14.
//  Copyright (c) 2014 Sigma Ukraine. All rights reserved.
//

#import "SUGridRulerViewVertical.h"

@implementation SUGridRulerViewVertical

- (CGRect)rectForLength:(CGFloat)length position:(NSInteger)position
{
    return CGRectMake(0.0f, position * length, kSURulerSize, length);
}

- (CGFloat)maxLengthForRect:(CGRect)rect
{
    return rect.size.height;
}

@end
