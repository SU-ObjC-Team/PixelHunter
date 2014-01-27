//
//  SUGridViewController.m
//  PixelHunter
//
//  Created by Alex Saenko on 9/19/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridViewController.h"
#import "SUPixelHunter.h"
#import "SUPixelHunterConstants.h"
#import "SUPixelHunterScreenshotUtil.h"
#import "SUErrorMarkingViewController.h"


@interface SUGridViewController () <SUGridViewControllerDelegate,
                                    UIScrollViewDelegate,
                                    UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate>

@property (nonatomic, strong) UIImage *screenshotImage;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end


@implementation SUGridViewController

- (id)initWithImage:(UIImage *)screenshotImage
{
	self = [super init];
	if (self) {
		self.screenshotImage = screenshotImage;
	}
    
	return self;
}

#pragma mark - Viewcontroller's life cycle

- (void)loadView
{
    [super loadView];
    
    CGSize sz = [[UIScreen mainScreen] applicationFrame].size;
    SUGridRootView *view = [[SUGridRootView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, sz.width, sz.height) withScreenshotImage:self.screenshotImage];
    view.contentMode = UIViewContentModeScaleAspectFit;
    self.view = view;
    self.gridRootView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Toolbar actions
    [self.gridRootView.toolbar.closeButton addTarget:self
                                              action:@selector(tapOnCloseButton)];
    [self.gridRootView.toolbar.showPickerButton addTarget:self
                                                   action:@selector(showImagePicker)];
    [self.gridRootView.toolbar.showMarkingViewControllerButton addTarget:self
                                                 action:@selector(showMarkingViewController)];
    [self.gridRootView.toolbar.slider addTarget:self
                                        action:@selector(changeMockupImageAlpha:)
                              forControlEvents:UIControlEventValueChanged];
    
    // Scroll view stuff
    self.gridRootView.gridUnderLayerView.scrollView.delegate = self;
    self.gridRootView.gridUnderLayerView.scrollView.contentSize = self.gridRootView.gridUnderLayerView.containerView.frame.size;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.gridRootView.gridUnderLayerView.scrollView.minimumZoomScale =
        self.gridRootView.gridUnderLayerView.scrollView.frame.size.width / self.gridRootView.gridUnderLayerView.containerView.frame.size.width;
    self.gridRootView.gridUnderLayerView.scrollView.maximumZoomScale = kSUMaximumZoomScale;
    [self.gridRootView.gridUnderLayerView.scrollView setZoomScale:self.gridRootView.gridUnderLayerView.scrollView.minimumZoomScale];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.gridRootView.gridUnderLayerView.scrollView setZoomScale:self.gridRootView.gridUnderLayerView.scrollView.minimumZoomScale];
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.gridRootView.gridUnderLayerView.containerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeRulerPositions];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.gridRootView.gridUnderLayerView.containerView.frame = [self centeredFrameForScrollView:scrollView andView:self.gridRootView.gridUnderLayerView.containerView];
    [self changeRulerPositions];
    if (self.gridRootView.gridUnderLayerView.scrollView.zoomScale == kSUMaximumZoomScale) {
        self.gridRootView.smallGridView.hidden = NO;
    } else {
        self.gridRootView.smallGridView.hidden = YES;
    }
}

- (CGRect)centeredFrameForScrollView:(UIScrollView *)scroll andView:(UIView *)view
{
	CGSize boundsSize = scroll.bounds.size;
    CGRect frameToCenter = view.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
        frameToCenter.origin.y = 0;
    }
	
	return frameToCenter;
}

- (void)changeRulerPositions
{    
    self.gridRootView.topRuler.frame = CGRectMake(-self.gridRootView.gridUnderLayerView.scrollView.contentOffset.x, 0.0f,
                                                  self.gridRootView.gridUnderLayerView.scrollView.contentSize.width , kSURulerSize);
    self.gridRootView.sideRuler.frame = CGRectMake(0.0f, -self.gridRootView.gridUnderLayerView.scrollView.contentOffset.y,
                                                   kSURulerSize, self.gridRootView.gridUnderLayerView.scrollView.contentSize.height);

    self.gridRootView.smallGridView.startVerticalPoint = (NSInteger) self.gridRootView.topRuler.frame.origin.x % 40;
    self.gridRootView.smallGridView.startHorizontalPoint = (NSInteger) self.gridRootView.sideRuler.frame.origin.y % 40;
    [self.gridRootView.smallGridView setNeedsDisplay];
}

- (void)changeMockupImageAlpha:(UISlider *)sender
{
    self.gridRootView.gridUnderLayerView.mockupImageView.alpha = sender.value;
}

- (void)showImagePicker
{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePicker animated:YES completion:^{
        [self.gridRootView.gridUnderLayerView.scrollView setZoomScale:self.gridRootView.gridUnderLayerView.scrollView.minimumZoomScale];
    }];
}

#pragma mark - Error marking view controller

- (void)showMarkingViewController
{
    [self.gridRootView.toolbar setHidden:YES];
    UIImage *imgage = [SUPixelHunterScreenshotUtil convertViewToImage:self.view];
    SUErrorMarkingViewController *errorMarkingViewController = [[SUErrorMarkingViewController alloc] initWithImage:imgage];
    [self presentViewController:errorMarkingViewController animated:YES completion:^{
        [self.gridRootView.toolbar setHidden:NO];
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.gridRootView.gridUnderLayerView.mockupImageView.image = image;
    self.gridRootView.toolbar.slider.enabled = YES;
}

#pragma mark - Delegate

- (void)tapOnCloseButton
{
    [self.delegate tapOnCloseButton];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
