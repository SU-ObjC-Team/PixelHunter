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

@implementation SUMarkViewToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[SUPixelHunterTheme colors] lightGrayBackgroundColor];
        self.userInteractionEnabled = YES;
        
        // Init add markingview button
        SUCompositeButtonModel *model = [SUCompositeButtonModel new];
        model.imageNormalName = @"corner2_button.png";
        model.imagePressedName = @"corner_button.png";
        model.imageActivatedName = @"corner_button.png";
        
        self.cornerTypeButton = [[SUMarkViewToolbarCompositeButton alloc] initWithModel:model];
        [self addSubview:self.cornerTypeButton];
        
        // Init border width slider button
        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"stroke_button.png";
        model.imagePressedName = @"stroke_button_active.png";
        model.imageActivatedName = @"stroke_button_active.png";
        
        self.borderWidthSliderButton = [[SUMarkViewToolbarCompositeButton alloc] initWithModel:model];
        [self addSubview:self.borderWidthSliderButton];
        
        // Init width slider
        self.widthSlider = [[UISlider alloc] init];
        self.widthSlider.minimumValue = 1.0f;
        self.widthSlider.maximumValue = 4.0f;
        self.widthSlider.value = 1.0f;
        self.widthSlider.hidden = YES;
        CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI * 0.5);
        self.widthSlider.transform = transform;
        [self addSubview:self.widthSlider];
        
        // Init border color picker button
        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"color_button.png";
        model.imagePressedName = @"color_button_active.png";
        model.imageActivatedName = @"color_button_active.png";
        
        self.borderColorPickerButton = [[SUMarkViewToolbarCompositeButton alloc] initWithModel:model];
        [self addSubview:self.borderColorPickerButton];
        
        // Init mark color view
        self.markColorView = [[SUMarkColorView alloc] init];
        [self addSubview:self.markColorView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Layout border width slider button
    self.borderWidthSliderButton.frame = CGRectMake(0.0f, 0.0f,
                                                    kSUMarkViewToolbarButtonWidth, kSUMarkViewToolbarButtonHeight);
    
    // Layout border color picker button
    self.borderColorPickerButton.frame = CGRectMake(0.0f, CGRectGetMaxY(self.borderWidthSliderButton.frame),
                                                    kSUMarkViewToolbarButtonWidth, kSUMarkViewToolbarButtonHeight);
    
    // Layout add markingview button
    self.cornerTypeButton.frame = CGRectMake(0.0f, CGRectGetMaxY(self.borderColorPickerButton.frame),
                                             kSUMarkViewToolbarButtonWidth, kSUMarkViewToolbarButtonHeight);
    
    // Layout width slider
    self.widthSlider.frame = CGRectMake(CGRectGetMaxX(self.borderWidthSliderButton.frame), kSUSliderStartY,
                                        kSUSliderWidth, kSUSliderHeight);
    
    // Layout mark color view
    self.markColorView.frame = CGRectMake(kSUMarkViewToolbarButtonWidth + kSUMarkColorViewIndent, kSUMarkColorViewStartY,
                                          kSUMarkViewToolbarColorViewWidth, kSUSliderHeight);
}


@end
