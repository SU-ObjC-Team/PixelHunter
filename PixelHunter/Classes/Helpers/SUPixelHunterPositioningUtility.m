//
//  SUPixelHunterPositioningUtility.m
//  ExamplePixelHunter
//
//  Created by Alex Saenko on 2/13/14.
//  Copyright (c) 2014 Sigma Ukraine. All rights reserved.
//

#import "SUPixelHunterPositioningUtility.h"
#import "SUPixelHunterConstants.h"


@implementation SUPixelHunterPositioningUtility

+ (void)moveViewAnimatedToVisiblePosition:(UIView *)view
{
    CGRect visibleRect = [self screenBounds];
    
    [self swapSizeIfLandscape:&visibleRect.size];
    CGRect newFrame = view.frame;
    if (view.frame.origin.y < visibleRect.origin.y) {
        newFrame.origin.y = visibleRect.origin.y;
    }
    if (view.frame.origin.x < visibleRect.origin.x) {
        newFrame.origin.x = visibleRect.origin.x;
    }
    if (view.frame.origin.x + view.frame.size.width > visibleRect.size.width) {
        newFrame.origin.x = visibleRect.size.width - view.frame.size.width;
    }
    if (view.frame.origin.y + view.frame.size.height > visibleRect.size.height) {
        newFrame.origin.y = visibleRect.size.height - view.frame.size.height;
    }
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        view.frame = newFrame;
    }];
}

+ (void)swapSizeIfLandscape:(CGSize *)size
{
    if ([self isLandscape]) {
        CGFloat temp = size->width;
        size->width = size->height;
        size->height = temp;
    }
}

+ (BOOL)isLandscape
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

+ (CGRect)screenBounds
{
    return [[UIScreen mainScreen] bounds];
}

@end
