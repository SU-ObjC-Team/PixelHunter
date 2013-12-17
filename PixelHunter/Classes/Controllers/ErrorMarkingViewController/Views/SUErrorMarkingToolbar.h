//
//  SUErrorMarkingToolbar.h
//  PixelHunter
//
//  Created by Alex Saenko on 10/14/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUCompositeButton.h"


@interface SUErrorMarkingToolbar : UIView

@property (nonatomic, strong) SUCompositeButton *addMarkingViewButton;
@property (nonatomic, strong) SUCompositeButton *sendMailButton;
@property (nonatomic, strong) SUCompositeButton *showMarkingViewToolbarButton;
@property (nonatomic, strong) SUCompositeButton *addTextMarkingViewButton;
@property (nonatomic, strong) SUCompositeButton *backButton;

@end
