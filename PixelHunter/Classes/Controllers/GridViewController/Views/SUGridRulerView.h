//
//  SUGridTopRulerView.h
//  PixelHunter
//
//  Created by Alex Saenko on 9/26/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUPixelHunterConstants.h"

@protocol SUGridRulerViewProtocol <NSObject>

@optional
- (CGRect)rectForLength:(CGFloat)lenght position:(NSInteger)position;
- (CGFloat)maxLengthForRect:(CGRect)rect;

@end


@interface SUGridRulerView : UIView <SUGridRulerViewProtocol>

@property (nonatomic, assign) CGFloat scale;

@end
