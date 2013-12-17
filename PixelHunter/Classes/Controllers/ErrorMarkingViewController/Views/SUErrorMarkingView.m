//
//  SUErrorMarkingView.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingView.h"
#import "SUConstants.h"

@interface SUErrorMarkingView ()

@property (nonatomic, strong) UIImageView *screenshotImageView;

@end


@implementation SUErrorMarkingView

- (id)initWithScreenshotImage:(UIImage *)screenshotImage
{
    self = [super init];
    if (self) {
        // Init screenshot image view
        self.screenshotImageView = [[UIImageView alloc] initWithImage:screenshotImage];
        self.screenshotImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.screenshotImageView];
        
        // Init tapGesture
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapGesture];
        [self.tapGesture addTarget:self action:@selector(viewTapped)];
        
        // Init pinch gesture
        self.pinchGesture = [[UIPinchGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.pinchGesture];

        // Init error marking toolbar
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
        
        // Init mark view toolbar
        self.markViewToolbar = [[SUMarkViewToolbar alloc] init];
        self.markViewToolbar.hidden = YES;
        self.markViewToolbar.frame = CGRectMake(sz.width,
                                                (sz.height - kSUMarkViewToolbarHeight) / 2.0f,
                                                kSUMarkViewToolbarWidth, kSUMarkViewToolbarHeight);
        [self addSubview:self.markViewToolbar];
        
        // Init button actions
        [self.markViewToolbar.borderWidthSliderButton addTarget:self
                                                         action:@selector(showSlider:)];
        [self.markViewToolbar.borderColorPickerButton addTarget:self
                                                         action:@selector(showColorPicker:)];
    }
    
    return self;
}

- (void)layoutSubviews
{
    CGSize sz = [super bounds].size;
    
    // Layout screenshot image view
    self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
}

- (void)showMarkingViewToolbar
{
    CGSize sz = [super bounds].size;
    
    if (self.markViewToolbar.isHidden) {
        self.markViewToolbar.hidden = NO;
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            self.markViewToolbar.frame = CGRectMake(sz.width - kSUMarkViewToolbarWidth / 2.0f,
                                                    (sz.height - kSUMarkViewToolbarHeight) / 2.0f,
                                                    kSUMarkViewToolbarWidth, kSUMarkViewToolbarHeight);
        }];
    } else {
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            self.markViewToolbar.frame = CGRectMake(sz.width,
                                                    (sz.height - kSUMarkViewToolbarHeight) / 2.0f,
                                                    kSUMarkViewToolbarWidth, kSUMarkViewToolbarHeight);
        } completion:^(BOOL finished) {
            self.markViewToolbar.hidden = YES;
            self.markViewToolbar.widthSlider.hidden = YES;
            self.markViewToolbar.markColorView.hidden = YES;
        }];
    }
}

- (void)showSlider:(SUMarkViewToolbarCompositeButton *)button
{
    if (!self.markViewToolbar.markColorView.hidden) {
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            CGRect newFrame = self.markViewToolbar.frame;
            self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUMarkViewToolbarWidth / 2.0f,
                                                    newFrame.origin.y,
                                                    newFrame.size.width, newFrame.size.height);
        } completion:^(BOOL finished) {
            [self showSeparatorWithButton:button];
            self.markViewToolbar.markColorView.hidden = YES;
            self.markViewToolbar.widthSlider.hidden = NO;
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUMarkViewToolbarWidth / 2.0f,
                                                        newFrame.origin.y,
                                                        newFrame.size.width, newFrame.size.height);
            }];

        }];

    } else {
        if (self.markViewToolbar.widthSlider.hidden) {
            self.markViewToolbar.widthSlider.hidden = NO;
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUMarkViewToolbarWidth / 2.0f,
                                                                         newFrame.origin.y,
                                                                         newFrame.size.width, newFrame.size.height);
            } completion:^(BOOL finished) {
                [self showSeparatorWithButton:button];
            }];
            
        } else {
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUMarkViewToolbarWidth / 2.0f,
                                                                         newFrame.origin.y,
                                                                         newFrame.size.width, newFrame.size.height);
            } completion:^(BOOL finished) {
                self.markViewToolbar.widthSlider.hidden = YES;
            }];
        }
    }
}

- (void)showColorPicker:(SUMarkViewToolbarCompositeButton *)button
{
    if (!self.markViewToolbar.widthSlider.hidden) {
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            CGRect newFrame = self.markViewToolbar.frame;
            self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUMarkViewToolbarWidth / 2.0f,
                                                    newFrame.origin.y,
                                                    newFrame.size.width, newFrame.size.height);
        } completion:^(BOOL finished) {
            [self showSeparatorWithButton:button];
            self.markViewToolbar.widthSlider.hidden = YES;
            self.markViewToolbar.markColorView.hidden = NO;
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUMarkViewToolbarWidth / 2.0f,
                                                        newFrame.origin.y,
                                                        newFrame.size.width, newFrame.size.height);
            }];
        }];
    } else {
        if (self.markViewToolbar.markColorView.hidden) {
            self.markViewToolbar.markColorView.hidden = NO;
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x - kSUMarkViewToolbarWidth / 2.0f,
                                                        newFrame.origin.y,
                                                        newFrame.size.width, newFrame.size.height);
            } completion:^(BOOL finished) {
                [self showSeparatorWithButton:button];
            }];
            
        } else {
            [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
                CGRect newFrame = self.markViewToolbar.frame;
                self.markViewToolbar.frame = CGRectMake(newFrame.origin.x + kSUMarkViewToolbarWidth / 2.0f,
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
            button.isSeparatorShown = YES;
        }
    }
    if (button.isSeparatorShown) {
        button.isSeparatorShown = NO;
    } else {
        button.isSeparatorShown = YES;
    }
}

- (void)viewTapped
{
    CGSize sz = [[UIScreen mainScreen] bounds].size;
    
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
                                                        (sz.height - kSUMarkViewToolbarHeight) / 2.0f,
                                                        kSUMarkViewToolbarWidth, kSUMarkViewToolbarHeight);
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
