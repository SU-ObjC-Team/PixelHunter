//
//  SUGridRootView.h
//  PixelHunter
//
//  Created by Alex Saenko on 9/25/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUGridUnderLayerView.h"
#import "SUGridToolbar.h"
#import "SUGridRulerView.h"


@interface SUGridRootView : UIView

- (id)initWithFrame:(CGRect)rect withImage:(UIImage *)image;
- (void)layoutViewsDependingOnOrientation;

@property (nonatomic, strong) SUGridUnderLayerView *gridUnderLayerView;
@property (nonatomic, strong) SUGridToolbar *toolbar;
@property (nonatomic, strong) SUGridRulerView *topRuler;
@property (nonatomic, strong) SUGridRulerView *sideRuler;
@property (nonatomic, strong) SUGridView *smallGridView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end
