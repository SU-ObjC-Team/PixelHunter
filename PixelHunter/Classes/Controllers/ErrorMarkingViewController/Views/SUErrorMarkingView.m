//
//  SUErrorMarkingView.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingView.h"
#import "SUPixelHunterConstants.h"

static CGFloat const kSUToolbarWidth = 88.0f;
static CGFloat const kSUToolbarHeight = 315.0f;
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
                                                (boundsSize.height - kSUToolbarHeight) / 2.0f,
                                                kSUToolbarWidth, kSUToolbarHeight);
        [self addSubview:self.markViewToolbar];
        
        [self.markViewToolbar.borderWidthSliderButton addTarget:self
                                                         action:@selector(showSlider:)];
        [self.markViewToolbar.borderColorPickerButton addTarget:self
                                                         action:@selector(showColorPicker:)];
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
    if (self.markViewToolbar.hidden) {
        [self showToolbarAnimated];
    } else {
        [self hideToolbarAnimated];
    }
}

- (void)showToolbarAnimated
{
    self.markViewToolbar.hidden = NO;
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        CGRect newRect = self.markViewToolbar.frame;
        newRect.origin.x -= newRect.size.width / 2.0f;
        self.markViewToolbar.frame = newRect;
    }];
}

- (void)hideToolbarAnimated
{
    CGSize frameSize = self.frame.size;
    
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        CGRect newRect = self.markViewToolbar.frame;
        newRect.origin.x = frameSize.width;
        self.markViewToolbar.frame = newRect;
    } completion:^(BOOL finished) {
        self.markViewToolbar.hidden = YES;
        self.markViewToolbar.widthSlider.hidden = YES;
        self.markViewToolbar.markColorView.hidden = YES;
    }];
}

#pragma mark - Slider show/hide

- (void)showSlider:(SUMarkViewToolbarCompositeButton *)button
{
    if (self.markViewToolbar.markColorView.hidden) {
        [self showSliderAnimatedWithButton:button];
    } else {
        [self hideSliderAnimatedWithButton:button];
    }
}

- (void)hideSliderAnimatedWithButton:(SUMarkViewToolbarCompositeButton *)button
{
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        CGRect newFrame = self.markViewToolbar.frame;
        newFrame.origin.x += kSUToolbarWidth / 2.0f;
        self.markViewToolbar.frame = newFrame;
        
    } completion:^(BOOL finished) {
        [self showSeparatorWithButton:button];
        self.markViewToolbar.markColorView.hidden = YES;
        self.markViewToolbar.widthSlider.hidden = NO;
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            CGRect newFrame = self.markViewToolbar.frame;
            newFrame.origin.x -= kSUToolbarWidth / 2.0f;
            self.markViewToolbar.frame = newFrame;
        }];
        
    }];
}

- (void)showSliderAnimatedWithButton:(SUMarkViewToolbarCompositeButton *)button
{
    if (self.markViewToolbar.widthSlider.hidden) {
        self.markViewToolbar.widthSlider.hidden = NO;
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            CGRect newFrame = self.markViewToolbar.frame;
            newFrame.origin.x -= kSUToolbarWidth / 2.0f;
            self.markViewToolbar.frame = newFrame;
            
        } completion:^(BOOL finished) {
            [self showSeparatorWithButton:button];
        }];
        
    } else {
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            CGRect newFrame = self.markViewToolbar.frame;
            newFrame.origin.x += kSUToolBarWidth / 2.0f;
            self.markViewToolbar.frame = newFrame;
        } completion:^(BOOL finished) {
            self.markViewToolbar.widthSlider.hidden = YES;
        }];
    }
}

- (void)showColorPicker:(SUMarkViewToolbarCompositeButton *)button
{
    if (!self.markViewToolbar.widthSlider.hidden) {
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            CGRect newFrame = self.markViewToolbar.frame;
            newFrame.origin.x += kSUToolbarWidth / 2.0f;
            self.markViewToolbar.frame = newFrame;
            
        } completion:^(BOOL finished) {
            [self showSeparatorWithButton:button];
            self.markViewToolbar.widthSlider.hidden = YES;
            self.markViewToolbar.markColorView.hidden = NO;
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                newFrame.origin.x -= kSUToolbarWidth / 2.0f;
                self.markViewToolbar.frame = newFrame;
                
            }];
        }];
    } else {
        if (self.markViewToolbar.markColorView.hidden) {
            self.markViewToolbar.markColorView.hidden = NO;
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                newFrame.origin.x -= kSUToolbarWidth / 2.0f;
                self.markViewToolbar.frame = newFrame;
                
            } completion:^(BOOL finished) {
                [self showSeparatorWithButton:button];
            }];
            
        } else {
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                newFrame.origin.x += kSUToolbarWidth / 2.0f;
                self.markViewToolbar.frame = newFrame;
                
            } completion:^(BOOL finished) {
                self.markViewToolbar.markColorView.hidden = YES;
            }];
        }
    }
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
    CGSize frameSize = self.frame.size;
    
    CGSize toolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight / 2.0f);
    
    if (self.errorMarkingToolbar.hidden) {
        self.errorMarkingToolbar.hidden = NO;
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
                self.errorMarkingToolbar.frame = CGRectMake((frameSize.height - toolbarSize.width) / 2.0f,
                                                            frameSize.width - toolbarSize.height,
                                                            toolbarSize.width, toolbarSize.height);
            } else {
                self.errorMarkingToolbar.frame = CGRectMake((frameSize.width - toolbarSize.width) / 2.0f,
                                                            frameSize.height - toolbarSize.height,
                                                            toolbarSize.width, toolbarSize.height);
            }
        }];
    } else {
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
                self.errorMarkingToolbar.frame = CGRectMake((frameSize.height - toolbarSize.width) / 2.0f,
                                                            frameSize.width - toolbarSize.height + kSUToolBarHeight,
                                                            toolbarSize.width, toolbarSize.height);
            } else {
                self.errorMarkingToolbar.frame = CGRectMake((frameSize.width - toolbarSize.width) / 2.0f,
                                                            frameSize.height - toolbarSize.height + kSUToolBarHeight,
                                                            toolbarSize.width, toolbarSize.height);
                self.markViewToolbar.frame = CGRectMake(frameSize.width,
                                                        (frameSize.height - kSUToolbarHeight) / 2.0f,
                                                        kSUToolbarWidth, kSUToolbarHeight);
            }
        } completion:^(BOOL finished) {
            self.errorMarkingToolbar.hidden = YES;
            self.markViewToolbar.hidden = YES;
            self.markViewToolbar.widthSlider.hidden = YES;
            self.markViewToolbar.markColorView.hidden = YES;
        }];
    }
    
    [[[[UIApplication sharedApplication] delegate] window] endEditing:YES];
}

@end
