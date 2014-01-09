//
//  SUGridTopRulerView.m
//  PixelHunter
//
//  Created by Alex Saenko on 9/26/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridRulerView.h"
#import "SUPixelHunterConstants.h"
#import "SUPixelHunterDrawUtil.h"

static const CGFloat kSUFontSize = 11.0f;

@interface SUGridRulerView ()

@property (nonatomic, assign) BOOL isHorizontal;

@end


@implementation SUGridRulerView

- (id)initWithFrame:(CGRect)frame horizontal:(BOOL)isHorizontal
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.5f];
        self.isHorizontal = isHorizontal;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat cellSize = [self cellWidthWithRect:rect withScale:self.scale];
    CGFloat cellDrawnSize = cellSize * self.scale;
    if (cellDrawnSize > 0.0f) {
        if (self.isHorizontal) {
            for (NSInteger i = 0; i <= rect.size.width / cellDrawnSize; i++) {
                CGRect rect = CGRectMake(i * cellDrawnSize, 0.0f, cellDrawnSize, kSURulerSize);
                NSString *numberString = [NSString stringWithFormat:@" %.0f", i * cellSize];
                [self drawNumbersInRect:rect withNumberString:numberString];
            }
        }
        if (!self.isHorizontal) {
            for (NSInteger i = 0; i <= rect.size.height / cellDrawnSize; i++) {
                CGRect rect = CGRectMake(0.0f, i * cellDrawnSize, kSURulerSize, cellDrawnSize);
                NSString *numberString = [NSString stringWithFormat:@" %.0f", i * cellSize];
                [self drawNumbersInRect:rect withNumberString:numberString];
            }
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
    if (self.isHorizontal) {
        CGFloat width = rect.size.width / scale;
        for (NSInteger i = 0; i < kSUSizesLength; i++) {
            CGFloat difference =  rect.size.width / (width / arrSizes[i]);
            if (difference > kSUMinCellLength && difference < kSUMaxCellLength) {
                result = arrSizes[i];
                break;
            }
        }
    } else {
        CGFloat height = rect.size.height / scale;
        for (NSInteger i = 0; i < kSUSizesLength; i++) {
            CGFloat difference =  rect.size.height / (height / arrSizes[i]);
            if (difference > kSUMinCellLength && difference < kSUMaxCellLength) {
                result = arrSizes[i];
                break;
            }
        }
    }
    
    return result;
}

@end
