//
//  SUCompositeButton.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    SUCompositeButtonStateNormal = 0,
    SUCompositeButtonStateActivated,
} SUCompositeButtonState;

typedef enum {
    SUSeparatorShown = 0,
    SUSeparatorHidden
} SUSeparatorState;


@interface SUCompositeButtonModel : NSObject

@property (nonatomic, strong) NSString *imageNormalName;
@property (nonatomic, strong) NSString *imagePressedName;
@property (nonatomic, strong) NSString *imageActivatedName;

@end


@interface SUCompositeButton : UIView

- (id)initWithModel:(SUCompositeButtonModel *)model;

- (void)addTarget:(id)target action:(SEL)action;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *separatorImageView;

@property (nonatomic, assign) SUCompositeButtonState state;
@property (nonatomic, assign) SUSeparatorState separatorState;

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL isSeparatorShown;

@end
