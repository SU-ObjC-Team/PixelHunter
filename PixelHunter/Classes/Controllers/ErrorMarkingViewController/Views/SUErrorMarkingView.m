//
//  SUErrorMarkingView.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingView.h"
#import "SUPixelHunterConstants.h"

typedef enum {
    SUToolbarStateNone = 0,
    SUToolbarStateHidden,
    SUToolbarStateShown
} SUToolBarState;


static CGFloat const kSUMarkViewToolbarWidth = 88.0f;
static CGFloat const kSUMarkViewToolbarHeight = 315.0f;
static CGFloat const kSUErrorMarkingToolbarWidth = 320.0f;
static CGFloat const kSUErrorMarkingToolbarHeight = 44.0f;


@interface SUErrorMarkingView ()

@property (nonatomic, strong) UIImageView *screenshotImageView;
@property (nonatomic, assign) SUToolBarState markToolbarState;
@property (nonatomic, assign) SUToolBarState mainToolbarState;

@end


@implementation SUErrorMarkingView

- (id)initWithImage:(UIImage *)screenshotImage
{
    self = [super init];
    if (self) {
        [self initScreenshotImageViewWithImage:screenshotImage];
        [self initGestureRecognizers];
        [self initErrorMarkingToolbar];
        [self initMarkViewToolbar];
        [self initActions];
    }
    
    return self;
}

#pragma mark - Initialization methods

- (void)initScreenshotImageViewWithImage:(UIImage *)screenshotImage
{
    self.screenshotImageView = [[UIImageView alloc] initWithImage:screenshotImage];
    self.screenshotImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.screenshotImageView];
}

- (void)initGestureRecognizers
{
    self.tapGesture = [[UITapGestureRecognizer alloc] init];
    [self addGestureRecognizer:self.tapGesture];
    [self.tapGesture addTarget:self action:@selector(onViewTap)];
    
    self.pinchGesture = [[UIPinchGestureRecognizer alloc] init];
    [self addGestureRecognizer:self.pinchGesture];
}

- (void)initErrorMarkingToolbar
{
    self.mainToolbarState = SUToolbarStateHidden;
    self.errorMarkingToolbar = [[SUErrorMarkingToolbar alloc] init];
    SEL displayMarkingViewToolbar = @selector(displayMarkingViewToolbar);
    [self.errorMarkingToolbar.showMarkingViewToolbarButton addTarget:self
                                                              action:displayMarkingViewToolbar];
    [self addSubview:self.errorMarkingToolbar];
}

- (void)initMarkViewToolbar
{
    self.markToolbarState = SUToolbarStateHidden;
    self.markViewToolbar = [[SUMarkViewToolbar alloc] init];
    [self addSubview:self.markViewToolbar];
}

- (void)initActions
{
    [self.markViewToolbar.borderWidthSliderButton addTarget:self
                                                     action:@selector(displaySlider:)];
    [self.markViewToolbar.borderColorPickerButton addTarget:self
                                                     action:@selector(displayColorPicker:)];
    [self showSeparatorWithButton:self.markViewToolbar.borderWidthSliderButton];
}

#pragma mark - Layout methods

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGSize boundsSize = self.bounds.size;
    
    self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f, boundsSize.width, boundsSize.height);
    
    [self layoutMainToolbar];
    [self layoutMarkToolbar];
}

- (void)layoutMainToolbar
{
    CGSize boundsSize = self.bounds.size;
    CGFloat y = self.mainToolbarState == SUToolbarStateHidden ?
                boundsSize.height : boundsSize.height - kSUErrorMarkingToolbarHeight;
    CGRect newFrame = CGRectMake((boundsSize.width - kSUErrorMarkingToolbarWidth) / 2.0f, y,
                                 kSUErrorMarkingToolbarWidth, kSUErrorMarkingToolbarHeight);
    self.errorMarkingToolbar.frame = newFrame;
}

- (void)layoutMarkToolbar
{
    CGSize boundsSize = self.bounds.size;
    CGFloat x = self.markToolbarState == SUToolbarStateHidden ?
                boundsSize.width : boundsSize.width - kSUMarkViewToolbarWidth;
    CGRect newFrame = CGRectMake(x, (boundsSize.height - kSUMarkViewToolbarHeight) / 2.0f,
                                 kSUMarkViewToolbarWidth, kSUMarkViewToolbarHeight);
    self.markViewToolbar.frame = newFrame;
}

#pragma mark - Toolbar show/hide

- (void)displayMarkingViewToolbar
{
    if (self.markToolbarState == SUToolbarStateHidden) {
        [self showMarkingViewToolbarAnimated];
    } else {
        [self hideMarkingViewToolbarAnimated];
    }
}

- (void)showMarkingViewToolbarAnimated
{
    self.markToolbarState = SUToolbarStateShown;
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        [self layoutMarkToolbar];
    }];
}

- (void)hideMarkingViewToolbarAnimated
{
    self.markToolbarState = SUToolbarStateHidden;
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        [self layoutMarkToolbar];
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

//TODO: Discuss solution to remove loop
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

- (void)onViewTap
{
    if (self.mainToolbarState == SUToolbarStateHidden) {
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
    self.mainToolbarState = SUToolbarStateShown;
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        [self layoutMainToolbar];
    }];
}

- (void)hideErrorMarkingToolbarAnimated
{
    self.mainToolbarState = SUToolbarStateHidden;
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        [self layoutMainToolbar];
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
