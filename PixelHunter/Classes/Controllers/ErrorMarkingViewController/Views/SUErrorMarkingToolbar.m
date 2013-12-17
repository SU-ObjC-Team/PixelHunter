//
//  SUErrorMarkingToolbar.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUErrorMarkingToolbar.h"
#import "SUConstants.h"
#import "SUTheme.h"

static CGFloat const kSUButtonIndent = 5.0f;

@implementation SUErrorMarkingToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[SUTheme colors] lightGrayBackgroundColor];
        self.userInteractionEnabled = YES;
        
        // Init add markingview button
        self.addMarkingViewButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"add_screenshot_button.png"
                                                                  imageNamePressed:@"add_screenshot_button_active.png"
                                                                imageNameActivated:@"add_screenshot_button_active.png"];
        [self addSubview:self.addMarkingViewButton];
        
        // Init add text marking view button
        self.addTextMarkingViewButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"add_note_button.png"
                                                                      imageNamePressed:@"add_note_button_active.png"
                                                                    imageNameActivated:@"add_note_button_active.png"];
        [self addSubview:self.addTextMarkingViewButton];
        
        // Init send mail button
        self.sendMailButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"email_buton.png"
                                                                      imageNamePressed:@"email_buton_active.png"
                                                                    imageNameActivated:@"email_buton_active.png"];
        [self addSubview:self.sendMailButton];
        
        // Init show marking view toolbar button
        self.showMarkingViewToolbarButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"settings_button.png"
                                                                imageNamePressed:@"settings_button_active.png"
                                                              imageNameActivated:@"settings_button_active.png"];
        self.showMarkingViewToolbarButton.hidden = YES;
        self.showMarkingViewToolbarButton.enabled = NO;
        self.showMarkingViewToolbarButton.isSeparatorShown = NO;
        [self addSubview:self.showMarkingViewToolbarButton];
        
        // Init back button
        self.backButton = [[SUCompositeButton alloc] initWithImageNameNormal:@"back_button.png"
                                                             imageNamePressed:@"back_button_active.png"
                                                           imageNameActivated:@"back_button_active.png"];
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
