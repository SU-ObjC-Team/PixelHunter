//
//  SUMarkColorView.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/17/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SUMarkColorViewDelegate <NSObject>

- (void)colorViewPickedWithColor:(UIColor *)color withSelectedColorViewCenter:(CGPoint)center;

@end


@interface SUMarkColorView : UIView

@property (nonatomic, assign) id <SUMarkColorViewDelegate> delegate;
@property (nonatomic, strong) UIView *selectedColorView;

@end
