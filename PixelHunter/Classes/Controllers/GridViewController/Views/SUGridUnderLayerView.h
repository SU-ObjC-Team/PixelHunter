//
//  SUUnderLayerView.h
//  PixelHunter
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SUGridView.h"


@interface SUGridUnderLayerView : UIView

- (id)initWithFrame:(CGRect)rect withImage:(UIImage *)image;

@property (nonatomic, strong) SUGridView *gridView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *mockupImageView;

@end
