//
//  SUErrorMarkingViewController+MarkingViews.h
//  ExamplePixelHunter
//
//  Created by Rostyslav Druzhchenko on 2/10/14.
//  Copyright (c) 2014 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingViewController.h"

@interface SUErrorMarkingViewController (MarkingViews)

- (void)addMarkView;
- (void)addTextMarkView;
- (void)stopShakingAnimation;
- (void)removeMarkView:(UIButton *)sender;

@end
