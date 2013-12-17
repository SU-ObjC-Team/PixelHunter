//
//  SUColorView.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/17/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SUColorView : UIView

- (id)initWithColor:(UIColor *)color;

@property (nonatomic, strong) UIButton *colorViewButton;
@property (nonatomic, strong) UIColor *color;

@end
