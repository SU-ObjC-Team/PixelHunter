//
//  SUGridViewController.h
//  PixelHunter
//
//  Created by Alex Saenko on 9/19/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUGridRootView.h"


@protocol SUGridViewControllerDelegate <NSObject>

- (void)tapOnCloseButton;

@end


@interface SUGridViewController : UIViewController 

@property (nonatomic, weak) SUGridRootView *gridRootView;
@property (nonatomic, assign) id <SUGridViewControllerDelegate> delegate;

- (id)initWithImage:(UIImage *)screenshotImage;

@end
