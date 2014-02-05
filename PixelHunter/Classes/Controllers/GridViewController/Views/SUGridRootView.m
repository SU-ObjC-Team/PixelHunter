//
//  SUGridRootView.m
//  PixelHunter
//
//  Created by Alex Saenko on 9/25/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridRootView.h"
#import "SUPixelHunterConstants.h"
#import "SUGridRulerViewHorizontal.h"
#import "SUGridRulerViewVertical.h"


@implementation SUGridRootView

- (id)initWithFrame:(CGRect)rect withImage:(UIImage *)image
{
	self = [super initWithFrame:rect];
	if (self) {

        self.gridUnderLayerView = [[SUGridUnderLayerView alloc] initWithFrame:rect withImage:image];
        self.gridUnderLayerView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.gridUnderLayerView];

        self.tapGesture = [[UITapGestureRecognizer alloc] init];
        [self addGestureRecognizer:self.tapGesture];
        [self.tapGesture addTarget:self action:@selector(viewTapped)];
        
        self.smallGridView = [[SUGridView alloc] init];
        self.smallGridView.hidden = YES;
        self.smallGridView.gridStepSize = kSUSmallStepSize;
        [self addSubview:self.smallGridView];
        
        self.topRuler = [SUGridRulerViewHorizontal new];
        self.sideRuler = [SUGridRulerViewVertical new];
        [self addSubview:self.topRuler];
        [self addSubview:self.sideRuler];
        
        self.toolbar = [[SUGridToolbar alloc] init];
        self.toolbar.hidden = YES;
        [self.toolbar.gridDisplayButton addTarget:self action:@selector(tapOnGridDisplayButton)];
        [self addSubview:self.toolbar];
        
        [self layoutViewsDependingOnOrientation];
	}
    
	return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Layout rulers
    self.topRuler.scale = self.gridUnderLayerView.scrollView.zoomScale;
    self.sideRuler.scale = self.gridUnderLayerView.scrollView.zoomScale;
    [self.topRuler setNeedsDisplay];
    [self.sideRuler setNeedsDisplay];
    
    CGSize layoutSize = [[UIScreen mainScreen] bounds].size;
    
    // Layout grid underlayer
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        self.gridUnderLayerView.frame = CGRectMake(0.0f, 0.0f, layoutSize.height, layoutSize.width);
        self.smallGridView.frame = CGRectMake(0.0f, 0.0f, layoutSize.height, layoutSize.width);
    } else {
        self.gridUnderLayerView.frame = CGRectMake(0.0f, 0.0f, layoutSize.width, layoutSize.height);
        self.smallGridView.frame = CGRectMake(0.0f, 0.0f, layoutSize.width, layoutSize.height);
    }
}

- (void)layoutViewsDependingOnOrientation
{
    [self.gridUnderLayerView.scrollView setZoomScale:self.gridUnderLayerView.scrollView.minimumZoomScale];
    CGSize sz = self.frame.size;
    CGSize rulerLayoutSize = [[UIScreen mainScreen] bounds].size;
    CGSize toolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight);
    
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        self.topRuler.frame = CGRectMake(0.0f, 0.0f, rulerLayoutSize.height, kSURulerSize);
        self.sideRuler.frame = CGRectMake(0.0f, 0.0f, kSURulerSize, rulerLayoutSize.width);
        self.toolbar.frame = CGRectMake(sz.height / 2.0f - toolbarSize.width / 2.0f,
                                        sz.width - toolbarSize.height + kSUToolBarHeight,
                                        toolbarSize.width, toolbarSize.height);
    } else {
        self.topRuler.frame = CGRectMake(0.0f, 0.0f, rulerLayoutSize.width, kSURulerSize);
        self.sideRuler.frame = CGRectMake(0.0f, 0.0f, kSURulerSize, rulerLayoutSize.height);
        self.toolbar.frame = CGRectMake(sz.width / 2.0f - toolbarSize.width / 2.0f,
                                        sz.height - toolbarSize.height + kSUToolBarHeight,
                                        toolbarSize.width, toolbarSize.height);
    }
    self.toolbar.hidden = YES;
}

- (void)viewTapped
{
    CGSize sz = self.frame.size;
    
    CGSize toolbarSize = CGSizeMake(kSUToolBarWidth, kSUToolBarHeight);
    
    if (self.toolbar.isHidden) {
        self.toolbar.hidden = NO;
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
                self.toolbar.frame = CGRectMake(sz.height / 2.0f - toolbarSize.width / 2.0f,
                                                sz.width - toolbarSize.height,
                                                toolbarSize.width, toolbarSize.height);
            } else {
                self.toolbar.frame = CGRectMake(sz.width / 2.0f - toolbarSize.width / 2.0f,
                                                sz.height - toolbarSize.height,
                                                toolbarSize.width, toolbarSize.height);
            }
        }];
    } else {
        [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
                self.toolbar.frame = CGRectMake(sz.height / 2.0f - toolbarSize.width / 2.0f,
                                                sz.width - toolbarSize.height + kSUToolBarHeight,
                                                toolbarSize.width, toolbarSize.height);
            } else {
                self.toolbar.frame = CGRectMake(sz.width / 2.0f - toolbarSize.width / 2.0f,
                                                sz.height - toolbarSize.height + kSUToolBarHeight,
                                                toolbarSize.width, toolbarSize.height);
            }
        } completion:^(BOOL finished) {
            self.toolbar.hidden = YES;
        }];
        
    }
}

- (void)tapOnGridDisplayButton
{
    BOOL pressed = self.toolbar.gridDisplayButton.state == SUCompositeButtonStateNormal ? YES : NO;
    
    self.toolbar.gridDisplayButton.state =
        pressed == YES ? SUCompositeButtonStateActivated : SUCompositeButtonStateNormal;
    
    if (self.toolbar.gridDisplayButton.state == SUCompositeButtonStateNormal) {
        self.gridUnderLayerView.gridView.hidden = YES;
    } else {
        self.gridUnderLayerView.gridView.hidden = NO;
    }
}

@end
