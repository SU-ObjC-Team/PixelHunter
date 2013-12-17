//
//  SUGridToolbar.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/9/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridToolbar.h"
#import "SUConstants.h"
#import "SUTheme.h"

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
        self.backgroundColor = [[SUTheme colors] lightGrayBackgroundColor];
        self.userInteractionEnabled = YES;
        
        // Init grid display button
        self.gridDisplayButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"grid_button.png"
                                                                   imageNamePressed:@"grid_button_active.png"
                                                                 imageNameActivated:@"grid_button_active.png"];
        [self addSubview:self.gridDisplayButton];
        
        // Init show picker button
        self.showPickerButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"image_button.png"
                                                                   imageNamePressed:@"image_button_active.png"
                                                                 imageNameActivated:@"image_button_active.png"];
        [self addSubview:self.showPickerButton];
        
        // Init show marking view controller button
        self.showMarkingViewControllerButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"next_button.png"
                                                                  imageNamePressed:@"next_button_active.png"
                                                                imageNameActivated:@"next_button_active.png"];
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
        self.closeButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"close_button.png"
                                                             imageNamePressed:@"close_button_active.png"
                                                           imageNameActivated:@"close_button_active.png"];
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
