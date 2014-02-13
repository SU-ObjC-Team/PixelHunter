//
//  SUMailShareController.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/15/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUMailShareController.h"
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


@interface SUMailShareController () <MFMailComposeViewControllerDelegate>

@property (nonatomic, strong) AVAudioPlayer *screenshotSound;
@property (nonatomic, strong) UIViewController *viewController;

@end


@implementation SUMailShareController

- (id)initWithSendMailButton:(SUCompositeButton *)button
     viewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        self.viewController = viewController;
        
        [button addTarget:self action:@selector(sendScreenshotViaMail)];
        [self createScreenshotSound];
    }
    
    return self;
}

- (void)sendScreenshotViaMail
{
    if ([MFMailComposeViewController canSendMail]) {
        
        [self.delegate screenshotWillTake];
        [self.screenshotSound play];
        
        [self showBlinkingViewWithCompletionBlock:^(void) {
            
            NSData *imageData = [self getSreenshotData];
            [self sendEmailWithImageData:imageData];

            [self.delegate screenshotDidTake];
            
        }];
    } else {
        [self showErrorAlertView];
    }
}

- (void)sendEmailWithImageData:(NSData *)imageData
{
    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
    mailComposeViewController.mailComposeDelegate = self;
    
    NSString *subjectString = NSLocalizedStringFromTable(@"MAIL_SUBJECT", @"PixelHunter", nil);
    [mailComposeViewController setSubject:subjectString];
    [mailComposeViewController addAttachmentData:imageData
                                        mimeType:kSUBugImageType
                                        fileName:kSUBugImageName];
    NSString *emailBody = NSLocalizedStringFromTable(@"MAIL_BODY", @"PixelHunter", nil);
    [mailComposeViewController setMessageBody:emailBody isHTML:NO];
    
    [self.viewController presentViewController:mailComposeViewController
                                      animated:YES
                                    completion:nil];

}

- (NSData *)getSreenshotData
{
    UIView *viewToSend = self.viewController.view;
    UIImage *imageToSend = [SUPixelHunterScreenshotUtil convertViewToImage:viewToSend];
    
    return UIImageJPEGRepresentation(imageToSend, kSUImageQuality);
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
    view.backgroundColor = [UIColor whiteColor];
    
    [UIView animateWithDuration:kSUAnimationTime animations:^{
        [self.viewController.view addSubview:view];
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
    if (result == MFMailComposeResultFailed) {
        [self showErrorAlertView];
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
