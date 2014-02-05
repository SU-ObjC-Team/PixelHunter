//
//  SUGridView.h
//  PixelHunter
//
//  Created by Alex Saenko on 9/18/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SUGridView : UIView

- (id)initWithSmallGrid:(BOOL)isSmallGrid;

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat gridStepSize;

@end
