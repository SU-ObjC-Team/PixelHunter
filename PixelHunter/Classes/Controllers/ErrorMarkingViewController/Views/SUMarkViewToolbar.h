//
//  SUMarkViewToolbar.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/15/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUMarkViewToolbarCompositeButton.h"
#import "SUMarkColorView.h"


@interface SUMarkViewToolbar : UIView

@property (nonatomic, strong) SUMarkViewToolbarCompositeButton *cornerTypeButton;
@property (nonatomic, strong) SUMarkViewToolbarCompositeButton *borderWidthSliderButton;
@property (nonatomic, strong) SUMarkViewToolbarCompositeButton *borderColorPickerButton;
@property (nonatomic, strong) SUMarkColorView *markColorView;
@property (nonatomic, strong) UISlider *widthSlider;

@end
