//
//  SUErrorMarkingView.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUErrorMarkingToolbar.h"
#import "SUMarkViewToolbar.h"


@interface SUErrorMarkingRootView : UIView

- (id)initWithImage:(UIImage *)screenshotImage;

@property (nonatomic, strong) SUErrorMarkingToolbar *errorMarkingToolbar;
@property (nonatomic, strong) SUMarkViewToolbar *markViewToolbar;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;

@end
