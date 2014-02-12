//
//  SUErrorMarkingViewController+MarkingViews.m
//  ExamplePixelHunter
//
//  Created by Rostyslav Druzhchenko on 2/10/14.
//  Copyright (c) 2014 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingViewController+MarkingViews.h"


static CGFloat const kSUNewMarkViewIndent = 20.0f;
static CGRect const kSUMarkViewFrame = {{50.0f, 50.0f}, {150.0f, 150.0f}};

@implementation SUErrorMarkingViewController (MarkingViews)

#pragma mark - Marking views methods

- (void)addMarkView
{
    SUMarkView *markView = [[SUMarkView alloc] initWithView:self.view];
    [self addMarkView:markView];
}

- (void)addTextMarkView
{
    SUMarkView *markView = [[SUTextMarkView alloc] initWithView:self.view];
    [self addMarkView:markView];
}

- (void)addMarkView:(SUMarkView *)markView
{
    [self stopShakingAnimation];
    [self deactivateAllMarkViews];
    
    [self setupMarkView:markView];
    [self makeViewActive:markView];
    
    [self.markViewsArray addObject:markView];
    
    self.rootView.errorMarkingToolbar.showMarkingViewToolbarButton.hidden = NO;
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
    SUErrorMarkingView *rootView = self.rootView;

    markView.delegate = self;
    markView.frame = [self nextMarkViewFrame];
    [markView.tapGesture addTarget:self action:@selector(handleTap:)];
    [markView.longPressGesture addTarget:self action:@selector(handleLongPress:)];
    rootView.markViewToolbar.widthSlider.value = markView.layer.borderWidth;
    rootView.markViewToolbar.cornerTypeButton.state = SUCompositeButtonStateNormal;
    [rootView insertSubview:markView belowSubview:rootView.errorMarkingToolbar];
}

- (void)stopShakingAnimation
{
    for (SUMarkView *subview in self.markViewsArray) {
        [subview removeShakingAnimation];
    }
}

@end
