//
//  SUShareController.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/15/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SUErrorMarkingToolbar.h"


@interface SUShareController : NSObject

- (id)initWithToolbar:(SUErrorMarkingToolbar *)toolbar
   withMenuViewsArray:(NSArray *)menuViewsArray
     onViewController:(UIViewController *)viewController;

@end
