//
//  SUGridToolbar.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/9/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUCompositeButton.h"


@interface SUGridToolbar : UIView

@property (nonatomic, strong) SUCompositeButton *gridDisplayButton;
@property (nonatomic, strong) SUCompositeButton *showPickerButton;
@property (nonatomic, strong) SUCompositeButton *showMarkingViewControllerButton;
@property (nonatomic, strong) SUCompositeButton *closeButton;
@property (nonatomic, strong) UISlider *slider;

@end
