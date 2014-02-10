//
//  SUErrorMarkingViewController.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingViewController.h"
#import "SUErrorMarkingView.h"
#import "SUShareController.h"
#import "SUPixelHunterConstants.h"
#import "SUTextMarkView.h"
#import "SUPixelHunterTheme.h"

static CGRect const kSUMarkViewFrame = {{50.0f, 50.0f}, {150.0f, 150.0f}};
static CGRect const kSUMarkViewRemoveButtonFrame = {{10.0f, 10.0f}, {30.0f, 30.0f}};
static CGFloat const kSUMinValidScale = 0.8f;
static CGFloat const kSUMaxValidScale = 2.0f;
static CGFloat const kSUScaleRestraintStartValue = 1.5f;
static NSString * const kSUShakingAnimationKey = @"shakingAnimation";
static CGFloat const kSUMinimumViewSideSize = 25.0f;
static CGFloat const kSUNewMarkViewIndent = 20.0f;
static CGFloat const kSURemovableViewShakeAnimationTime = 0.1f;


@interface SUErrorMarkingViewController () <UIGestureRecognizerDelegate,
                                            SUMarkViewDelegate,
                                            SUMarkColorViewDelegate>

@property (nonatomic, strong) UIImage *screenshotImage;
@property (nonatomic, strong) NSMutableArray *markViewsArray;
@property (nonatomic, strong) SUErrorMarkingView *rootView;
@property (nonatomic, strong) SUShareController *shareController;
@property (nonatomic, assign) CGFloat horizontalScale;
@property (nonatomic, assign) CGFloat verticalScale;
@property (nonatomic, assign) CGRect tempTextMarkViewRect;

@end


@implementation SUErrorMarkingViewController

- (id)initWithImage:(UIImage *)screenshotImage
{
    self = [super init];
	if (self) {
		self.screenshotImage = screenshotImage;
	}
    
	return self;
}

- (void)loadView
{
    SUErrorMarkingView *view = [[SUErrorMarkingView alloc] initWithImage:self.screenshotImage];
    view.contentMode = UIViewContentModeScaleAspectFit;
    self.view = view;
    self.rootView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.markViewsArray = [NSMutableArray array];
    
    [self subscribeForKeyboardAppearance];
    [self initShareController];
    [self initErrorMarkingToolbarActions];
    [self initMarkViewToolbar];
    [self addGestureRecognizers];
}

- (void)initShareController
{
    NSArray *menuViewsArray = @[self.rootView.errorMarkingToolbar,
                                self.rootView.markViewToolbar];

    self.shareController = [[SUShareController alloc] initWithToolbar:self.rootView.errorMarkingToolbar
                                                   withMenuViewsArray:menuViewsArray
                                                     onViewController:self];
}

- (void)initErrorMarkingToolbarActions
{
    SUErrorMarkingToolbar *toolbar = self.rootView.errorMarkingToolbar;

    [toolbar.addMarkingViewButton addTarget:self action:@selector(addMarkView)];
    [toolbar.addTextMarkingViewButton addTarget:self action:@selector(addTextMarkView)];
    [toolbar.backButton addTarget:self action:@selector(showPreviousViewController)];
}

- (void)initMarkViewToolbar
{
    SUMarkViewToolbar *toolbar = self.rootView.markViewToolbar;
    [toolbar.cornerTypeButton addTarget:self action:@selector(switchMarkViewCornerType)];
    toolbar.markColorView.delegate = self;
    [toolbar.widthSlider addTarget:self
                            action:@selector(changeBorderWidth:)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)addGestureRecognizers
{
    [self.rootView.pinchGesture addTarget:self action:@selector(handlePinch:)];
    [self.rootView.tapGesture addTarget:self action:@selector(stopShakingAnimation)];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Notifications

- (void)subscribeForKeyboardAppearance
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Marking views methods

- (void)addMarkView
{
    [self addMarkViewWithText:NO];
}

- (void)addTextMarkView
{
    [self addMarkViewWithText:YES];
}

- (void)addMarkViewWithText:(BOOL)withText
{
    [self stopShakingAnimation];
    self.rootView.errorMarkingToolbar.showMarkingViewToolbarButton.hidden = NO;
    
    [self deactivateAllMarkViews];

    SUMarkView *markView = nil;
    CGRect markViewFrame = [self nextMarkViewFrame];
    if (withText) {
        markView = [[SUTextMarkView alloc] initWithFrame:markViewFrame withView:self.rootView];
    } else {
        markView = [[SUMarkView alloc] initWithFrame:markViewFrame withView:self.rootView];
    }
    
    // Setup new marking view
    [self setupMarkView:markView];
    [self.markViewsArray addObject:markView];
}

- (void)removeMarkView:(UIButton *)sender
{
    SUMarkView *markView = (SUMarkView *)sender.superview;
    [markView removeFromSuperview];
    [self.markViewsArray removeObject:markView];
    
    if ([self.markViewsArray count] == 0) {
        self.rootView.errorMarkingToolbar.showMarkingViewToolbarButton.hidden = YES;
    }
}

- (CGRect)nextMarkViewFrame
{
    CGRect markViewFrame = [[self.markViewsArray lastObject] frame];
    markViewFrame.origin = CGPointMake(markViewFrame.origin.x + kSUNewMarkViewIndent,
                                       markViewFrame.origin.y + kSUNewMarkViewIndent);
    if ([self isMarkViewFrameValid:markViewFrame] == NO) {
        markViewFrame = kSUMarkViewFrame;
    }

    return markViewFrame;
}

- (BOOL)isMarkViewFrameValid:(CGRect)markViewFrame
{
    BOOL isFrameValid = YES;
    
    CGRect rootFrame = self.view.frame;
    if (markViewFrame.size.width <= 0.0f || markViewFrame.size.height <= 0.0f ||
        markViewFrame.origin.x >= rootFrame.size.width ||
        markViewFrame.origin.y >= rootFrame.size.height) {

        isFrameValid = NO;
    }
    
    return isFrameValid;
}

- (void)deactivateAllMarkViews
{
    for (SUMarkView *subView in self.markViewsArray) {
        subView.isActive = NO;
    }
}

- (void)setupMarkView:(SUMarkView *)markView
{
    markView.delegate = self;
    [markView.tapGesture addTarget:self action:@selector(handleTap:)];
    [markView.longPressGesture addTarget:self action:@selector(handleLongPress:)];
    self.rootView.markViewToolbar.widthSlider.value = markView.layer.borderWidth;
    self.rootView.markViewToolbar.cornerTypeButton.state = SUCompositeButtonStateNormal;
    [self.rootView insertSubview:markView belowSubview:self.rootView.errorMarkingToolbar];
}

- (void)showPreviousViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Mark View toolbar

- (void)changeBorderWidth:(UISlider *)sender
{
    for (SUMarkView *subview in [self.rootView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            if (subview.isActive) {
                subview.layer.borderWidth = [sender value];
            }
        }
    }
}

- (void)colorViewPickedWithColor:(UIColor *)color withSelectedColorViewCenter:(CGPoint)center
{
    for (SUMarkView *subview in [self.rootView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            if (subview.isActive) {
                subview.layer.borderColor = color.CGColor;
                subview.selectedColorCenter = center;
            }
        }
    }
}

#pragma mark - Handle long tap gesture

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    [self makeViewActiveWithRecognizer:recognizer];
    [self switchMarkViewCornerTypeOnView:recognizer.view];
    
    for (SUMarkView *subview in [self.rootView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            [subview.layer addAnimation:[self shakingViewAnimation] forKey:kSUShakingAnimationKey];
            
            // Init remove mark view button
            UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [removeButton setBackgroundImage:[UIImage imageNamed:@"close_button.png"] forState:UIControlStateNormal];
            removeButton.backgroundColor = [[SUPixelHunterTheme colors] darkGrayBackgroundColor];
            removeButton.frame = kSUMarkViewRemoveButtonFrame;
            [removeButton addTarget:self action:@selector(removeMarkView:) forControlEvents:UIControlEventTouchUpInside];
            [subview addSubview:removeButton];
        }
    }
}

- (CAAnimation *)shakingViewAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation
                                      animationWithKeyPath:@"transform.rotation"];
    NSNumber *value1 = [NSNumber numberWithFloat:-0.05f];
    NSNumber *value2 = [NSNumber numberWithFloat:0.05f];
    animation.values = [NSArray arrayWithObjects:value1, value2, nil];
    animation.duration = kSURemovableViewShakeAnimationTime;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;

    return animation;
}

- (void)stopShakingAnimation
{
    for (SUMarkView *subview in [self.rootView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            [subview.layer removeAnimationForKey:kSUShakingAnimationKey];
            for (UIButton *button in [subview subviews]) {
                if ([button isKindOfClass:[UIButton class]]) {
                    [button removeFromSuperview];
                }
                if ([subview isKindOfClass:[SUTextMarkView class]]) {
                    [((SUTextMarkView *)subview).commentTextView endEditing:YES];
                }
            }
        }
    }
}

#pragma mark - Handle tap and pan gestures

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    [self makeViewActiveWithRecognizer:recognizer];
    [self switchMarkViewCornerTypeOnView:recognizer.view];
    
    for (SUTextMarkView *subview in [self.rootView subviews]) {
        if ([subview isKindOfClass:[SUTextMarkView class]]) {
            [subview.commentTextView endEditing:YES];
            if (subview.isActive) {
                subview.commentTextView.userInteractionEnabled = YES;
                [subview.commentTextView becomeFirstResponder];
            } else {
                subview.commentTextView.userInteractionEnabled = NO;
            }
        }
    }
}

- (void)panGestureActivated:(UIPanGestureRecognizer *)recognizer
{
    [self makeViewActiveWithRecognizer:recognizer];
    [self switchMarkViewCornerTypeOnView:recognizer.view];
    
    for (SUTextMarkView *subview in [self.rootView subviews]) {
        if ([subview isKindOfClass:[SUTextMarkView class]]) {
            if (!subview.isActive) {
                [subview.commentTextView endEditing:YES];
            }
        }
    }
}

- (void)makeViewActiveWithRecognizer:(UIGestureRecognizer *)recognizer
{
    for (SUMarkView *subview in [self.rootView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            subview.isActive = NO;
        }
    }
    
    self.rootView.markViewToolbar.widthSlider.value = ((SUMarkView *)recognizer.view).layer.borderWidth;
    self.rootView.markViewToolbar.markColorView.selectedColorView.center = ((SUMarkView *)recognizer.view).selectedColorCenter;
    
    if (!((SUMarkView *)recognizer.view).isActive) {
        ((SUMarkView *)recognizer.view).isActive = YES;
    }
}

#pragma mark - Handle pinch gesture

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    for (SUMarkView *subview in [self.rootView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            if (subview.isActive) {
                if ([recognizer numberOfTouches] == 2) {
                    CGFloat x = [recognizer locationInView:subview].x - [recognizer locationOfTouch:1 inView:subview].x;
                    if (x < 0) {
                        x *= -1;
                    }
                    CGFloat y = [recognizer locationInView:subview].y - [recognizer locationOfTouch:1 inView:subview].y;
                    if (y < 0) {
                        y *= -1;
                    }
                    
                    if (recognizer.state == UIGestureRecognizerStateBegan) {
                        self.horizontalScale = subview.bounds.size.width - x * 2;
                        self.verticalScale = subview.bounds.size.height - y * 2;
                    }
                        
                    CGFloat width = x * 2 + self.horizontalScale;
                    if (width < kSUMinimumViewSideSize) {
                        width = kSUMinimumViewSideSize;
                    }
                    if (width > self.view.frame.size.width) {
                        width = self.view.frame.size.width;
                    }
                    CGFloat height = y * 2 + self.verticalScale;
                    if (height < kSUMinimumViewSideSize) {
                        height = kSUMinimumViewSideSize;
                    }
                    if (height > self.view.frame.size.height) {
                        height = self.view.frame.size.height;
                    }
                    subview.bounds = CGRectMake(subview.bounds.origin.x , subview.bounds.origin.y , width, height);
                    
                    if (recognizer.state == UIGestureRecognizerStateEnded) {
                        [self moveView:subview toVisiblePositionOnParentView:self.view];
                    }
                    [recognizer setScale:1.0f];
                }
            }
        }
    }
}

- (void)moveView:(UIView *)view toVisiblePositionOnParentView:(UIView *)parentView
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

#pragma mark - Switch mark view corner type

- (void)switchMarkViewCornerType
{
    BOOL pressed = self.rootView.markViewToolbar.cornerTypeButton.state == SUCompositeButtonStateNormal ? YES : NO;
    
    self.rootView.markViewToolbar.cornerTypeButton.state =
        pressed == YES ? SUCompositeButtonStateActivated : SUCompositeButtonStateNormal;
    
    for (SUMarkView *subview in [self.rootView subviews]) {
        if ([subview isKindOfClass:[SUMarkView class]]) {
            if (subview.isActive) {
                if (subview.layer.cornerRadius == kSUCornerRadius) {
                    subview.layer.cornerRadius = 0.0f;
                    if ([subview isKindOfClass:[SUTextMarkView class]]) {
                        ((SUTextMarkView *)subview).commentTextView.layer.cornerRadius = 0.0f;
                    }
                } else {
                    subview.layer.cornerRadius = kSUCornerRadius;
                    if ([subview isKindOfClass:[SUTextMarkView class]]) {
                        ((SUTextMarkView *)subview).commentTextView.layer.cornerRadius = kSUCornerRadius;
                    }
                }
            }
        }
    }
}

- (void)switchMarkViewCornerTypeOnView:(UIView *)view
{
    if (view.layer.cornerRadius != kSUCornerRadius) {
        self.rootView.markViewToolbar.cornerTypeButton.state = SUCompositeButtonStateActivated;
    } else {
        self.rootView.markViewToolbar.cornerTypeButton.state = SUCompositeButtonStateNormal;
    }
}

#pragma mark - Gesture delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Kayboard notifications methods

- (void)keyboardWillShow:(id)sender
{
    NSDictionary *userInfo = [sender userInfo];
    
    CGFloat keyboardAnimationTime = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect toView:nil];
    CGSize keyboardSize = keyboardRect.size;
    
    for (SUTextMarkView *subview in [self.rootView subviews]) {
        if ([subview isKindOfClass:[SUTextMarkView class]]) {
            if (subview.isActive) {
                if (subview.frame.origin.y + subview.frame.size.height > self.view.frame.size.height - keyboardSize.height) {
                    CGRect tempRect = self.rootView.frame;
                    tempRect.origin.y -= keyboardSize.height;
                    if (tempRect.origin.y == -keyboardSize.height) {
                        [UIView animateWithDuration:keyboardAnimationTime animations:^{
                            self.tempTextMarkViewRect = self.rootView.frame;
                            self.rootView.frame = tempRect;
                        }];
                    }
                }
            }
        }
    }
}

- (void)keyboardWillHide:(id)sender
{
    NSDictionary *userInfo = [sender userInfo];
    
    CGFloat keyboardAnimationTime = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect toView:nil];
    
    CGSize keyboardSize = keyboardRect.size;
    
    for (SUTextMarkView *subview in [self.rootView subviews]) {
        if ([subview isKindOfClass:[SUTextMarkView class]]) {
            if (subview.isActive) {
                if (!CGRectIsEmpty(self.tempTextMarkViewRect) && (self.rootView.frame.origin.y != self.tempTextMarkViewRect.origin.y)) {
                    CGRect tempRect = self.rootView.frame;
                    tempRect.origin.y += keyboardSize.height;
                    if (self.rootView.frame.origin.y == -keyboardSize.height) {
                        [UIView animateWithDuration:keyboardAnimationTime animations:^{
                            self.rootView.frame = tempRect;
                            self.rootView.frame = self.tempTextMarkViewRect;
                        }];
                    }
                }
            }
        }
    }
}

@end
