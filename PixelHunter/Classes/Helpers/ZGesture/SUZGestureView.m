//
//  SUZGestureView.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/24/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUZGestureView.h"


@implementation SUZGestureView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.zGestureRecognizer = [[SUZGestureRecognizer alloc] init];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:self.zGestureRecognizer];
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(removeFromSuperview)
                                       userInfo:nil
                                        repeats:NO];
    }
    return self;
}

@end
