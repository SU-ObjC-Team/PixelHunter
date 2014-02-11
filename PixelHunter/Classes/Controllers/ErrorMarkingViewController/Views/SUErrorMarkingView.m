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
        
        self.errorMarkingToolbar = [[SUErrorMarkingToolbar alloc] init];
        self.errorMarkingToolbar.hidden = YES;
        CGSize boundsSize = [[UIScreen mainScreen] bounds].size;
        CGRect toolbarFrame = CGRectMake((boundsSize.width - kSUErrorMarkingToolbarWidth) / 2.0f,
                                         boundsSize.height + kSUErrorMarkingToolbarHeight,
                                         kSUErrorMarkingToolbarWidth, kSUErrorMarkingToolbarHeight);
        self.errorMarkingToolbar.frame = toolbarFrame;
        SEL showMarkingViewToolbar = @selector(showMarkingViewToolbar);
        [self.errorMarkingToolbar.showMarkingViewToolbarButton addTarget:self
                                                                  action:showMarkingViewToolbar];
        [self addSubview:self.errorMarkingToolbar];
        
        self.markViewToolbar = [[SUMarkViewToolbar alloc] init];
        self.markViewToolbar.hidden = YES;
        self.markViewToolbar.frame = CGRectMake(boundsSize.width,
                                                (boundsSize.height - kSUMarkViewToolbarHeight) / 2.0f,
                                                kSUMarkViewToolbarWidth, kSUMarkViewToolbarHeight);
        [self addSubview:self.markViewToolbar];
        
        [self.markViewToolbar.borderWidthSliderButton addTarget:self
                                                         action:@selector(displaySlider:)];
        [self.markViewToolbar.borderColorPickerButton addTarget:self
                                                         action:@selector(displayColorPicker:)];
        [self showSeparatorWithButton:self.markViewToolbar.borderWidthSliderButton];
    }
    
    return self;
}

- (void)layoutSubviews
{
    CGSize imageSize = self.screenshotImageView.image.size;
    
    self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
}

#pragma mark - Toolbar show/hide

- (void)showMarkingViewToolbar
{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (self.markViewToolbar.hidden) {
        [self showToolbarAnimatedWithOrientation:orientation];
    } else {
        [self hideToolbarAnimatedWithOrientation:orientation];
    }
}

- (void)showToolbarAnimatedWithOrientation:(UIInterfaceOrientation)orientation
{
    self.markViewToolbar.hidden = NO;
    
    CGSize frameSize = self.frame.size;
    CGRect newFrame = self.markViewToolbar.frame;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        newFrame.origin = CGPointMake(frameSize.height - newFrame.size.width,
                                      (frameSize.width - newFrame.size.height) / 2.0f);
    } else {
        newFrame.origin = CGPointMake(frameSize.width - newFrame.size.width,
                                      (frameSize.height - newFrame.size.height) / 2.0f);
    }
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        self.markViewToolbar.frame = newFrame;
    }];
}

- (void)hideToolbarAnimatedWithOrientation:(UIInterfaceOrientation)orientation
{
    CGSize frameSize = self.frame.size;
    CGRect newFrame = self.markViewToolbar.frame;
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        newFrame.origin = CGPointMake(frameSize.height,
                                      (frameSize.width - newFrame.size.height) / 2.0f);
    } else {
        newFrame.origin = CGPointMake(frameSize.width,
                                      (frameSize.height - newFrame.size.height) / 2.0f);
    }
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
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (self.errorMarkingToolbar.hidden) {
        [self showErrorMarkingToolbarWithOrientation:orientation];
        
    } else {
        [self hideErrorMarkingToolbarWithOrientatiom:orientation];
        [self hideToolbarAnimatedWithOrientation:orientation];
    }
    
    UIWindow *applicationWindow = [[[UIApplication sharedApplication] delegate] window];
    [applicationWindow endEditing:YES];
}

- (void)showErrorMarkingToolbarWithOrientation:(UIInterfaceOrientation)orientation
{
    self.errorMarkingToolbar.hidden = NO;
    CGSize frameSize = self.frame.size;
    CGRect newFrame = self.errorMarkingToolbar.frame;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        newFrame.origin = CGPointMake((frameSize.height - newFrame.size.width) / 2.0f,
                                      frameSize.width - newFrame.size.height);
    } else {
        newFrame.origin = CGPointMake((frameSize.width - newFrame.size.width) / 2.0f,
                                      frameSize.height - newFrame.size.height);
    }
    
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        self.errorMarkingToolbar.frame = newFrame;
    }];
}

- (void)hideErrorMarkingToolbarWithOrientatiom:(UIInterfaceOrientation)orientation
{
    CGSize frameSize = self.frame.size;
    CGRect newFrame = self.errorMarkingToolbar.frame;
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        newFrame.origin = CGPointMake((frameSize.height - newFrame.size.width) / 2.0f,
                                      frameSize.width + newFrame.size.height) ;
    } else {
        newFrame.origin = CGPointMake((frameSize.width - newFrame.size.width) / 2.0f,
                                      frameSize.height + newFrame.size.height);
    }
    
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        self.errorMarkingToolbar.frame = newFrame;
    } completion:^(BOOL finished) {
        self.errorMarkingToolbar.hidden = YES;
    }];
}

@end
