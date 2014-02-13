//
//  SUMarkViewToolbar.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/15/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUMarkViewToolbar.h"
#import "SUPixelHunterConstants.h"
#import "SUPixelHunterTheme.h"

static CGFloat const kSUSliderWidth = 42.0f;
static CGFloat const kSUSliderHeight = 285.0f;
static CGFloat const kSUSliderStartY = 15.0f;
static CGFloat const kSUMarkColorViewStartY = 30.0f;
static CGFloat const kSUMarkColorViewIndent = 3.0f;

static CGFloat const kSUWidthSliderMinimumValue = 1.0f;
static CGFloat const kSUWidthSliderMaximumValue = 4.0f;

static NSString * const kSUCornerTypeButtonImageNormal = @"corner2_button.png";
static NSString * const kSUCornerTypeButtonImageActive = @"corner_button.png";

static NSString * const kSUBorderWidthSliderButtonImageNormal = @"stroke_button.png";
static NSString * const kSUBorderWidthSliderButtonImageActive = @"stroke_button_active.png";

static NSString * const kSUBorderColorPickerButtonImageNormal = @"color_button.png";
static NSString * const kSUBorderColorPickerButtonImageActive = @"color_button_active.png";


@implementation SUMarkViewToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[SUPixelHunterTheme colors] lightGrayBackgroundColor];
        self.userInteractionEnabled = YES;
        
        SUCompositeButtonModel *model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUCornerTypeButtonImageNormal;
        model.imagePressedName = kSUCornerTypeButtonImageActive;
        model.imageActivatedName = kSUCornerTypeButtonImageActive;
        
        self.cornerTypeButton = [[SUMarkViewToolbarCompositeButton alloc] initWithModel:model];
        [self addSubview:self.cornerTypeButton];
        
        model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUBorderWidthSliderButtonImageNormal;
        model.imagePressedName = kSUBorderWidthSliderButtonImageActive;
        model.imageActivatedName = kSUBorderWidthSliderButtonImageActive;
        
        self.borderWidthSliderButton = [[SUMarkViewToolbarCompositeButton alloc] initWithModel:model];
        [self addSubview:self.borderWidthSliderButton];
        
        self.widthSlider = [[UISlider alloc] init];
        self.widthSlider.minimumValue = kSUWidthSliderMinimumValue;
        self.widthSlider.maximumValue = kSUWidthSliderMaximumValue;
        self.widthSlider.value = kSUWidthSliderMinimumValue;
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * -0.5);
        self.widthSlider.transform = transform;
        [self addSubview:self.widthSlider];
        
        model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUBorderColorPickerButtonImageNormal;
        model.imagePressedName = kSUBorderColorPickerButtonImageActive;
        model.imageActivatedName = kSUBorderColorPickerButtonImageActive;
        
        self.borderColorPickerButton = [[SUMarkViewToolbarCompositeButton alloc] initWithModel:model];
        [self addSubview:self.borderColorPickerButton];
        
        self.markColorView = [[SUMarkColorView alloc] init];
        [self addSubview:self.markColorView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.borderWidthSliderButton.frame = CGRectMake(0.0f, 0.0f,
                                                    kSUMarkViewToolbarButtonWidth,
                                                    kSUMarkViewToolbarButtonHeight);
    
    self.borderColorPickerButton.frame = CGRectMake(0.0f,
                                                    CGRectGetMaxY(self.borderWidthSliderButton.frame),
                                                    kSUMarkViewToolbarButtonWidth,
                                                    kSUMarkViewToolbarButtonHeight);
    
    self.cornerTypeButton.frame = CGRectMake(0.0f,
                                             CGRectGetMaxY(self.borderColorPickerButton.frame),
                                             kSUMarkViewToolbarButtonWidth,
                                             kSUMarkViewToolbarButtonHeight);
    
    self.widthSlider.frame = CGRectMake(CGRectGetMaxX(self.borderWidthSliderButton.frame),
                                        kSUSliderStartY,
                                        kSUSliderWidth, kSUSliderHeight);
    
    self.markColorView.frame = CGRectMake(kSUMarkViewToolbarButtonWidth + kSUMarkColorViewIndent,
                                          kSUMarkColorViewStartY,
                                          kSUMarkViewToolbarColorViewWidth, kSUSliderHeight);
}


@end
