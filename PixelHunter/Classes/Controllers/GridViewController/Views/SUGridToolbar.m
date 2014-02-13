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
static CGFloat const kSUSliderWidth = 280.0f;
static CGFloat const kSUSliderHeight = 48.0f;
static CGFloat const kSUButtonWidth = 80.0f;
static CGFloat const kSUButtonHeight = 47.0f;

static NSString * const kSUDisplayGridButtonImageNormalName = @"grid_button.png";
static NSString * const kSUDisplayGridButtonImageActiveName = @"grid_button_active.png";

static NSString * const kSUShowPickerButtonImageNormalName = @"image_button.png";
static NSString * const kSUShowPickerButtonImageActiveName = @"image_button_active.png";

static NSString * const kSUShowMarkingViewControllerButtonImageNormalName = @"next_button.png";
static NSString * const kSUShowMarkingViewControllerButtonImageActiveName = @"next_button_active.png";

static NSString * const kSUCloseButtonImageNormalName = @"close_button.png";
static NSString * const kSUCloseButtonImageActiveName = @"close_button_active.png";

static NSString * const kSUSliderTrackImageName = @"slider_line.png";
static NSString * const kSUThumbImageName = @"slider_circle.png";

static NSString * const kSUHorizontalSeparatorImageName = @"gorizontal_separator.png";

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
        
        SUCompositeButtonModel *model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUDisplayGridButtonImageNormalName;
        model.imagePressedName = kSUDisplayGridButtonImageActiveName;
        model.imageActivatedName = kSUDisplayGridButtonImageActiveName;

        self.displayGridButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.displayGridButton];
        
        model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUShowPickerButtonImageNormalName;
        model.imagePressedName = kSUShowPickerButtonImageActiveName;
        model.imageActivatedName = kSUShowPickerButtonImageActiveName;

        self.showPickerButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.showPickerButton];

        model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUShowMarkingViewControllerButtonImageNormalName;
        model.imagePressedName = kSUShowMarkingViewControllerButtonImageActiveName;
        model.imageActivatedName = kSUShowMarkingViewControllerButtonImageActiveName;

        self.showMarkingViewControllerButton = [[SUCompositeButton alloc] initWithModel:model];
        self.showMarkingViewControllerButton.separatorState = SUSeparatorHidden;
        [self addSubview:self.showMarkingViewControllerButton];

        self.slider = [[UISlider alloc] init];
        self.slider.maximumValue = kSUSliderMaximumValue;
        self.slider.minimumValue = kSUSliderMinimumValue;
        self.slider.value = kSUStartAlpha;
        self.slider.enabled = NO;
        [[UISlider appearance] setMaximumTrackImage:[UIImage imageNamed:kSUSliderTrackImageName]
                                           forState:UIControlStateNormal];
        [[UISlider appearance] setMinimumTrackImage:[UIImage imageNamed:kSUSliderTrackImageName]
                                           forState:UIControlStateNormal];
        [[UISlider appearance] setThumbImage:[UIImage imageNamed:kSUThumbImageName]
                                    forState:UIControlStateNormal];
        [self addSubview:self.slider];

        model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUCloseButtonImageNormalName;
        model.imagePressedName = kSUCloseButtonImageActiveName;
        model.imageActivatedName = kSUCloseButtonImageActiveName;

        self.closeButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.closeButton];

        UIImage *separatorImage = [UIImage imageNamed:kSUHorizontalSeparatorImageName];
        self.horizontalSeparatorImageView = [[UIImageView alloc] initWithImage:separatorImage];
        [self addSubview:self.horizontalSeparatorImageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;

    self.slider.frame = CGRectMake(20.0f, 0.0f, kSUSliderWidth, kSUSliderHeight);

    self.horizontalSeparatorImageView.frame = CGRectMake(0.0f, CGRectGetMaxY(self.slider.frame),
                                                         boundsSize.width, 1.0f);

    self.closeButton.frame = CGRectMake(0.0f, CGRectGetMaxY(self.horizontalSeparatorImageView.frame),
                                        kSUButtonWidth, kSUButtonHeight);

    self.displayGridButton.frame = CGRectMake(CGRectGetMaxX(self.closeButton.frame),
                                              CGRectGetMinY(self.closeButton.frame),
                                              kSUButtonWidth, kSUButtonHeight);

    self.showPickerButton.frame = CGRectMake(CGRectGetMaxX(self.displayGridButton.frame),
                                             CGRectGetMinY(self.closeButton.frame),
                                             kSUButtonWidth, kSUButtonHeight);

    self.showMarkingViewControllerButton.frame = CGRectMake(CGRectGetMaxX(self.showPickerButton.frame),
                                                            CGRectGetMinY(self.closeButton.frame),
                                                            kSUButtonWidth, kSUButtonHeight);
}

@end
