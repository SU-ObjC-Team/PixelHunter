//
//  SUErrorMarkingViewControllerPrivate.h
//  ExamplePixelHunter
//
//  Created by Rostyslav Druzhchenko on 2/10/14.
//  Copyright (c) 2014 Sigma Ukraine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SUErrorMarkingView.h"

@interface SUErrorMarkingViewControllerPrivate : NSObject

@property (nonatomic, strong) NSMutableArray *markViewsArray;
@property (nonatomic, strong) SUErrorMarkingView *rootView;

@end
