//
//  SUGridTopRulerView.h
//  PixelHunter
//
//  Created by Alex Saenko on 9/26/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUPixelHunterConstants.h"

@interface SUGridRulerView : UIView

- (CGRect)rectForLenght:(CGFloat)lenght position:(NSInteger)position;
- (CGFloat)maxLengthForRect:(CGRect)rect;

@property (nonatomic, assign) CGFloat scale;

@end
