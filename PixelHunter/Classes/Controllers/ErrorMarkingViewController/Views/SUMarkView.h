//
//  SUMarkView.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const kSUShakingAnimationKey = @"shakingAnimation";

@protocol SUMarkViewDelegate <NSObject>

- (void)panGestureActivated:(UIPanGestureRecognizer *)recognizer;

@end


@interface SUMarkView : UIView

- (id)initWithView:(UIView *)view;
- (void)addShakingAnimationWithTarget:(id)target selector:(SEL)selector;
- (void)removeShakingAnimation;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) CGPoint selectedColorCenter;
@property (nonatomic, assign) id <SUMarkViewDelegate> delegate;

@end
