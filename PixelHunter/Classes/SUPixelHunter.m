//
//  SUPixelHunter.m
//  PixelHunter
//
//  Created by Alex Saenko on 9/19/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUPixelHunter.h"
#import "SUGridViewController.h"
#import "SUPixelHunterScreenshotUtil.h"
#import "SUZGestureView.h"
#import <CoreMotion/CoreMotion.h>


static const CGFloat kSUAccelerationThreshold = 1.7f;
static const CGFloat kSUAccelerometerUpdateInterval = 0.1f;
static const NSInteger kSUAlertButtonIndexCancel = 0;

@interface SUPixelHunter () <UIAccelerometerDelegate,
                             SUGridViewControllerDelegate>

@property (nonatomic, weak) UIAlertView *alertView;
@property (nonatomic, strong) UIWindow *debugWindow;
@property (nonatomic, strong) UIWindow *parentWindow;
@property (nonatomic, strong) CMMotionManager *motionManager;

@end


@implementation SUPixelHunter 

#pragma mark - Singleton methods

static id __sharedInstance;

+ (SUPixelHunter *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        __sharedInstance = [[SUPixelHunter alloc] init];
    });

    return __sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        __sharedInstance = nil;
        __sharedInstance = [super allocWithZone:zone];
    });
	
    return __sharedInstance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark - Initialization

- (id)init
{
    if (self = [super init]) {

        [self subscribeForSystemNotifications];
        [self initMotionManager];
    }
    
    return self;
}

- (void)subscribeForSystemNotifications
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver:self
                           selector:@selector(orientationChanged:)
                               name:UIApplicationDidChangeStatusBarOrientationNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(removeWindowForDebug)
                               name:UIApplicationDidEnterBackgroundNotification
                             object:nil];
}

- (void)initMotionManager
{
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = kSUAccelerometerUpdateInterval;
    
    NSOperationQueue *currentQueue = [NSOperationQueue currentQueue];
    [self.motionManager startAccelerometerUpdatesToQueue:currentQueue
         withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
             
             if (error) {
                 [self.motionManager stopAccelerometerUpdates];
             } else {
                 [self performSelectorOnMainThread:@selector(handleShake:)
                                        withObject:accelerometerData
                                     waitUntilDone:YES];
             }
         }];
}

#pragma mark - Public methods

+ (void)setup
{
    [SUPixelHunter sharedInstance];
}

#pragma mark - Accelerometer delegate

- (void)handleShake:(CMAccelerometerData *)accelerometerData
{
    CMAcceleration acceleration = accelerometerData.acceleration;
    if ([self shouldDebugModeBeInit:acceleration]) {

        [self activateZGestureView];
    }
}

- (BOOL)shouldDebugModeBeInit:(CMAcceleration)acceleration
{
    BOOL result = NO;

    if (acceleration.x > kSUAccelerationThreshold ||
        acceleration.y > kSUAccelerationThreshold ||
        acceleration.z > kSUAccelerationThreshold) {
        
        if (self.alertView == nil && self.debugWindow == nil) {
            result = YES;
        }
    }

    return result;
}

- (void)showAlert
{
    NSString *alertTitle = NSLocalizedStringFromTable(@"ENTER_UI_DEBUG_MODE",
                                                     @"PixelHunter", @"Enter UI debug mode");
    NSString *cancelTitle = NSLocalizedStringFromTable(@"CANCEL", @"PixelHunter", @"Cancel");
    NSString *enterTitle = NSLocalizedStringFromTable(@"ENTER", @"PixelHunter", @"Enter");

    // Create a local variable because alertView property is weak
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:alertTitle
                              message:nil
                              delegate:self
                              cancelButtonTitle:cancelTitle
                              otherButtonTitles:enterTitle, nil];
    [alertView show];
    self.alertView = alertView;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != kSUAlertButtonIndexCancel) {

        [self showWindowForDebug];
    }
}

- (void)activateZGestureView
{
    UIWindow *topWindow = [self getTopWindow];
    CGRect windowFrame = topWindow.rootViewController.view.frame;
    SUZGestureView *zGestureView = [[SUZGestureView alloc] initWithFrame:windowFrame];
    [zGestureView.zGestureRecognizer addTarget:self action:@selector(showAlert)];
    [topWindow.rootViewController.view addSubview:zGestureView];
}

- (void)showWindowForDebug
{
    self.parentWindow = [self getTopWindow];
    UIView *view = [[self.parentWindow rootViewController] view];
    UIImage *debugWindowImage = [SUPixelHunterScreenshotUtil convertViewToImage:view];

    SUGridViewController *viewController =
        [[SUGridViewController alloc] initWithImage:debugWindowImage];
    viewController.delegate = self;

    CGRect windowBounds = [self.parentWindow bounds];
    self.debugWindow = [[UIWindow alloc] initWithFrame:windowBounds];
    self.debugWindow.rootViewController = viewController;
    self.parentWindow.hidden = YES;
    [self.debugWindow makeKeyAndVisible];
}

- (void)removeWindowForDebug
{
    self.parentWindow.hidden = NO;
    self.debugWindow = nil;
    [self.alertView dismissWithClickedButtonIndex:0 animated:NO];
}

- (UIWindow *)getTopWindow
{
    return [[[UIApplication sharedApplication] delegate] window];
}

#pragma mark - Orientation handling

- (void)orientationChanged:(NSNotification *)notification
{
    SUGridRootView *rootView = (SUGridRootView *)self.debugWindow.rootViewController.view;
    [rootView setNeedsLayout];
    [rootView layoutViewsDependingOnOrientation];
}

#pragma mark - SUGridViewControllerDelegate

- (void)tapOnCloseButton
{
    [self removeWindowForDebug];
}

@end
