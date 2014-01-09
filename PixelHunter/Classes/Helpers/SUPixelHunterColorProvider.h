//
//  SUColorProvider.h
//  PixelHunter
//
//  Created by Alex Saenko on 12/10/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@interface SUPixelHunterColorProvider : NSObject

@property (nonatomic, readonly) UIColor *darkGrayBackgroundColor;
@property (nonatomic, readonly) UIColor *lightGrayBackgroundColor;

@end
