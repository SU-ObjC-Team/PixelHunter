//
//  SUGridToolbar.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/9/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridToolbar.h"
#import "SUPixelHunterConstants.h"
#import "SUPixelHunterTheme.h"

static CGFloat const kSUSliderMinimumValue = 0.1f;
static CGFloat const kSUSliderMaximumValue = 1.0f;

@interface SUGridToolbar ()

@property (nonatomic, strong) UIImageView *horizontalSeparatorImageView;

@end


@implementation SUGridToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[SUPixelHunterTheme colors] lightGrayBackgroundColor];
        self.userInteractionEnabled = YES;
        
        // Init grid display button
        SUCompositeButtonModel *model = [SUCompositeButtonModel new];
        model.imageNormalName = @"grid_button.png";
        model.imagePressedName = @"grid_button_active.png";
        model.imageActivatedName = @"grid_button_active.png";

        self.gridDisplayButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.gridDisplayButton];
        
        // Init show picker button
        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"image_button.png";
        model.imagePressedName = @"image_button_active.png";
        model.imageActivatedName = @"image_button_active.png";

        self.showPickerButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.showPickerButton];
        
        // Init show marking view controller button
        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"next_button.png";
        model.imagePressedName = @"next_button_active.png";
        model.imageActivatedName = @"next_button_active.png";

        self.showMarkingViewControllerButton = [[SUCompositeButton alloc] initWithModel:model];
        self.showMarkingViewControllerButton.isSeparatorShown = NO;
        [self addSubview:self.showMarkingViewControllerButton];
        
        // Init slider
        self.slider = [[UISlider alloc] init];
        self.slider.maximumValue = kSUSliderMaximumValue;
        self.slider.minimumValue = kSUSliderMinimumValue;
        self.slider.value = kSUStartAlpha;
        self.slider.enabled = NO;
        [[UISlider appearance] setMaximumTrackImage:[UIImage imageNamed:@"slider_line"] forState:UIControlStateNormal];
        [[UISlider appearance] setMinimumTrackImage:[UIImage imageNamed:@"slider_line"] forState:UIControlStateNormal];
        [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"slider_circle"] forState:UIControlStateNormal];
        [self addSubview:self.slider];
        
        // Init close button
        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"close_button.png";
        model.imagePressedName = @"close_button_active.png";
        model.imageActivatedName = @"close_button_active.png";

        self.closeButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.closeButton];
        
        // Init horizontal separator
        self.horizontalSeparatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gorizontal_separator.png"]];
        [self addSubview:self.horizontalSeparatorImageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sz = self.bounds.size;
    
    // Layout slider
    self.slider.frame = CGRectMake(20.0f, 0.0f, 280.0f, kSUToolBarHeight / 2);
    
    // Layout horizontal separator
    self.horizontalSeparatorImageView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.slider.frame), sz.width, 1.0f);
    
    // Layout close button
    self.closeButton.frame = CGRectMake(0.0f, CGRectGetMaxY(self.horizontalSeparatorImageView.frame), kSUCloseButtonWidth, kSUCloseButtonHeight);
    
    // Layout grid display button
    self.gridDisplayButton.frame = CGRectMake(CGRectGetMaxX(self.closeButton.frame), CGRectGetMinY(self.closeButton.frame), kSUCloseButtonWidth, kSUCloseButtonHeight);
    
    // Layout show picker button
    self.showPickerButton.frame = CGRectMake(CGRectGetMaxX(self.gridDisplayButton.frame), CGRectGetMinY(self.closeButton.frame), kSUCloseButtonWidth, kSUCloseButtonHeight);
    
    // Layout show marking view controller button
    self.showMarkingViewControllerButton.frame = CGRectMake(CGRectGetMaxX(self.showPickerButton.frame), CGRectGetMinY(self.closeButton.frame), kSUCloseButtonWidth, kSUCloseButtonHeight);
    
    
}

@end
