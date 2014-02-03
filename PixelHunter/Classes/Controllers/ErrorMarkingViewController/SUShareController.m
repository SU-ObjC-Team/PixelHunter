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

        [mailComposeViewController setSubject:NSLocalizedStringFromTable(@"MAIL_SUBJECT", @"PixelHunter", nil)];
        for (UIView *view in self.unnecessaryViewsArray) {
            if (view.hidden == NO) {
                [view setHidden:YES];
            }
        }
        [self.screenshotSound play];
        [self showBlinkingViewWithCompletionBlock:^(void) {
            UIImage *imageToSend = [SUPixelHunterScreenshotUtil convertViewToImage:self.viewController.view];
            NSData *imageData = UIImageJPEGRepresentation(imageToSend, 1.0f);
            [mailComposeViewController addAttachmentData:imageData mimeType:@"image/png" fileName:@"Bug-image.png"];
            NSString *emailBody = NSLocalizedStringFromTable(@"MAIL_BODY", @"PixelHunter", nil);
            [mailComposeViewController setMessageBody:emailBody isHTML:NO];

            [self.viewController presentViewController:mailComposeViewController animated:YES completion:nil];
        }];
    } else {
        [self showErrorAlertView];
    }
}

- (void)createScreenshotSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"photoShutter" ofType:@"mp3"];
    self.screenshotSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
}

- (void)showBlinkingViewWithCompletionBlock:(void (^)())completionBlock
{
    UIViewController *viewController;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.viewController.view.frame.size.width, self.viewController.view.frame.size.height)];
    [UIView animateWithDuration:1.0f animations:^{
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
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedStringFromTable(@"ERROR_ALERT_VIEW_TITLE", @"PixelHunter", nil)
                              message:NSLocalizedStringFromTable(@"ERROR_ALERT_VIEW_MESSAGE", @"PixelHunter", nil)
                              delegate:self
                              cancelButtonTitle:NSLocalizedStringFromTable(@"OK", @"PixelHunter", nil)
                              otherButtonTitles:nil];
    [alertView show];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
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
