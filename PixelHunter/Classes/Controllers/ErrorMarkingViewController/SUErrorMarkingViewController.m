//
//  SUErrorMarkingViewController.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingViewController.h"
#import "SUErrorMarkingViewController+MarkingViews.h"
#import "SUPixelHunterPositioningUtility.h"
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
                    [SUPixelHunterPositioningUtility moveViewAnimated:markView
                                                        toVisibleRect:self.view.bounds];
                }
                [recognizer setScale:1.0f];
            }
        }
    }
}

#pragma mark - Switch mark view corner type

- (void)switchMarkViewCornerType
{
    SUMarkViewToolbarCompositeButton *cornerButton =
                self.rootView.markViewToolbar.cornerTypeButton;
    cornerButton.state = cornerButton.state == SUCompositeButtonStateActivated ?
        SUCompositeButtonStateNormal : SUCompositeButtonStateActivated;
    self.activeMarkView.cornerType = cornerButton.state == SUCompositeButtonStateActivated ?
    SUMarkViewCornerTypeCorner : SUMarkViewCornerTypeRound;
}

- (void)switchMarkViewCornerTypeOnView:(SUMarkView *)markView
{
    SUMarkViewToolbarCompositeButton *cornerButton =
                self.rootView.markViewToolbar.cornerTypeButton;
    
    if (markView.cornerType == SUMarkViewCornerTypeCorner) {
        cornerButton.state = SUCompositeButtonStateActivated;
    }
    
    if (markView.cornerType == SUMarkViewCornerTypeRound) {
        cornerButton.state = SUCompositeButtonStateNormal;
    }
}

#pragma mark - Gesture delegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - Keyboard notifications methods

- (CGRect)screenBounds
{
    return [[UIScreen mainScreen] bounds];
}


- (void)swapSizeIfLandscape:(CGSize *)size
{
    if ([self isLandscape]) {
        CGFloat temp = size->width;
        size->width = size->height;
        size->height = temp;
    }
}

- (BOOL)isLandscape
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

- (void)keyboardWillShow:(id)sender
{
    CGFloat keyboardAnimationTime = [self keyboardAnimationTimeWithSender:sender];
    
    NSDictionary *userInfo = [sender userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect toView:nil];
    CGSize keyboardSize = keyboardRect.size;
    
    CGRect tempRect = [self screenBounds];
    [self swapSizeIfLandscape:&tempRect.size];
    
    CGFloat markViewPosition = CGRectGetMaxY(self.activeMarkView.frame);
    CGFloat keyboardPosition = tempRect.size.height - keyboardSize.height;
    if (markViewPosition > keyboardPosition) {
        tempRect.origin.y += keyboardSize.height;
        if (tempRect.origin.y == keyboardSize.height) {
            [UIView animateWithDuration:keyboardAnimationTime animations:^{
                self.view.bounds = tempRect;
            }];
        }
    }
}

- (void)keyboardWillHide:(id)sender
{
    CGFloat keyboardAnimationTime = [self keyboardAnimationTimeWithSender:sender];
    CGRect tempRect = [self screenBounds];
    [self swapSizeIfLandscape:&tempRect.size];
    
    tempRect.origin.y = 0.0f;
    [UIView animateWithDuration:keyboardAnimationTime animations:^{
        self.view.bounds = tempRect;
    }];
}

- (CGFloat)keyboardAnimationTimeWithSender:(id)sender
{
    NSDictionary *userInfo = [sender userInfo];
    id animationDurationKey = UIKeyboardAnimationDurationUserInfoKey;
    
    return [[userInfo objectForKey:animationDurationKey] doubleValue];
}

@end
