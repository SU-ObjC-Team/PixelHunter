//
//  SUPixelHunterPositioningUtility.h
//  ExamplePixelHunter
//
//  Created by Alex Saenko on 2/13/14.
//  Copyright (c) 2014 Sigma Ukraine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUPixelHunterPositioningUtility : NSObject

+ (void)moveViewAnimated:(UIView *)view toVisibleRect:(CGRect)visibleRect;

@end
