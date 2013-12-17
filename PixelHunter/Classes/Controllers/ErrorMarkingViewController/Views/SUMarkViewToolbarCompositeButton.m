//
//  SUMarkViewToolbarCompositeButton.m
//  ExamplePixelHunter
//
//  Created by Alex Saenko on 12/10/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUMarkViewToolbarCompositeButton.h"
#import "SUConstants.h"
#import "SUTheme.h"

@interface SUMarkViewToolbarCompositeButton ()

@property (nonatomic, strong) UIImageView *horizontalSeparatorImageView;

@end

@implementation SUMarkViewToolbarCompositeButton

- (id)initWithImageNameNormal:(NSString *)imageNameNormal
             imageNamePressed:(NSString *)imageNamePressed
           imageNameActivated:(NSString *)imageNameActivated
{
    self = [super initWithImageNameNormal:imageNameNormal imageNamePressed:imageNamePressed imageNameActivated:imageNameActivated];
    if (self) {
        self.backgroundColor = [[SUTheme colors] lightGrayBackgroundColor];
        
        // Init separator image view
        self.separatorImageView.image = [UIImage imageNamed:@"sidebar_vertical_separator.png"];
        
        // Init horizontal separator
        self.horizontalSeparatorImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_horizontal_separator.png"]];
        [self addSubview:self.horizontalSeparatorImageView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sz = self.frame.size;
    
    // Layout horizontal separator
    self.horizontalSeparatorImageView.frame = CGRectMake(0.0f, sz.height - kSUHorizontalSeparatorHeight, kSUHorizontalSeparatorWidth, kSUHorizontalSeparatorHeight);
}

@end
