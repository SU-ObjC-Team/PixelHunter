//
//  SUErrorMarkingViewController.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingViewController.h"
#import "SUErrorMarkingViewController+MarkingViews.h"

#import "SUShareController.h"
#import "SUPixelHunterConstants.h"

static CGFloat const kSUMinValidScale = 0.8f;
static CGFloat const kSUMaxValidScale = 2.0f;
static CGFloat const kSUScaleRestraintStartValue = 1.5f;
static CGFloat const kSUMinimumViewSideSize = 25.0f;

@interface SUErrorMarkingViewController () <UIGestureRecognizerDelegate,
                                            SUMarkColorViewDelegate>

@property (nonatomic, strong) UIImage *screenshotImage;
@property (nonatomic, strong) SUShareController *shareController;
@property (nonatomic, assign) CGFloat horizontalScale;
@property (nonatomic, assign) CGFloat verticalScale;
@property (nonatomic, assign) CGRect tempTextMarkViewRect;
@property (nonatomic, strong) SUMarkView *activeMarkView;

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

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)showPreviousViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Initialization methods

//TODO:Dicsuss solution on Friday
- (void)initShareController
{
    SUErrorMarkingToolbar *errorToolbar = self.rootView.errorMarkingToolbar;
    NSArray *menuViewsArray = @[errorToolbar,
                                self.rootView.markViewToolbar];

    self.shareController = [[SUShareController alloc] initWithToolbar:errorToolbar
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

#pragma mark - Mark View toolbar

- (void)changeBorderWidth:(UISlider *)sender
{
    self.activeMarkView.layer.borderWidth = [sender value];
}

- (void)colorViewPickedWithColor:(UIColor *)color withSelectedColorViewCenter:(CGPoint)center
{
    self.activeMarkView.layer.borderColor = color.CGColor;
    self.activeMarkView.selectedColorCenter = center;
}

#pragma mark - Handle long tap gesture

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    SUMarkView *markView = (SUMarkView *)recognizer.view;
    
    [self makeViewActive:markView];
    [self switchMarkViewCornerTypeOnView:markView];
    
    for (SUMarkView *subview in self.markViewsArray) {
        subview.isDeletingAnimationOn = YES;
    }
}

#pragma mark - Handle tap and pan gestures

- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    SUMarkView *markView = (SUMarkView *)recognizer.view;
    
    if ([markView isKindOfClass:[SUTextMarkView class]]) {
        
        SUTextMarkView *markTextView = (SUTextMarkView *)markView;
        [markTextView.commentTextView becomeFirstResponder];
    }

    [self makeViewActive:markView];
    [self switchMarkViewCornerTypeOnView:markView];
}

- (void)panGestureActivatedWithView:(SUMarkView *)markView
{
    if (markView != self.activeMarkView && [self.activeMarkView isKindOfClass:[SUTextMarkView class]]) {
        [((SUTextMarkView *)self.activeMarkView).commentTextView endEditing:YES];
    }
    
    [self makeViewActive:markView];
    [self switchMarkViewCornerTypeOnView:markView];
}

- (void)makeViewActive:(SUMarkView *)markView
{
    self.activeMarkView.isActive = NO;

    self.rootView.markViewToolbar.widthSlider.value =
        markView.layer.borderWidth;
    self.rootView.markViewToolbar.markColorView.selectedColorView.center =
        markView.selectedColorCenter;
    
    self.activeMarkView = markView;
    self.activeMarkView.isActive = YES;
}

#pragma mark - Handle pinch gesture

- (void)handlePinch:(UIPinchGestureRecognizer *)recognizer
{
    for (SUMarkView *markView in self.markViewsArray) {
    
        if (markView.isActive) {
            if ([recognizer numberOfTouches] == 2) {
                
                CGPoint locationInView = [recognizer locationInView:markView];
                CGPoint locationOfTouch = [recognizer locationOfTouch:1 inView:markView];
                
                CGFloat x = locationInView.x - locationOfTouch.x;
                if (x < 0) {
                    x *= -1;
                }

                CGFloat y = locationInView.y - locationOfTouch.y;
                if (y < 0) {
                    y *= -1;
                }
                
                if (recognizer.state == UIGestureRecognizerStateBegan) {
                    self.horizontalScale = markView.bounds.size.width - x * 2;
                    self.verticalScale = markView.bounds.size.height - y * 2;
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
                markView.bounds = CGRectMake(markView.bounds.origin.x , markView.bounds.origin.y , width, height);
                
                if (recognizer.state == UIGestureRecognizerStateEnded) {
                    [self moveView:markView toVisiblePositionOnParentView:self.view];
                }
                [recognizer setScale:1.0f];
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
    BOOL pressed = self.rootView.markViewToolbar.cornerTypeButton.state ==
        SUCompositeButtonStateNormal ? YES : NO;
    
    self.rootView.markViewToolbar.cornerTypeButton.state =
        pressed == YES ? SUCompositeButtonStateActivated : SUCompositeButtonStateNormal;

    for (SUMarkView *markView in self.markViewsArray) {
        if (markView.isActive) {
            if (markView.layer.cornerRadius == kSUCornerRadius) {
                markView.layer.cornerRadius = kSUZeroCornerRadius;
                if ([markView isKindOfClass:[SUTextMarkView class]]) {
                    SUTextMarkView *textMarkView = (SUTextMarkView *)markView;
                    textMarkView.commentTextView.layer.cornerRadius = kSUZeroCornerRadius;
                }
            } else {
                markView.layer.cornerRadius = kSUCornerRadius;
                if ([markView isKindOfClass:[SUTextMarkView class]]) {
                    SUTextMarkView *textMarkView = (SUTextMarkView *)markView;
                    textMarkView.commentTextView.layer.cornerRadius = kSUCornerRadius;
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
