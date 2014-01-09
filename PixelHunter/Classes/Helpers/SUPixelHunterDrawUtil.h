//
//  SUDrawUtil.h
//  PixelHunter
//
//  Created by Alex Saenko on 9/30/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SUPixelHunterDrawUtil : NSObject

+ (void)draw1PxStrokeWithContext:(CGContextRef)context
                  withStartPoint:(CGPoint)startPoint
                    withEndPoint:(CGPoint)endPoint
                       withColor:(CGColorRef)color;

@end
