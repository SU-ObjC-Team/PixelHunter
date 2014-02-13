//
//  SUShareController.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/15/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SUErrorMarkingToolbar.h"

@protocol SUShareControllerDelegate <NSObject>

- (void)hideViews;
- (void)showViews;

@end


@interface SUShareController : NSObject

- (id)initWithToolbar:(SUErrorMarkingToolbar *)toolbar
     onViewController:(UIViewController *)viewController;

@property (nonatomic, assign) id <SUShareControllerDelegate>delegate;

@end
