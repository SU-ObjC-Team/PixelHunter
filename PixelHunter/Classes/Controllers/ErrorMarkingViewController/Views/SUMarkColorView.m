//
//  SUMarkColorView.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/17/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUMarkColorView.h"
#import "SUColorView.h"
#import "SUPixelHunterConstants.h"
#import "SUPixelHunterColorProvider.h"


@interface SUMarkColorView ()

@property (nonatomic, strong) NSArray *colorArray;
@property (nonatomic, strong) NSMutableArray *colorViews;

@end


@implementation SUMarkColorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.userInteractionEnabled = YES;
        
        // Init color views array
        self.colorViews = [[NSMutableArray alloc] init];
        
        // Init colors array
        [self setupColorArray];
        
        // Init color views
        for (NSInteger i = 0; i < [self.colorArray count]; i++) {
            SUColorView *colorView = [[SUColorView alloc] initWithColor:[self.colorArray objectAtIndex:i]];
            colorView.frame = [self rectWithIndex:i];
            [colorView.colorViewButton addTarget:self action:@selector(colorViewDidPress:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:colorView];
            [self.colorViews addObject:colorView];
        }
        
        // Init selected color view
        self.selectedColorView = [[UIView alloc] init];
        self.selectedColorView.userInteractionEnabled = NO;
        self.selectedColorView.backgroundColor = [UIColor colorWithWhite:0.5f alpha:0.3f];
        self.selectedColorView.frame = kSUColorViewRect;
        self.selectedColorView.center = ((SUColorView *)[self.colorViews objectAtIndex:0]).center;
        [self addSubview:self.selectedColorView];
        
    }
    
    return self;
}

- (void)colorViewDidPress:(UIButton *)colorViewButton
{
    [UIView animateWithDuration:kSUStandardAnimationTime animations:^{
        self.selectedColorView.center = ((SUColorView *)colorViewButton.superview).center;
    }];
    [self.delegate colorViewPickedWithColor:((SUColorView *)colorViewButton.superview).color withSelectedColorViewCenter:((SUColorView *)colorViewButton.superview).center];
}

- (CGRect)rectWithIndex:(NSInteger)index
{
    CGRect tempRect = kSUColorViewRect;
    
    tempRect.origin.y = (tempRect.origin.y + tempRect.size.width) * index;
    
    return tempRect;
}

- (void)setupColorArray
{
    self.colorArray = [NSArray arrayWithObjects:RGB(255.0f, 0.0f, 19.0f),
                                                RGB(255.0f, 98.0f, 36.0f),
                                                RGB(253.0f, 254.0f, 80.0f),
                                                RGB(0.0f, 185.0f, 59.0f),
                                                RGB(22.0f, 183.0f, 243.0f),
                                                RGB(14.0f, 60.0f, 181.0f),
                                                RGB(231.0f, 0.0f, 205.0f),
//                       [UIColor colorWithRed:255.0f/255.0f green:0.0f/255.0f blue:19.0f/255.0f alpha:1.0f],
//                       [UIColor colorWithRed:255.0f/255.0f green:98.0f/255.0f blue:36.0f/255.0f alpha:1.0f],
//                       [UIColor colorWithRed:253.0f/255.0f green:254.0f/255.0f blue:80.0f/255.0f alpha:1.0f],
//                       [UIColor colorWithRed:0.0f/255.0f green:185.0f/255.0f blue:59.0f/255.0f alpha:1.0f],
//                       [UIColor colorWithRed:22.0f/255.0f green:183.0f/255.0f blue:243.0f/255.0f alpha:1.0f],
//                       [UIColor colorWithRed:14.0f/255.0f green:60.0f/255.0f blue:181.0f/255.0f alpha:1.0f],
//                       [UIColor colorWithRed:231.0f/255.0f green:0.0f/255.0f blue:205.0f/255.0f alpha:1.0f],
                       nil];
}

@end
