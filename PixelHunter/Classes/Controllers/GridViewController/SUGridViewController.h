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

- (id)initWithImage:(UIImage *)screenshotImage;

@property (nonatomic, assign) id <SUGridViewControllerDelegate> delegate;

@end
