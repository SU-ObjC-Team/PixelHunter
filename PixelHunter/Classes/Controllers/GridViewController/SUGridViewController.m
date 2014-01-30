//
//  SUGridViewController.m
//  PixelHunter
//
//  Created by Alex Saenko on 9/19/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUGridViewController.h"
#import "SUPixelHunterScreenshotUtil.h"
#import "SUErrorMarkingViewController.h"

@interface SUGridViewController () <SUGridViewControllerDelegate,
                                    UIScrollViewDelegate,
                                    UIImagePickerControllerDelegate,
                                    UINavigationControllerDelegate>

@property (nonatomic, strong) UIImage *screenshotImage;
@property (nonatomic, strong) UIImagePickerController *imagePicker;
@property (nonatomic, weak) SUGridRootView *gridRootView;

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
    CGRect rc = CGRectMake(0.0f, 0.0f, sz.width, sz.height);
    SUGridRootView *view = [[SUGridRootView alloc]
                            initWithFrame:rc withImage:self.screenshotImage];
    view.contentMode = UIViewContentModeScaleAspectFit;
    self.view = view;
    self.gridRootView = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setToolbarActions];
    [self setupScrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    UIScrollView *scrollView = self.gridRootView.gridUnderLayerView.scrollView;

    scrollView.minimumZoomScale =
        scrollView.frame.size.width / self.gridRootView.gridUnderLayerView.containerView.frame.size.width;
    scrollView.maximumZoomScale = kSUMaximumZoomScale;
    [scrollView setZoomScale:scrollView.minimumZoomScale];
}

- (void)viewDidDisappear:(BOOL)animated
{
    UIScrollView *scrollView = self.gridRootView.gridUnderLayerView.scrollView;
    [scrollView setZoomScale:scrollView.minimumZoomScale];
}

#pragma mark - Private

- (void)setToolbarActions
{
    SUGridToolbar *toolbar = self.gridRootView.toolbar;

    [toolbar.closeButton addTarget:self
                            action:@selector(tapOnCloseButton)];
    [toolbar.showPickerButton addTarget:self
                                 action:@selector(showImagePicker)];
    [toolbar.showMarkingViewControllerButton addTarget:self
                                                action:@selector(showMarkingViewController)];
    [toolbar.slider addTarget:self
                       action:@selector(changeMockupImageAlpha:)
             forControlEvents:UIControlEventValueChanged];
}

- (void)setupScrollView
{
    self.gridRootView.gridUnderLayerView.scrollView.delegate = self;
    self.gridRootView.gridUnderLayerView.scrollView.contentSize =
        self.gridRootView.gridUnderLayerView.containerView.frame.size;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.gridRootView.gridUnderLayerView.containerView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self changeRulersPositions];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    [self centerContainerViewWithSize:scrollView.bounds.size];
    [self changeRulersPositions];
    [self activateSmallGridIfNecessary];
}

- (void)centerContainerViewWithSize:(CGSize)size
{
    UIView *containerView = self.gridRootView.gridUnderLayerView.containerView;
    CGRect rc = containerView.frame;
    containerView.frame = [self centeredFrameWithSize:size inRect:rc];
}

- (CGRect)centeredFrameWithSize:(CGSize)size inRect:(CGRect)rect
{
    rect.origin.x = rect.size.width < size.width ? (size.width - rect.size.width) / 2.0f : 0.0f;
    rect.origin.y = rect.size.height < size.height ? (size.height - rect.size.height) / 2.0f : 0.0f;
	
	return rect;
}

- (void)changeRulersPositions
{
    [self setRulersFrames];
    [self setRulersStartPoint];
}

- (void)setRulersFrames
{
    UIScrollView *scrollView = self.gridRootView.gridUnderLayerView.scrollView;
    SUGridRulerView *topRuler = self.gridRootView.topRuler;
    SUGridRulerView *sideRuler = self.gridRootView.sideRuler;
    topRuler.frame = CGRectMake(-scrollView.contentOffset.x, 0.0f,
                                scrollView.contentSize.width , kSURulerSize);
    sideRuler.frame = CGRectMake(0.0f, -scrollView.contentOffset.y,
                                 kSURulerSize, scrollView.contentSize.height);
}

- (void)setRulersStartPoint
{
    SUGridView *gridView = self.gridRootView.smallGridView;
    SUGridRulerView *topRuler = self.gridRootView.topRuler;
    SUGridRulerView *sideRuler = self.gridRootView.sideRuler;
    gridView.startPoint = CGPointMake((NSInteger)topRuler.frame.origin.x % (NSInteger)kSUSmallStepSize,
                                      (NSInteger)sideRuler.frame.origin.y % (NSInteger)kSUSmallStepSize);
    [gridView setNeedsDisplay];
}

- (void)activateSmallGridIfNecessary
{
    UIScrollView *scrollView = self.gridRootView.gridUnderLayerView.scrollView;
    self.gridRootView.smallGridView.hidden = scrollView.zoomScale == kSUMaximumZoomScale ? NO : YES;
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
        UIScrollView *scrollView = self.gridRootView.gridUnderLayerView.scrollView;
        [scrollView setZoomScale:scrollView.minimumZoomScale];
    }];
}

#pragma mark - Error marking view controller

- (void)showMarkingViewController
{
    [self.gridRootView.toolbar setHidden:YES];
    UIImage *imgage = [SUPixelHunterScreenshotUtil convertViewToImage:self.view];
    SUErrorMarkingViewController *errorMarkingViewController =
        [[SUErrorMarkingViewController alloc] initWithImage:imgage];

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
