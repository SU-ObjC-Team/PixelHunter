//
//  SUTextMarkView.m
//  PixelHunter
//
//  Created by Alex Saenko on 10/22/13.
//  Copyright (c) 2013 Sigma Ukraine. All rights reserved.
//

#import "SUTextMarkView.h"
#import "SUPixelHunterConstants.h"


@interface SUTextMarkView () <UITextViewDelegate>

@property (nonatomic, assign) CGSize keyboardSize;
@property (nonatomic, assign) BOOL isKeyboardShown;
@property (nonatomic, strong) NSString *placeholderText;

@end


@implementation SUTextMarkView

- (id)initWithView:(UIView *)view
{
    self = [super initWithView:view];
    if (self) {
        self.autoresizesSubviews = YES;
        
        self.commentTextView = [[UITextView alloc] init];
        self.placeholderText = NSLocalizedStringFromTable(@"TYPE_YOUR_TEXT_HERE",
                                                          @"PixelHunter", nil);
        self.commentTextView.text = self.placeholderText;
        self.commentTextView.textColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
        self.commentTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
        UIViewAutoresizingFlexibleHeight;
        self.commentTextView.layer.cornerRadius = kSUCornerRadius;
        [self.commentTextView setReturnKeyType: UIReturnKeyDone];
        self.commentTextView.delegate = self;
        self.commentTextView.userInteractionEnabled = NO;
        [self addSubview:self.commentTextView];
        
        [self insertSubview:self.removeButton aboveSubview:self.commentTextView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize bounds = self.bounds.size;
    
    self.commentTextView.frame = CGRectMake(0.0f, 0.0f, bounds.width, bounds.height);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:self.placeholderText]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = self.placeholderText;
        textView.textColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    }
    [textView resignFirstResponder];
}

#pragma mark - Properties

- (void)setIsDeletingAnimationOn:(BOOL)isDeletingAnimationOn
{
    [super setIsDeletingAnimationOn:isDeletingAnimationOn];
    
    if (isDeletingAnimationOn == NO) {
        [self.commentTextView endEditing:YES];
    }
}

@end
