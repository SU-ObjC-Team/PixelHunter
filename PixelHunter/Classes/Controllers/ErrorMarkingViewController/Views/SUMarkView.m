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
#import "SUPixelHunterPositioningUtility.h"


static NSString * const kSUTransfromrRotationName = @"transform.rotation";
static CGFloat const kSUTransformRotationValue = 0.05f;
static CGFloat const kSURemovableViewShakeAnimationTime = 0.1f;
static NSString * const kSUCloseButtonName = @"close_button.png";
static CGRect const kSUMarkViewRemoveButtonFrame = {{10.0f, 10.0f}, {30.0f, 30.0f}};
static CGFloat const kSUCornerRadius = 10.0f;
static CGFloat const kSUZeroCornerRadius = 0.0f;
static NSString * const kSUShakingAnimationKey = @"shakingAnimation";

@interface SUMarkView ()

@property (nonatomic, strong) UIView *gestureView;

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
        self.cornerType = SUMarkViewCornerTypeRound;
        
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
        self.removeButton.hidden = YES;
        [self addSubview:self.removeButton];
    }
    
    return self;
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer
{
    SUMarkView *markView = (SUMarkView *)recognizer.view;
    [self.delegate panGestureActivatedWithView:markView];
    CGPoint translation = [recognizer translationInView:self.gestureView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.gestureView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x,
                                         recognizer.view.center.y);
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.gestureView.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.gestureView.bounds.size.height);
        
        [SUPixelHunterPositioningUtility moveViewAnimated:recognizer.view
                                            toVisibleRect:recognizer.view.superview.bounds];
    }
}

#pragma mark - Public

- (void)addDeleteButtonTarget:(id)target selector:(SEL)selector
{
    [self.removeButton removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self.removeButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - Properties

- (void)setIsDeletingAnimationOn:(BOOL)isDeletingAnimationOn
{
    _isDeletingAnimationOn = isDeletingAnimationOn;
    
    if (self.isDeletingAnimationOn == YES) {
        
        self.removeButton.hidden = NO;
        CAAnimation *animation = [self shakingViewAnimation];
        [self.layer addAnimation:animation forKey:kSUShakingAnimationKey];
    } else {
        
        self.removeButton.hidden = YES;
        [self.layer removeAnimationForKey:kSUShakingAnimationKey];
    }
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

- (void)setCornerType:(SUMarkViewCornerType)cornerType
{
    _cornerType = cornerType;
    
    switch (cornerType) {
        case SUMarkViewCornerTypeNone:
        case SUMarkViewCornerTypeCorner:
            self.layer.cornerRadius = kSUZeroCornerRadius;
            break;

        case SUMarkViewCornerTypeRound:
            self.layer.cornerRadius = kSUCornerRadius;
            break;
            
        default:
            break;
    }
}

@end
