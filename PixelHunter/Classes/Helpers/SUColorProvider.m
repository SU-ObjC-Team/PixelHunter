//
//  SUColorProvider.h
//  PixelHunter
//
//  Created by Alex Saenko on 12/10/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUColorProvider.h"


@implementation SUColorProvider;

#pragma mark - Background colors 

- (UIColor *)darkGrayBackgroundColor
{
    return [UIColor colorWithRed:28.0f/255.0f green:27.0f/255.0f blue:32.0f/255.0f alpha:1.0f];
}

- (UIColor *)lightGrayBackgroundColor
{
    return [UIColor colorWithRed:36.0f/255.0f green:35.0f/255.0f blue:40.0f/255.0f alpha:1.0f];
}

@end

