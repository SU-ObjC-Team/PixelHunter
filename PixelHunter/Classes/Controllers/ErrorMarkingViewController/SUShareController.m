//
//  SUShareController.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/15/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUShareController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "SUPixelHunterScreenshotUtil.h"

static NSString * const kSUBugImageName = @"Bug-image.png";
static NSString * const kSUBugImageType = @"image/png";
static NSString * const kSUSoundName = @"photoShutter";
static NSString * const kSUSoundType = @"mp3";
static const CGFloat kSUAnimationTime = 1.0f;
static const CGFloat kSUImageQuality = 1.0f;


@interface SUShareController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) AVAudioPlayer *screenshotSound;
@property (nonatomic, strong) SUErrorMarkingToolbar *toolbar;
@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) NSArray *unnecessaryViewsArray;

@end


@implementation SUShareController

- (id)initWithToolbar:(SUErrorMarkingToolbar *)toolbar
   withMenuViewsArray:(NSArray *)menuViewsArray
     onViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        self.toolbar = toolbar;
        self.unnecessaryViewsArray = menuViewsArray;
        self.viewController = viewController;
        
        [self.toolbar.sendMailButton addTarget:self action:@selector(sendScreenshotViaMail:)];
        [self createScreenshotSound];
    }
    
    return self;
}

- (void)sendScreenshotViaMail:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
        mailComposeViewController.mailComposeDelegate = self;
        
        NSString *subjectString = NSLocalizedStringFromTable(@"MAIL_SUBJECT", @"PixelHunter", nil);

        [mailComposeViewController setSubject:subjectString];
        for (UIView *view in self.unnecessaryViewsArray) {
            if (view.hidden == NO) {
                [view setHidden:YES];
            }
        }
        [self.screenshotSound play];
        [self showBlinkingViewWithCompletionBlock:^(void) {
            UIView *viewToSend = self.viewController.view;
            UIImage *imageToSend = [SUPixelHunterScreenshotUtil convertViewToImage:viewToSend];
            NSData *imageData = UIImageJPEGRepresentation(imageToSend, kSUImageQuality);
            
            [mailComposeViewController addAttachmentData:imageData
                                                mimeType:kSUBugImageType
                                                fileName:kSUBugImageName];
            NSString *emailBody = NSLocalizedStringFromTable(@"MAIL_BODY", @"PixelHunter", nil);
            [mailComposeViewController setMessageBody:emailBody isHTML:NO];

            [self.viewController presentViewController:mailComposeViewController
                                              animated:YES
                                            completion:nil];
        }];
    } else {
        [self showErrorAlertView];
    }
}

- (void)createScreenshotSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:kSUSoundName ofType:kSUSoundType];
    self.screenshotSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]
                                                                  error:nil];
}

- (void)showBlinkingViewWithCompletionBlock:(void (^)())completionBlock
{
    UIViewController *viewController;
    CGSize frameSize = self.viewController.view.frame.size;
    CGRect frameRect = CGRectMake(0.0f, 0.0f, frameSize.width, frameSize.height);
    UIView *view = [[UIView alloc] initWithFrame:frameRect];
    
    [UIView animateWithDuration:kSUAnimationTime animations:^{
        [self.viewController.view addSubview:view];
        view.backgroundColor = [UIColor whiteColor];
        view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        completionBlock(viewController);
    }];
}

- (void)showErrorAlertView
{
    NSString *alertTitle = NSLocalizedStringFromTable(@"ERROR_ALERT_VIEW_TITLE",
                                                      @"PixelHunter", nil);
    NSString *alertMessage = NSLocalizedStringFromTable(@"ERROR_ALERT_VIEW_MESSAGE",
                                                        @"PixelHunter", nil);
    NSString *cancelButtonTitle = NSLocalizedStringFromTable(@"OK", @"PixelHunter", nil);
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:alertTitle
                              message:alertMessage
                              delegate:self
                              cancelButtonTitle:cancelButtonTitle
                              otherButtonTitles:nil];
    [alertView show];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch(result)
    {
        case MFMailComposeResultFailed:
            [self showErrorAlertView];
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
