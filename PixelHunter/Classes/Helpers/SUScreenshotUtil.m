//
//  SUScreenshotUtil.m
//  PixelHunter
//
//  Created by Alex Saenko on 7/30/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUScreenshotUtil.h"


@implementation SUScreenshotUtil

+ (UIImage *)convertViewToImage:(UIView *)view
{
    CGFloat imageScale = sqrtf(powf(view.transform.a, 2.f) + powf(view.transform.c, 2.f));
    CGFloat widthScale = view.bounds.size.width / view.frame.size.width;
    CGFloat heightScale = view.bounds.size.height / view.frame.size.height;
    CGFloat contentScale = MIN(widthScale, heightScale);
    CGFloat effectiveScale = imageScale * contentScale;
    
    CGSize captureSize = CGSizeMake(view.bounds.size.width / effectiveScale, view.bounds.size.height / effectiveScale);
    
    UIGraphicsBeginImageContextWithOptions(captureSize, YES, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1/effectiveScale, 1/effectiveScale);
    [view.layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
