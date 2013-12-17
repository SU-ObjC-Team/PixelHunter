//
//  SUGridTopRulerView.h
//  PixelHunter
//
//  Created by Alex Saenko on 9/26/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SUGridRulerView : UIView

@property (nonatomic, assign) CGFloat scale;

- (id)initWithFrame:(CGRect)frame horizontal:(BOOL)isHorizontal;

@end
