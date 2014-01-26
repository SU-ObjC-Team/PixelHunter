//
//  SUGridTopRulerView.m
//  PixelHunter
//
//  Created by Alex Saenko on 9/26/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridRulerView.h"

static const CGFloat kSUFontSize = 11.0f;


@implementation SUGridRulerView

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat cellSize = [self cellWidthWithRect:rect withScale:self.scale];
    CGFloat cellDrawnSize = cellSize * self.scale;
    CGFloat maxLength = [self maxLengthForRect:rect];

    if (cellDrawnSize > 0.0f) {

        for (NSInteger i = 0; i <= maxLength / cellDrawnSize; i++) {
            CGRect rect = [self rectForLenght:cellDrawnSize position:i];
            NSString *numberString = [NSString stringWithFormat:@" %.0f", i * cellSize];
            [self drawNumbersInRect:rect withNumberString:numberString];
        }
    }
}

- (void)drawNumbersInRect:(CGRect)rect withNumberString:(NSString *)numberString
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextStrokeRect(context, rect);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    UIFont *font = [UIFont boldSystemFontOfSize:kSUFontSize];
        
    [numberString drawInRect:rect
                    withFont:font
               lineBreakMode:NSLineBreakByWordWrapping
                   alignment:NSTextAlignmentLeft];
}

- (CGFloat)cellWidthWithRect:(CGRect)rect withScale:(CGFloat)scale
{
    CGFloat result = 0.0f;

    CGFloat maxLenght = [self maxLengthForRect:rect];
    CGFloat lenght = maxLenght / scale;
    for (NSInteger i = 0; i < kSUSizesLength; i++) {
        CGFloat difference =  maxLenght / (lenght / kSUArrSizes[i]);
        if (difference > kSUMinCellLength && difference < kSUMaxCellLength) {
            result = kSUArrSizes[i];
            break;
        }
    }
    
    return result;
}

- (CGRect)rectForLenght:(CGFloat)lenght position:(NSInteger)position
{
    return CGRectZero;
}

- (CGFloat)maxLengthForRect:(CGRect)rect
{
    return 0.0f;
}

@end
