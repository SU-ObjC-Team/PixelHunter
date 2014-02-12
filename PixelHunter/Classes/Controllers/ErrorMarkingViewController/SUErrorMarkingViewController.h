//
//  SUErrorMarkingViewController.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUTextMarkView.h"
#import "SUErrorMarkingView.h"

@interface SUErrorMarkingViewController : UIViewController <SUMarkViewDelegate>

- (id)initWithImage:(UIImage *)screenshotImage;
- (void)handleTap:(UITapGestureRecognizer *)recognizer;
- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer;
- (void)makeViewActive:(SUMarkView *)markView;

@property (nonatomic, strong) NSMutableArray *markViewsArray;
@property (nonatomic, strong) SUErrorMarkingView *rootView;

@end
