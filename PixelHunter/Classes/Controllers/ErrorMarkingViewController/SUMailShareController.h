//
//  SUMailShareController.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/15/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SUErrorMarkingToolbar.h"

@protocol SUShareControllerDelegate <NSObject>

- (void)screenshotWillTake;
- (void)screenshotDidTake;

@end


@interface SUMailShareController : NSObject

- (id)initWithSendMailButton:(SUCompositeButton *)button
            viewController:(UIViewController *)viewController;

@property (nonatomic, assign) id <SUShareControllerDelegate>delegate;

@end
