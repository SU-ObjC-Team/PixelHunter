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
        model.imageNormalName = @"grid_button.png";
        model.imagePressedName = @"grid_button_active.png";
        model.imageActivatedName = @"grid_button_active.png";

        self.displayGridButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.displayGridButton];
        
        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"image_button.png";
        model.imagePressedName = @"image_button_active.png";
        model.imageActivatedName = @"image_button_active.png";

        self.showPickerButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.showPickerButton];

        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"next_button.png";
        model.imagePressedName = @"next_button_active.png";
        model.imageActivatedName = @"next_button_active.png";

        self.showMarkingViewControllerButton = [[SUCompositeButton alloc] initWithModel:model];
        self.showMarkingViewControllerButton.separatorState = SUSeparatorHidden;
        [self addSubview:self.showMarkingViewControllerButton];

        self.slider = [[UISlider alloc] init];
        self.slider.maximumValue = kSUSliderMaximumValue;
        self.slider.minimumValue = kSUSliderMinimumValue;
        self.slider.value = kSUStartAlpha;
        self.slider.enabled = NO;
        [[UISlider appearance] setMaximumTrackImage:[UIImage imageNamed:@"slider_line"]
                                           forState:UIControlStateNormal];
        [[UISlider appearance] setMinimumTrackImage:[UIImage imageNamed:@"slider_line"]
                                           forState:UIControlStateNormal];
        [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"slider_circle"]
                                    forState:UIControlStateNormal];
        [self addSubview:self.slider];

        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"close_button.png";
        model.imagePressedName = @"close_button_active.png";
        model.imageActivatedName = @"close_button_active.png";

        self.closeButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.closeButton];

        self.horizontalSeparatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gorizontal_separator.png"]];
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
