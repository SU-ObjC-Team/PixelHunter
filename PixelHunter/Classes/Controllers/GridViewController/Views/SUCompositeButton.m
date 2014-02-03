//
//  SUCompositeButton.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUCompositeButton.h"
#import "SUPixelHunterConstants.h"
#import "SUPixelHunterTheme.h"

static NSString * const kSUSeparatorImageName = @"vertical_separator.png";

@implementation SUCompositeButtonModel

@end

@interface SUCompositeButton ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *separatorImageView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImage *imageNormal;
@property (nonatomic, strong) UIImage *imagePressed;
@property (nonatomic, strong) UIImage *imageActivated;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL action;

@end


@implementation SUCompositeButton

- (id)initWithModel:(SUCompositeButtonModel *)model
{
    self = [super init];
    if (self) {

        self.backgroundColor = [[SUPixelHunterTheme colors] darkGrayBackgroundColor];

        [self initImagesFromModel:model];

        self.imageView = [[UIImageView alloc] initWithImage:self.imageNormal];
        [self addSubview:self.imageView];

        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.button addTarget:self action:@selector(onDown)
              forControlEvents:UIControlEventTouchDown];
        [self.button addTarget:self action:@selector(onUp)
              forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        [self addSubview:self.button];
        
        self.separatorImageView = [[UIImageView alloc] initWithImage:[self separatorImage]];
        [self addSubview:self.separatorImageView];
        
        self.state = SUCompositeButtonStateNormal;
        self.separatorState = SUSeparatorShown;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sz = self.frame.size;

    // Layout button
    self.button.frame = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    
    // Layout image
    self.imageView.center = self.button.center;
    
    // Layout separator
    self.separatorImageView.frame = CGRectMake(sz.width - kSUSeparatorWidth, 0.0f, kSUSeparatorWidth, sz.height);
}

#pragma mark - Private

- (void)initImagesFromModel:(SUCompositeButtonModel *)model
{
    if (model.imageNormalName.length != 0) {
        self.imageNormal = [UIImage imageNamed:model.imageNormalName];
    }
    if (model.imagePressedName.length != 0) {
        self.imagePressed = [UIImage imageNamed:model.imagePressedName];
    }
    if (model.imageActivatedName.length != 0) {
        self.imageActivated = [UIImage imageNamed:model.imageActivatedName];
    }
    
    if (model.imageActivatedName == nil) {
        self.imageActivated = self.imageNormal;
    }
}

- (UIImage *)separatorImage
{
    return [UIImage imageNamed:kSUSeparatorImageName];
}

#pragma mark - Actions

- (void)onDown
{
    self.imageView.image = self.imagePressed;
}

- (void)onUp
{
    self.imageView.image = self.imageNormal;
}

- (void)onTouchUpInside
{
    if (self.target && self.action){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.action withObject:self];
#pragma clang diagnostic pop
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
    
    [self.button addTarget:self action:@selector(onTouchUpInside)
          forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Propreties

- (void)setState:(SUCompositeButtonState)state
{
    _state = state;
    
    if (state == SUCompositeButtonStateNormal) {
        self.imageView.image = self.imageNormal;
    }
    else if (state == SUCompositeButtonStateActivated) {
        self.imageView.image = self.imageActivated;
    }
}

- (void)setSeparatorState:(SUSeparatorState)separatorState
{
    _separatorState = separatorState;
    
    if (separatorState == SUSeparatorShown) {
        self.separatorImageView.hidden = NO;
    } else if (separatorState == SUSeparatorHidden) {
        self.separatorImageView.hidden = YES;
    }
}

@end
