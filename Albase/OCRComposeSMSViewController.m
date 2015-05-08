//
//  OCRComposeSMSViewController.m
//  Albase
//
//  Created by Mac on 27/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "OCRComposeSMSViewController.h"
#import "UIViewController+KNSemiModal.h"
#import <QuartzCore/QuartzCore.h>


@interface OCRComposeSMSViewController ()

@end

@implementation OCRComposeSMSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

@synthesize helpLabel;
@synthesize dismissButton;
@synthesize resizeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dismissButton.layer.cornerRadius  = 10.0f;
    dismissButton.layer.masksToBounds = YES;
    resizeButton.layer.cornerRadius   = 10.0f;
    resizeButton.layer.masksToBounds  = YES;
}

- (void)viewDidUnload {
    [self setHelpLabel:nil];
    [self setDismissButton:nil];
    [self setResizeButton:nil];
    [super viewDidUnload];
}

- (IBAction)dismissButtonDidTouch:(id)sender {
    
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
        [parent dismissSemiModalView];
    }
}

- (IBAction)resizeSemiModalView:(id)sender {
    UIViewController * parent = [self.view containingViewController];
    if ([parent respondsToSelector:@selector(resizeSemiView:)]) {
        [parent resizeSemiView:CGSizeMake(320, arc4random() % 280 + 180)];
    }
}

@end
