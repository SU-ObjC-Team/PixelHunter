//
//  SUGridRulerViewHorizontal.m
//  ExamplePixelHunter
//
//  Created by Rostyslav Druzhchenko on 1/26/14.
//  Copyright (c) 2014 Sigma Ukraine. All rights reserved.
//

#import "SUGridRulerViewHorizontal.h"

@implementation SUGridRulerViewHorizontal

- (CGRect)rectForLenght:(CGFloat)lenght position:(NSInteger)position
{
    return CGRectMake(position * lenght, 0.0f, lenght, kSURulerSize);
}

- (CGFloat)maxLengthForRect:(CGRect)rect
{
    return rect.size.width;
}

@end
