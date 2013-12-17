//
//  SUCompositeButton.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    SUCompositeButtonStateNormal,
    SUCompositeButtonStateActivated,
}SUCompositeButtonState;

typedef enum {
    SUSeparatorShown,
    SUSeparatorHidden
}SUSeparatorState;


@interface SUCompositeButton : UIView

- (id)initWithImageNameNormal:(NSString *)imageNameNormal
             imageNamePressed:(NSString *)imageNamePressed
           imageNameActivated:(NSString *)imageNameActivated;

- (void)addTarget:(id)target action:(SEL)action;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *separatorImageView;

@property (nonatomic, assign) SUCompositeButtonState state;
@property (nonatomic, assign) SUSeparatorState separatorState;

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, assign) BOOL isSeparatorShown;

@end
