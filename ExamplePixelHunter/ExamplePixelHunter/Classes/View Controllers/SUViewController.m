//
//  SUViewController.m
//  ExamplePixelHunter
//
//  Created by Alex Saenko on 11/1/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUViewController.h"
#import "SUPixelHunter.h"

@interface SUViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation SUViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Uncomment this code for instant enter to UI debug mode while using simulator
    
    SUPixelHunter *pixelHunter = [[SUPixelHunter alloc] init];
    [pixelHunter performSelector:@selector(showWindowForDebug)];
}

@end
