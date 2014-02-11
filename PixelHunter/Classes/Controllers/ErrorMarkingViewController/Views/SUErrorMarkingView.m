//
//  SUErrorMarkingView.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingView.h"
#import "SUPixelHunterConstants.h"

static CGFloat const kSUMarkViewToolbarWidth = 88.0f;
static CGFloat const kSUMarkViewToolbarHeight = 315.0f;
static CGFloat const kSUErrorMarkingToolbarWidth = 320.0f;
static CGFloat const kSUErrorMarkingToolbarHeight = 44.0f;

@interface SUErrorMarkingView ()

@property (nonatomic, strong) UIImageView *screenshotImageView;

@end


@implementation SUErrorMarkingView

- (id)initWithImage:(UIImage *)screenshotImage
{
    self = [super init];
    if (self) {
        self.screenshotImageView = [[UIImageView alloc] initWithImage:screenshotImage];
        self.screenshotImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.screenshotImageView];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapGesture];
        [self.tapGesture addTarget:self action:@selector(viewTapped)];
        
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.pinchGesture];
        
        [self initErrorMarkingToolbar];
        [self initMarkViewToolbar];
        
        [self.markViewToolbar.borderWidthSliderButton addTarget:self
                                                         action:@selector(displaySlider:)];
        [self.markViewToolbar.borderColorPickerButton addTarget:self
                                                         action:@selector(displayColorPicker:)];
        [self showSeparatorWithButton:self.markViewToolbar.borderWidthSliderButton];
    }
    
    return self;
}

- (void)initErrorMarkingToolbar
{
    self.errorMarkingToolbar = [[SUErrorMarkingToolbar alloc] init];
    self.errorMarkingToolbar.hidden = YES;
    CGSize boundsSize = [[UIScreen mainScreen] bounds].size;
    CGRect toolbarFrame = CGRectMake((boundsSize.width - kSUErrorMarkingToolbarWidth) / 2.0f,
                                     boundsSize.height + kSUErrorMarkingToolbarHeight,
                                     kSUErrorMarkingToolbarWidth, kSUErrorMarkingToolbarHeight);
    self.errorMarkingToolbar.frame = toolbarFrame;
    SEL displayMarkingViewToolbar = @selector(displayMarkingViewToolbar);
    [self.errorMarkingToolbar.showMarkingViewToolbarButton addTarget:self
                                                              action:displayMarkingViewToolbar];
    [self addSubview:self.errorMarkingToolbar];
}

- (void)initMarkViewToolbar
{
    CGSize boundsSize = [[UIScreen mainScreen] bounds].size;
    self.markViewToolbar = [[SUMarkViewToolbar alloc] init];
    self.markViewToolbar.hidden = YES;
    self.markViewToolbar.frame = CGRectMake(boundsSize.width,
                                            (boundsSize.height - kSUMarkViewToolbarHeight) / 2.0f,
                                            kSUMarkViewToolbarWidth, kSUMarkViewToolbarHeight);
    [self addSubview:self.markViewToolbar];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize imageSize = self.screenshotImageView.image.size;
    
    self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
}

#pragma mark - Toolbar show/hide

- (void)displayMarkingViewToolbar
{
    if (self.markViewToolbar.hidden) {
        [self showMarkingViewToolbarAnimated];
    } else {
        [self hideMarkingViewToolbarAnimated];
    }
}

- (void)showMarkingViewToolbarAnimated
{
    self.markViewToolbar.hidden = NO;
    CGSize frameSize = self.frame.size;
    CGRect newFrame = self.markViewToolbar.frame;
    
    if ([self isLandscape]) {
        frameSize = CGSizeMake(frameSize.height, frameSize.width);
    }
    
    newFrame.origin = CGPointMake(frameSize.width - newFrame.size.width,
                                  (frameSize.height - newFrame.size.height) / 2.0f);
    
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        self.markViewToolbar.frame = newFrame;
    }];
}

- (void)hideMarkingViewToolbarAnimated
{
    CGSize frameSize = self.frame.size;
    CGRect newFrame = self.markViewToolbar.frame;
    
    if ([self isLandscape]) {
        frameSize = CGSizeMake(frameSize.height, frameSize.width);
    }
    
    newFrame.origin = CGPointMake(frameSize.width,
                                  (frameSize.height - newFrame.size.height) / 2.0f);
    
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        self.markViewToolbar.frame = newFrame;
    } completion:^(BOOL finished) {
        self.markViewToolbar.hidden = YES;
    }];
}

#pragma mark - Display Slider/Color picker

- (void)displaySlider:(SUMarkViewToolbarCompositeButton *)button
{
    [self showSeparatorWithButton:button];
    self.markViewToolbar.markColorView.hidden = YES;
    self.markViewToolbar.widthSlider.hidden = NO;
}

- (void)displayColorPicker:(SUMarkViewToolbarCompositeButton *)button
{
    [self showSeparatorWithButton:button];
    self.markViewToolbar.markColorView.hidden = NO;
    self.markViewToolbar.widthSlider.hidden = YES;
}

- (void)showSeparatorWithButton:(SUMarkViewToolbarCompositeButton *)button
{
    for (SUMarkViewToolbarCompositeButton *button in [self.markViewToolbar subviews]) {
        if ([button isKindOfClass:[SUMarkViewToolbarCompositeButton class]]) {
            button.separatorState = SUSeparatorShown;
        }
    }
    
    button.separatorState = button.separatorState == SUSeparatorShown ?
    SUSeparatorHidden : SUSeparatorShown;
}

- (void)viewTapped
{    
    if (self.errorMarkingToolbar.hidden) {
        [self showErrorMarkingToolbarAnimated];
        
    } else {
        [self hideErrorMarkingToolbarAnimated];
        [self hideMarkingViewToolbarAnimated];
    }
    
    UIWindow *applicationWindow = [[[UIApplication sharedApplication] delegate] window];
    [applicationWindow endEditing:YES];
}

- (void)showErrorMarkingToolbarAnimated
{
    self.errorMarkingToolbar.hidden = NO;
    CGSize frameSize = self.frame.size;
    CGRect newFrame = self.errorMarkingToolbar.frame;

    if ([self isLandscape]) {
        frameSize = CGSizeMake(frameSize.height, frameSize.width);
    }
    
    newFrame.origin = CGPointMake((frameSize.width - newFrame.size.width) / 2.0f,
                                      frameSize.height - newFrame.size.height);
    
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        self.errorMarkingToolbar.frame = newFrame;
    }];
}

- (void)hideErrorMarkingToolbarAnimated
{
    CGSize frameSize = self.frame.size;
    CGRect newFrame = self.errorMarkingToolbar.frame;
    
    if ([self isLandscape]) {
        frameSize = CGSizeMake(frameSize.height, frameSize.width);
    }
    
    newFrame.origin = CGPointMake((frameSize.width - newFrame.size.width) / 2.0f,
                                  frameSize.height + newFrame.size.height);
    
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        self.errorMarkingToolbar.frame = newFrame;
    } completion:^(BOOL finished) {
        self.errorMarkingToolbar.hidden = YES;
    }];
}

- (BOOL)isLandscape
{
    BOOL result = NO;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        result = YES;
    }
    
    return result;
}

@end
