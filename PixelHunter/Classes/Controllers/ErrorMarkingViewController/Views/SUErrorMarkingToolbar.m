//
//  SUErrorMarkingToolbar.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingToolbar.h"
#import "SUPixelHunterConstants.h"
#import "SUPixelHunterTheme.h"

static CGFloat const kSUButtonIndent = 5.0f;
static CGFloat const kSUButtonWidth = 65.0f;
static CGFloat const kSUButtonHeight = 48.0f;

static NSString * const kSUMarkingViewButtonImageNormalName = @"add_screenshot_button.png";
static NSString * const kSUMarkingViewButtonImageActiveName = @"add_screenshot_button.png";

static NSString * const kSUTextMarkingViewButtonImageNormalName = @"add_note_button.png";
static NSString * const kSUTextMarkingViewButtonImageActiveName = @"add_note_button_active.png";

static NSString * const kSUSendMailButtonImageNormalName = @"email_buton.png";
static NSString * const kSUSendMailButtonImageActiveName = @"email_buton_active.png";

static NSString * const kSUShowMarkingViewToolbarButtonImageNormalName = @"settings_button.png";
static NSString * const kSUShowMarkingViewToolbarButtonImageActiveName = @"settings_button_active.png";

static NSString * const kSUBackButtonImageNormalName = @"back_button.png";
static NSString * const kSUBackButtonImageActiveName = @"back_button_active.png";

@implementation SUErrorMarkingToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[SUPixelHunterTheme colors] lightGrayBackgroundColor];
        self.userInteractionEnabled = YES;
        
        SUCompositeButtonModel *model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUMarkingViewButtonImageNormalName;
        model.imagePressedName = kSUMarkingViewButtonImageActiveName;
        model.imageActivatedName = kSUMarkingViewButtonImageActiveName;

        self.addMarkingViewButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.addMarkingViewButton];
        
        model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUTextMarkingViewButtonImageNormalName;
        model.imagePressedName = kSUTextMarkingViewButtonImageActiveName;
        model.imageActivatedName = kSUTextMarkingViewButtonImageActiveName;
        
        self.addTextMarkingViewButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.addTextMarkingViewButton];
        
        model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUSendMailButtonImageNormalName;
        model.imagePressedName = kSUSendMailButtonImageActiveName;
        model.imageActivatedName = kSUSendMailButtonImageActiveName;

        self.sendMailButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.sendMailButton];

        model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUShowMarkingViewToolbarButtonImageNormalName;
        model.imagePressedName = kSUShowMarkingViewToolbarButtonImageActiveName;
        model.imageActivatedName = kSUShowMarkingViewToolbarButtonImageActiveName;

        self.showMarkingViewToolbarButton = [[SUCompositeButton alloc] initWithModel:model];
        self.showMarkingViewToolbarButton.hidden = YES;
        self.showMarkingViewToolbarButton.separatorState = SUSeparatorHidden;
        [self addSubview:self.showMarkingViewToolbarButton];
        
        model = [SUCompositeButtonModel new];
        model.imageNormalName = kSUBackButtonImageNormalName;
        model.imagePressedName = kSUBackButtonImageActiveName;
        model.imageActivatedName = kSUBackButtonImageActiveName;

        self.backButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.backButton];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backButton.frame = CGRectMake(0.0f, 0.0f, kSUButtonWidth, kSUButtonHeight);
    
    self.addTextMarkingViewButton.frame = CGRectMake(CGRectGetMaxX(self.backButton.frame), 0.0f,
                                                     kSUButtonWidth, kSUButtonHeight);
    
    self.addMarkingViewButton.frame = CGRectMake(CGRectGetMaxX(self.addTextMarkingViewButton.frame), 0.0f,
                                                 kSUButtonWidth, kSUButtonHeight);
    
    self.sendMailButton.frame = CGRectMake(CGRectGetMaxX(self.addMarkingViewButton.frame), 0.0f,
                                           kSUButtonWidth, kSUButtonHeight);
    
    self.showMarkingViewToolbarButton.frame = CGRectMake(CGRectGetMaxX(self.sendMailButton.frame), 0.0f,
                                                         kSUButtonWidth, kSUButtonHeight);
}

@end
