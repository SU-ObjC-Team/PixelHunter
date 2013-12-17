//
//  SUMarkView.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SUMarkViewDelegate <NSObject>

- (void)panGestureActivated:(UIPanGestureRecognizer *)recognizer;

@end


@interface SUMarkView : UIView

- (id)initWithFrame:(CGRect)frame withView:(UIView *)view;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) CGPoint selectedColorCenter;
@property (nonatomic, assign) id <SUMarkViewDelegate> delegate;

@end
