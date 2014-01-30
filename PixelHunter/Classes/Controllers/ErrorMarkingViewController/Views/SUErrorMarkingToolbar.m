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

@implementation SUErrorMarkingToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[SUPixelHunterTheme colors] lightGrayBackgroundColor];
        self.userInteractionEnabled = YES;
        
        // Init add markingview button
        SUCompositeButtonModel *model = [SUCompositeButtonModel new];
        model.imageNormalName = @"add_screenshot_button.png";
        model.imagePressedName = @"add_screenshot_button_active.png";
        model.imageActivatedName = @"add_screenshot_button_active.png";

        self.addMarkingViewButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.addMarkingViewButton];
        
        // Init add text marking view button
        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"add_note_button.png";
        model.imagePressedName = @"add_note_button_active.png";
        model.imageActivatedName = @"add_note_button_active.png";
        
        self.addTextMarkingViewButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.addTextMarkingViewButton];
        
        // Init send mail button
        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"email_buton.png";
        model.imagePressedName = @"email_buton_active.png";
        model.imageActivatedName = @"email_buton_active.png";

        self.sendMailButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.sendMailButton];
        
        // Init show marking view toolbar button
        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"settings_button.png";
        model.imagePressedName = @"settings_button_active.png";
        model.imageActivatedName = @"settings_button_active.png";

        self.showMarkingViewToolbarButton = [[SUCompositeButton alloc] initWithModel:model];
        self.showMarkingViewToolbarButton.hidden = YES;
        self.showMarkingViewToolbarButton.enabled = NO;
        self.showMarkingViewToolbarButton.isSeparatorShown = NO;
        [self addSubview:self.showMarkingViewToolbarButton];
        
        // Init back button
        model = [SUCompositeButtonModel new];
        model.imageNormalName = @"back_button.png";
        model.imagePressedName = @"back_button_active.png";
        model.imageActivatedName = @"back_button_active.png";

        self.backButton = [[SUCompositeButton alloc] initWithModel:model];
        [self addSubview:self.backButton];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Layout back button
    self.backButton.frame = CGRectMake(0.0f, 0.0f, kSUErrorMarkingToolbarButtonWidth, kSUErrorMarkingToolbarButtonHeight);
    
    // Layout add text marking view button
    self.addTextMarkingViewButton.frame = CGRectMake(CGRectGetMaxX(self.backButton.frame), 0.0f,
                                                     kSUErrorMarkingToolbarButtonWidth, kSUErrorMarkingToolbarButtonHeight);
    
    // Layout add markingview button
    self.addMarkingViewButton.frame = CGRectMake(CGRectGetMaxX(self.addTextMarkingViewButton.frame), 0.0f,
                                                 kSUErrorMarkingToolbarButtonWidth, kSUErrorMarkingToolbarButtonHeight);
    
    // Layout send mail button
    self.sendMailButton.frame = CGRectMake(CGRectGetMaxX(self.addMarkingViewButton.frame), 0.0f,
                                           kSUErrorMarkingToolbarButtonWidth, kSUErrorMarkingToolbarButtonHeight);
    
    // Layout show marking view toolbar button
    self.showMarkingViewToolbarButton.frame = CGRectMake(CGRectGetMaxX(self.sendMailButton.frame), 0.0f,
                                                         kSUErrorMarkingToolbarButtonWidth, kSUErrorMarkingToolbarButtonHeight);
}

@end
