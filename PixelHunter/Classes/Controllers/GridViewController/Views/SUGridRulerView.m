//
//  SUGridTopRulerView.m
//  PixelHunter
//
//  Created by Alex Saenko on 9/26/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridRulerView.h"

static const CGFloat kSUScaleDefault = 1.0f;
static const CGFloat kSURulerLabelsFontSize = 11.0f;
static const CGFloat kSUMaxCellLength = 90.0f;
static const CGFloat kSUMinCellLength = 35.0f;
static const NSInteger kSUSizesLength = 10;
static const CGFloat kSUArrSizes [] = {1.0f, 2.0f, 5.0f, 10.0f, 20.0f, 50.0f,
                                       100.0f, 200.0f, 500.0f, 1000.0f};


@implementation SUGridRulerView

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
        self.scale = kSUScaleDefault;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat cellWidth = [self cellWidthWithScale:self.scale];
    CGFloat cellDrawnSize = cellWidth * self.scale;
    CGFloat maxLength = [self maxLengthForRect:rect];

    if (cellDrawnSize > 0.0f) {

        for (NSInteger i = 0; i <= maxLength / cellDrawnSize; i++) {
            CGRect rect = [self rectForLength:cellDrawnSize position:i];
            NSString *numberString = [NSString stringWithFormat:@" %.0f", i * cellWidth];
            [self drawNumbersInRect:rect withNumberString:numberString];
        }
    }
}

- (void)drawNumbersInRect:(CGRect)rect withNumberString:(NSString *)numberString
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextStrokeRect(context, rect);
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    UIFont *font = [UIFont boldSystemFontOfSize:kSURulerLabelsFontSize];
        
    [numberString drawInRect:rect
                    withFont:font
               lineBreakMode:NSLineBreakByWordWrapping
                   alignment:NSTextAlignmentLeft];
}

- (CGFloat)cellWidthWithScale:(CGFloat)scale
{
    CGFloat result = 0.0f;

    for (NSInteger i = 0; i < kSUSizesLength; i++) {
        
        CGFloat lengthsCoef =  kSUArrSizes[i] * scale;
        if (lengthsCoef > kSUMinCellLength && lengthsCoef < kSUMaxCellLength) {
            result = kSUArrSizes[i];
            break;
        }
    }
    
    return result;
}

@end
