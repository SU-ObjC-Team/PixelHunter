//
//  SUMarkViewToolbarCompositeButton.m
//  ExamplePixelHunter
//
//  Created by Alex Saenko on 12/10/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUMarkViewToolbarCompositeButton.h"
#import "SUPixelHunterConstants.h"
#import "SUPixelHunterTheme.h"


static NSString * const kSUHorizontalSeparatorImageName = @"sidebar_horizontal_separator.png";
static NSString * const kSUVerticalSeparatorImageName = @"sidebar_vertical_separator.png";


@interface SUMarkViewToolbarCompositeButton ()

@property (nonatomic, strong) UIImageView *horizontalSeparatorImageView;

@end

@implementation SUMarkViewToolbarCompositeButton

- (id)initWithModel:(SUCompositeButtonModel *)model
{
    self = [super initWithModel:model];

    if (self) {
        self.backgroundColor = [[SUPixelHunterTheme colors] lightGrayBackgroundColor];
        
        // Init horizontal separator
        UIImage *image = [UIImage imageNamed:kSUHorizontalSeparatorImageName];
        self.horizontalSeparatorImageView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:self.horizontalSeparatorImageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sz = self.frame.size;

    self.horizontalSeparatorImageView.frame = CGRectMake(0.0f,
                                                         sz.height - kSUHorizontalSeparatorHeight,
                                                         kSUHorizontalSeparatorWidth,
                                                         kSUHorizontalSeparatorHeight);
}

#pragma mark - From base class

- (UIImage *)separatorImage
{
    return [UIImage imageNamed:kSUVerticalSeparatorImageName];
}

@end
