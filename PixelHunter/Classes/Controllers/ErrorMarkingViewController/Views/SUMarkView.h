//
//  SUMarkView.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SUMarkView;

static NSString * const kSUShakingAnimationKey = @"shakingAnimation";

typedef enum {
    SUMarkViewCornerTypeNone = 0,
    SUMarkViewCornerTypeRound,
    SUMarkViewCornerTypeCorner
} SUMarkViewCornerType;

@protocol SUMarkViewDelegate <NSObject>

- (void)panGestureActivatedWithView:(SUMarkView *)markView;

@end


@interface SUMarkView : UIView

- (id)initWithView:(UIView *)view;
- (void)addDeleteButtonTarget:(id)target selector:(SEL)selector;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic, assign) CGPoint selectedColorCenter;
@property (nonatomic, assign) id <SUMarkViewDelegate> delegate;
@property (nonatomic, assign) SUMarkViewCornerType *conterType;
@property (nonatomic, assign) BOOL isDeletingAnimationOn;
@property (nonatomic, strong) UIButton *removeButton;
@property (nonatomic, assign) CGFloat cornerRadius;

@end
