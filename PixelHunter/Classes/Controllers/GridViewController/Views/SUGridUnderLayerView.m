//
//  SUUnderLayerView.m
//  PixelHunter
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridUnderLayerView.h"
#import "SUPixelHunterConstants.h"


@interface SUGridUnderLayerView ()

@property (nonatomic, strong) UIImageView *screenshotImageView;

@end


@implementation SUGridUnderLayerView

- (id)initWithFrame:(CGRect)rect withScreenshotImage:(UIImage *)image
{
    self = [super initWithFrame:rect];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        // Init scroll view
        self.scrollView = [[UIScrollView alloc] initWithFrame:rect];
        self.scrollView.bouncesZoom = NO;
        self.scrollView.bounces = NO;
        [self addSubview:self.scrollView];
        
        // Init container view
        self.containerView = [[UIView alloc] initWithFrame:rect];
        [self.scrollView addSubview:self.containerView];
        
        // Init screenshotImageView
        self.screenshotImageView = [[UIImageView alloc] initWithImage:image];
        self.screenshotImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:self.screenshotImageView];
        
        // Init mockup image view
        self.mockupImageView = [[UIImageView alloc] init];
        self.mockupImageView.alpha = kSUStartAlpha;
        self.mockupImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:self.mockupImageView];
        
        // Init grid view
        self.gridView = [[SUGridView alloc] initWithSmallGrid:NO];
        self.gridView.contentMode = UIViewContentModeScaleAspectFit;
        [self.containerView addSubview:self.gridView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sz = [super bounds].size;
    
    // Layout scroll view
    self.scrollView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    
    //Layout container view
    self.containerView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    
    // Layout screenshot image view
    self.screenshotImageView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    
    // Layout mockup image view
    self.mockupImageView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    
    // Layout grid view
    self.gridView.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);    
}


@end
