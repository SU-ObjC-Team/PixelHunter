//
//  SUMarkView.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUMarkView.h"
#import "SUPixelHunterConstants.h"
#import "SUPixelHunterTheme.h"

static NSString * const kSUTransfromrRotationName = @"transform.rotation";
static const CGFloat kSUTransformRotationValue = 0.05f;
static CGFloat const kSURemovableViewShakeAnimationTime = 0.1f;
static NSString * const kSUCloseButtonName = @"close_button.png";
static CGRect const kSUMarkViewRemoveButtonFrame = {{10.0f, 10.0f}, {30.0f, 30.0f}};


@interface SUMarkView ()

@property (nonatomic, strong) UIView *gestureView;
@property (nonatomic, strong) UIButton *removeButton;

@end


@implementation SUMarkView

- (id)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.gestureView = view;
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(2.0f, 2.0f);
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = kSUCornerRadius;
        self.isActive = NO;
        self.selectedColorCenter = CGPointMake(kSUColorViewRect.size.width / 2, kSUColorViewRect.size.height / 2);
        
        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapGesture];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.panGesture];
        [self.panGesture addTarget:self action:@selector(handlePan:)];
        
        self.longPressGesture = [[UILongPressGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.longPressGesture];

        self.removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.removeButton setBackgroundImage:[UIImage imageNamed:kSUCloseButtonName] forState:UIControlStateNormal];
        self.removeButton.backgroundColor = [[SUPixelHunterTheme colors] darkGrayBackgroundColor];
        self.removeButton.frame = kSUMarkViewRemoveButtonFrame;
    }
    
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    [self.delegate panGestureActivated:recognizer];
    CGPoint translation = [recognizer translationInView:self.gestureView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.gestureView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x,
                                         recognizer.view.center.y);
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.gestureView.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.gestureView.bounds.size.height);
        [self returnView:recognizer.view toVisiblePositionOnParentView:recognizer.view.superview];
    }
}

- (void)returnView:(UIView *)view toVisiblePositionOnParentView:(UIView *)parentView
{
    CGRect newFrame = view.frame;
    if (view.frame.origin.y < parentView.frame.origin.y) {
        newFrame.origin.y = parentView.frame.origin.y;
    }
    if (view.frame.origin.x < parentView.frame.origin.x) {
        newFrame.origin.x = parentView.frame.origin.x;
    }
    if (view.frame.origin.x + view.frame.size.width > parentView.frame.size.width) {
        newFrame.origin.x = parentView.frame.size.width - view.frame.size.width;
    }
    if (view.frame.origin.y + view.frame.size.height > parentView.frame.size.height) {
        newFrame.origin.y = parentView.frame.size.height - view.frame.size.height;
    }
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        view.frame = newFrame;
    }];
}

- (void)setIsActive:(BOOL)isActive
{
    if (isActive) {
        self.layer.shadowOpacity = 1.0f;
    } else {
        self.layer.shadowOpacity = 0.0f;
    }
    _isActive = isActive;
}

#pragma mark - Public

- (void)addShakingAnimationWithTarget:(id)target selector:(SEL)selector
{
    CAAnimation *animation = [self shakingViewAnimation];
    [self.layer addAnimation:animation forKey:kSUShakingAnimationKey];
    
    [self.removeButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self.removeButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.removeButton];
}

- (void)removeShakingAnimation
{
    [self.layer removeAnimationForKey:kSUShakingAnimationKey];
    
    [self.removeButton removeFromSuperview];
}

#pragma mark - Private

- (CAAnimation *)shakingViewAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:kSUTransfromrRotationName];
    NSNumber *value1 = [NSNumber numberWithFloat:-kSUTransformRotationValue];
    NSNumber *value2 = [NSNumber numberWithFloat:kSUTransformRotationValue];
    animation.values = [NSArray arrayWithObjects:value1, value2, nil];
    animation.duration = kSURemovableViewShakeAnimationTime;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    
    return animation;
}

@end
