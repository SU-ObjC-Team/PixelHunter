//
//  SUUnderLayerView.m
//  PixelHunter
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridUnderLayerView.h"
#import "SUPixelHunterConstants.h"


static CGFloat const kSUStepSize = 50.0f;

@interface SUGridUnderLayerView ()

@property (nonatomic, strong) UIImageView *screenshotImageView;

@end


@implementation SUGridUnderLayerView

- (id)initWithFrame:(CGRect)rect withImage:(UIImage *)image
{
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
        self.scrollView.bouncesZoom = NO;
        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];

        self.containerView = [[UIView alloc] initWithFrame:rect];
        [self.scrollView addSubview:self.containerView];

        self.screenshotImageView = [[UIImageView alloc] initWithImage:image];
        self.screenshotImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:self.screenshotImageView];

        self.mockupImageView = [[UIImageView alloc] init];
        self.mockupImageView.alpha = kSUStartAlpha;
        self.mockupImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:self.mockupImageView];

        self.gridView = [[SUGridView alloc] init];
        self.gridView.hidden = YES;
        self.gridView.gridStepSize = kSUStepSize;
        self.gridView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:self.gridView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize boundsSize = [super bounds].size;
    
    self.scrollView.frame = CGRectMake(0.0f, 0.0f, boundsSize.width, boundsSize.height);
    
    self.containerView.frame = CGRectMake(0.0f, 0.0f, boundsSize.width, boundsSize.height);
    
    self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f, boundsSize.width, boundsSize.height);
    
    self.mockupImageView.frame = CGRectMake(0.0f, 0.0f, boundsSize.width, boundsSize.height);
    
    self.gridView.frame = CGRectMake(0.0f, 0.0f, boundsSize.width, boundsSize.height);
}

@end
