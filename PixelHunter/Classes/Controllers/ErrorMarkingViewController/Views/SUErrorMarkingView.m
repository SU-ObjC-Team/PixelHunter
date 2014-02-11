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
        CGSize sz = [[UIScreen mainScreen] bounds].size;
        
        CGSize errorMarkingToolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight / 2.0f);
        
        self.errorMarkingToolbar.frame = CGRectMake(sz.width / 2.0f - errorMarkingToolbarSize.width / 2.0f,
                                        sz.height - errorMarkingToolbarSize.height + kSUToolBarHeight,
                                        errorMarkingToolbarSize.width, errorMarkingToolbarSize.height);
        [self.errorMarkingToolbar.showMarkingViewToolbarButton addTarget:self
                                                                  action:@selector(showMarkingViewToolbar)];
        [self addSubview:self.errorMarkingToolbar];
        
        self.markViewToolbar = [[SUMarkViewToolbar alloc] init];
        self.markViewToolbar.hidden = YES;
        self.markViewToolbar.frame = CGRectMake(sz.width,
                                                (sz.height - kSUToolbarHeight) / 2.0f,
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
    
    self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f,
                                                imageSize.width,
                                                imageSize.height);
}

#pragma mark - Toolbar show/hide

- (void)showMarkingViewToolbar
{
    if (self.markViewToolbar.isHidden) {
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
    CGSize sz = self.frame.size;

    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        CGRect newRect = self.markViewToolbar.frame;
        newRect.origin.x = sz.width;
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
        self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUToolbarWidth / 2.0f,
                                                newFrame.origin.y,
                                                newFrame.size.width, newFrame.size.height);
    } completion:^(BOOL finished) {
        [self showSeparatorWithButton:button];
        self.markViewToolbar.markColorView.hidden = YES;
        self.markViewToolbar.widthSlider.hidden = NO;
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            CGRect newFrame = self.markViewToolbar.frame;
            self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUToolbarWidth / 2.0f,
                                                    newFrame.origin.y,
                                                    newFrame.size.width, newFrame.size.height);
        }];
        
    }];
}

- (void)showSliderAnimatedWithButton:(SUMarkViewToolbarCompositeButton *)button
{
    if (self.markViewToolbar.widthSlider.hidden) {
        self.markViewToolbar.widthSlider.hidden = NO;
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            CGRect newFrame = self.markViewToolbar.frame;
            self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUToolbarWidth / 2.0f,
                                                    newFrame.origin.y,
                                                    newFrame.size.width, newFrame.size.height);
        } completion:^(BOOL finished) {
            [self showSeparatorWithButton:button];
        }];
        
    } else {
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            CGRect newFrame = self.markViewToolbar.frame;
            self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUToolbarWidth / 2.0f,
                                                    newFrame.origin.y,
                                                    newFrame.size.width, newFrame.size.height);
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
            self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUToolbarWidth / 2.0f,
                                                    newFrame.origin.y,
                                                    newFrame.size.width, newFrame.size.height);
        } completion:^(BOOL finished) {
            [self showSeparatorWithButton:button];
            self.markViewToolbar.widthSlider.hidden = YES;
            self.markViewToolbar.markColorView.hidden = NO;
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUToolbarWidth / 2.0f,
                                                        newFrame.origin.y,
                                                        newFrame.size.width, newFrame.size.height);
            }];
        }];
    } else {
        if (self.markViewToolbar.markColorView.hidden) {
            self.markViewToolbar.markColorView.hidden = NO;
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUToolbarWidth / 2.0f,
                                                        newFrame.origin.y,
                                                        newFrame.size.width, newFrame.size.height);
            } completion:^(BOOL finished) {
                [self showSeparatorWithButton:button];
            }];
            
        } else {
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUToolbarWidth / 2.0f,
                                                        newFrame.origin.y,
                                                        newFrame.size.width, newFrame.size.height);
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
    CGSize sz = self.frame.size;
    
    CGSize toolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight / 2.0f);
    
    if (self.errorMarkingToolbar.isHidden) {
        self.errorMarkingToolbar.hidden = NO;
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
                    self.errorMarkingToolbar.frame = CGRectMake(sz.height / 2.0f - toolbarSize.width / 2.0f,
                                                    sz.width - toolbarSize.height,
                                                    toolbarSize.width, toolbarSize.height);
                } else {
                    self.errorMarkingToolbar.frame = CGRectMake(sz.width / 2.0f - toolbarSize.width / 2.0f,
                                                                sz.height - toolbarSize.height,
                                                                toolbarSize.width, toolbarSize.height);
            }
        }];
    } else {
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
                self.errorMarkingToolbar.frame = CGRectMake(sz.height / 2.0f - toolbarSize.width / 2.0f,
                                                            sz.width - toolbarSize.height + kSUToolBarHeight,
                                                            toolbarSize.width, toolbarSize.height);
            } else {
                self.errorMarkingToolbar.frame = CGRectMake(sz.width / 2.0f - toolbarSize.width / 2.0f,
                                                sz.height - toolbarSize.height + kSUToolBarHeight,
                                                toolbarSize.width, toolbarSize.height);
                self.markViewToolbar.frame = CGRectMake(sz.width,
                                                        (sz.height - kSUToolbarHeight) / 2.0f,
                                                        kSUToolbarWidth, kSUToolbarHeight);
            }
        } completion:^(BOOL finished) {
            self.errorMarkingToolbar.hidden = YES;
            self.markViewToolbar.hidden = YES;
            self.markViewToolbar.widthSlider.hidden = YES;
            self.markViewToolbar.markColorView.hidden = YES;
        }];
    }
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
