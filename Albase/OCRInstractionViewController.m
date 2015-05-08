//
//  OCRInstractionViewController.m
//  Albase
//
//  Created by Mac on 24/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

typedef enum {
    InstractionTypeNone,
    InstractionTypeNormal,
    InstractionTypeScan
} InstractionType;

typedef enum {
    ScanInstractionStepOne,
    ScanInstractionStepTwo,
    ScanInstractionStepThree,
    ScanInstractionStepFour,
    ScanInstractionStepFiveFirst,
    ScanInstractionStepFiveSecond,
    ScanInstractionStepSix,
    ScanInstractionStepSeven,
    ScanInstractionStepEight,
    ScanInstractionStepNine,
    ScanInstractionStepTen,
    ScanInstractionStepNone,
    ScanInstractionStepComplete
} ScanInstractionSteps;

#import "OCRInstractionViewController.h"
#import "UIColor+HexColor.h"
#import "AMPopTip.h"
#import "ImageViewController.h"
#import "OCRAppDelegate.h"

@interface OCRInstractionViewController ()<UIScrollViewDelegate>
{
    UIView *StartScanHelpMainBG;
    UIView *NextButtonView;
    UIView *CloseButtonView;
    UIButton *Nextbutton;
    UIButton *CloseButton;
    UITextView *MessageTextView;
    UIImageView *DataImageView;
}
@property (nonatomic, strong) AMPopTip *popTip;
@property (assign) InstractionType InstructionViewInsType;
@property (assign) ScanInstractionSteps ScanInstractionStep;
@property (nonatomic,retain) UIScrollView *DataScrollView;
@end

@implementation OCRInstractionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self=(IsIphone5)?[super initWithNibName:@"OCRInstractionViewController" bundle:nil]:[super initWithNibName:@"OCRInstractionViewController4s" bundle:nil];
        
        if ([[UIScreen mainScreen] bounds].size.height == 480) {
            self = [super initWithNibName:@"OCRInstractionViewController4s" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 568) {
            self = [super initWithNibName:@"OCRInstractionViewController" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 667) {
            self = [super initWithNibName:@"OCRInstractionViewController6" bundle:nil];
        } else if ([[UIScreen mainScreen] bounds].size.height == 736) {
            self = [super initWithNibName:@"OCRInstractionViewController6s" bundle:nil];
        }
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[self.navigationController navigationBar] setHidden:YES];
    
    OCRAppDelegate *maindelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (maindelegate.InsurenceScanType == ScanTypeLifePolicy) {
        NSLog(@"ScanTypeLifePolicy");
    } else {
        NSLog(@"ScanTypeAccidentPolicy");
    }
    
    StartScanHelpMainBG = [[UIView alloc] init];
    [StartScanHelpMainBG setFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.layer.frame.size.width, 100)];
    [StartScanHelpMainBG setBackgroundColor:[UIColor colorFromHex:0x1EBBFE]];
    [self.view addSubview:StartScanHelpMainBG];
    
    _InstructionViewInsType = InstractionTypeNone;
    _ScanInstractionStep = ScanInstractionStepNone;
    
    [[AMPopTip appearance] setFont:[UIFont fontWithName:@"Avenir-Medium" size:12]];
    
    self.popTip = [AMPopTip popTip];
    self.popTip.shouldDismissOnTap = YES;
    self.popTip.edgeMargin = 5;
    self.popTip.tapHandler = ^{
        NSLog(@"Tap!");
    };
    self.popTip.dismissHandler = ^{
        NSLog(@"Dismiss!");
    };
    self.popTip.popoverColor = [UIColor colorFromHex:0x575757];
    
    [UIView animateWithDuration:.5 delay:.5 options:UIViewAnimationOptionCurveEaseIn animations:^(void){
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.7;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromTop;
        [StartScanHelpMainBG.layer addAnimation:transition forKey:kCATransition];
        
        DataImageView = [[UIImageView alloc] init];
        if (IsIphone5) {
            [DataImageView setFrame:CGRectMake(54, 107, 211, 360)];
        } else {
            [DataImageView setFrame:CGRectMake(54, 82, 211, 295)];
        }
        
        [DataImageView setBackgroundColor:[UIColor clearColor]];
        [DataImageView setClipsToBounds:YES];
        [self.view addSubview:DataImageView];
        
        NextButtonView = [[UIView alloc] init];
        [NextButtonView setFrame:CGRectMake(221, 2, 100, 45)];
        [NextButtonView setBackgroundColor:[UIColor whiteColor]];
        [StartScanHelpMainBG addSubview:NextButtonView];
        
        CloseButtonView = [[UIView alloc] init];
        [CloseButtonView setFrame:CGRectMake(221, 52, 100, 45)];
        [CloseButtonView setBackgroundColor:[UIColor whiteColor]];
        [StartScanHelpMainBG addSubview:CloseButtonView];
        
        Nextbutton = [[UIButton alloc] init];
        [Nextbutton setFrame:CGRectMake(0, 0, 100, 45)];
        [Nextbutton setBackgroundColor:[UIColor clearColor]];
        [Nextbutton setTitleColor:[UIColor colorFromHex:0x1EBBFE] forState:UIControlStateNormal];
        [Nextbutton setTitle:@"START" forState:UIControlStateNormal];
        [Nextbutton addTarget:self action:@selector(NextbuttonButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [Nextbutton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [NextButtonView addSubview:Nextbutton];
        
        CloseButton = [[UIButton alloc] init];
        [CloseButton setFrame:CGRectMake(0, 0, 100, 45)];
        [CloseButton setBackgroundColor:[UIColor clearColor]];
        [CloseButton setTitleColor:[UIColor colorFromHex:0x1EBBFE] forState:UIControlStateNormal];
        [CloseButton setTitle:@"SKIP" forState:UIControlStateNormal];
        [CloseButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [CloseButton addTarget:self action:@selector(CloseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [CloseButtonView addSubview:CloseButton];
        
        MessageTextView = [[UITextView alloc] init];
        [MessageTextView setFrame:CGRectMake(5, 5, 210, 90)];
        [MessageTextView setBackgroundColor:[UIColor clearColor]];
        [MessageTextView setFont:[UIFont fontWithName:@"Helvetica" size:12.0f]];
        [MessageTextView setTextColor:[UIColor whiteColor]];
        [MessageTextView setTextAlignment:NSTextAlignmentLeft];
        [MessageTextView setUserInteractionEnabled:NO];
        [MessageTextView setEditable:NO];
        [MessageTextView setText:@"Please follow the instruction to scan, Proper scan process will give around 80% accurate data. Click START for demo."];
        [StartScanHelpMainBG addSubview:MessageTextView];
        
    } completion:^(BOOL finished){
        NSLog(@"i am complete");
    }];
}

-(IBAction)NextbuttonButtonClicked:(id)sender
{
    NSLog(@"NextbuttonButtonClicked clicked");
    
    [self.popTip hide];
    
    if (_ScanInstractionStep == ScanInstractionStepNone) {
        
        [UIView animateWithDuration:0.0 animations:^(void){
            DataImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 animations:^(void){
                [DataImageView setImage:[UIImage imageNamed:@"INS0001.png"]];
                DataImageView.alpha = 1.0;
                [MessageTextView setText:@"Click NEXT for next step"];
                self.popTip.popoverColor = [UIColor colorFromHex:0x575757];
            } completion:^(BOOL finished){
                if (IsIphone5) {
                    [self.popTip showText:@"Click for open navigation option" direction:AMPopTipDirectionDown maxWidth:200 inView:self.view fromFrame:CGRectMake(22, 107, 105, 30)];
                } else {
                    [self.popTip showText:@"Click for open navigation option" direction:AMPopTipDirectionDown maxWidth:200 inView:self.view fromFrame:CGRectMake(22, 77, 105, 30)];
                }
                _ScanInstractionStep = ScanInstractionStepTwo;
                [Nextbutton setTitle:@"NEXT" forState:UIControlStateNormal];
            }];
        }];
        
    } else if(_ScanInstractionStep == ScanInstractionStepTwo) {
        
        [UIView animateWithDuration:1.0 animations:^(void){
            DataImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 animations:^(void){
                [DataImageView setImage:[UIImage imageNamed:@"INS0002.png"]];
                DataImageView.alpha = 1.0;
                [MessageTextView setText:@"Click NEXT for next step"];
                self.popTip.popoverColor = [UIColor colorFromHex:0x1EBBFE];
            } completion:^(BOOL finished){
                if (IsIphone5) {
                    [self.popTip showText:@"Click Scan for Start Scanning" direction:AMPopTipDirectionDown maxWidth:200 inView:self.view fromFrame:CGRectMake(45, 350, 105, 30)];
                } else {
                    [self.popTip showText:@"Click Scan for Start Scanning" direction:AMPopTipDirectionDown maxWidth:200 inView:self.view fromFrame:CGRectMake(45, 270, 105, 30)];
                }
                _ScanInstractionStep = ScanInstractionStepThree;
                [Nextbutton setTitle:@"NEXT" forState:UIControlStateNormal];
            }];
        }];
    }
    else if(_ScanInstractionStep == ScanInstractionStepThree) {
        
        [UIView animateWithDuration:1.0 animations:^(void){
            DataImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 animations:^(void){
                [DataImageView setImage:[UIImage imageNamed:@"IMG_INS0003.png"]];
                DataImageView.alpha = 1.0;
                self.popTip.popoverColor = [UIColor colorFromHex:0x1EBBFE];
                [MessageTextView setText:@"Not to click USE IMAGE,it's may crash the app."];
            } completion:^(BOOL finished){
                if (IsIphone5) {
                    [self.popTip showText:@"Click to Add Image For Start Scan" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(45, 435, 105, 30)];
                } else {
                    [self.popTip showText:@"Click to Add Image For Start Scan" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(45, 350, 105, 30)];
                }
                _ScanInstractionStep = ScanInstractionStepFour;
                [Nextbutton setTitle:@"NEXT" forState:UIControlStateNormal];
            }];
        }];
    }
    else if(_ScanInstractionStep == ScanInstractionStepFour) {
        
        [UIView animateWithDuration:1.0 animations:^(void){
            DataImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 animations:^(void){
                [DataImageView setImage:[UIImage imageNamed:@"IMG_INS0004.png"]];
                DataImageView.alpha = 1.0;
                self.popTip.popoverColor = [UIColor colorFromHex:0x1EBBFE];
                [MessageTextView setText:@"Before Scan we need to capture image first with proper way"];
            } completion:^(BOOL finished){
                if (IsIphone5) {
                    [self.popTip showText:@"Click on Camera for Capture Form Image" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(106, 400, 105, 30)];
                } else{
                    [self.popTip showText:@"Click on Camera for Capture Form Image" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(106, 325, 105, 30)];
                }
                _ScanInstractionStep = ScanInstractionStepFiveFirst;
                [Nextbutton setTitle:@"NEXT" forState:UIControlStateNormal];
            }];
        }];
    }
    else if(_ScanInstractionStep == ScanInstractionStepFiveFirst) {
        
        [UIView animateWithDuration:1.0 animations:^(void){
            DataImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 animations:^(void){
                [DataImageView setImage:[UIImage imageNamed:@"IMG_INS0005.png"]];
                DataImageView.alpha = 1.0;
                [MessageTextView setText:@"Not to wary about the A4 page right and left age, Just place the Top And Buttom edge in proper location"];
                self.popTip.popoverColor = [UIColor colorFromHex:0x1EBBFE];
            } completion:^(BOOL finished){
                if (IsIphone5) {
                    [self.popTip showText:@"A4 Sheet Top line should be touch this line" direction:AMPopTipDirectionDown maxWidth:200 inView:self.view fromFrame:CGRectMake(106, 107, 105, 30)];
                } else {
                    [self.popTip showText:@"A4 Sheet Top line should be touch this line" direction:AMPopTipDirectionDown maxWidth:200 inView:self.view fromFrame:CGRectMake(106, 77, 105, 30)];
                }
                _ScanInstractionStep = ScanInstractionStepFiveSecond;
                [Nextbutton setTitle:@"NEXT" forState:UIControlStateNormal];
            }];
        }];
    }
    else if(_ScanInstractionStep == ScanInstractionStepFiveSecond) {
        
        [UIView animateWithDuration:1.0 animations:^(void){
            DataImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 animations:^(void){
                [DataImageView setImage:[UIImage imageNamed:@"IMG_INS0005.png"]];
                DataImageView.alpha = 1.0;
                [MessageTextView setText:@"Not to wary about the A4 page right and left age, Just place the Top And Buttom edge in proper location"];
                self.popTip.popoverColor = [UIColor colorFromHex:0x1EBBFE];
            } completion:^(BOOL finished){
                if (IsIphone5) {
                    [self.popTip showText:@"A4 Sheet bottom line should be touch this line" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(106, 400, 105, 30)];
                } else {
                    [self.popTip showText:@"A4 Sheet bottom line should be touch this line" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(106, 320, 105, 30)];
                }
                _ScanInstractionStep = ScanInstractionStepSix;
                [Nextbutton setTitle:@"NEXT" forState:UIControlStateNormal];
            }];
        }];
    }
    else if(_ScanInstractionStep == ScanInstractionStepSix) {
        
        [UIView animateWithDuration:1.0 animations:^(void){
            DataImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 animations:^(void){
                [DataImageView setImage:[UIImage imageNamed:@"IMG_INS0006.png"]];
                DataImageView.alpha = 1.0;
                [MessageTextView setText:@"Click NEXT for next step"];
                self.popTip.popoverColor = [UIColor colorFromHex:0x1EBBFE];
            } completion:^(BOOL finished){
                if (IsIphone5) {
                    [self.popTip showText:@"Click Button To Complete Image Capture" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(106, 420, 105, 30)];
                } else {
                    [self.popTip showText:@"Click Button To Complete Image Capture" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(106, 340, 105, 30)];
                }
                _ScanInstractionStep = ScanInstractionStepSeven;
                [Nextbutton setTitle:@"NEXT" forState:UIControlStateNormal];
            }];
        }];
    }
    else if(_ScanInstractionStep == ScanInstractionStepSeven) {
        
        [UIView animateWithDuration:1.0 animations:^(void){
            DataImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 animations:^(void){
                [DataImageView setImage:[UIImage imageNamed:@"IMG_INS0007.png"]];
                DataImageView.alpha = 1.0;
                [MessageTextView setText:@"Image captured, now go for the next step"];
                self.popTip.popoverColor = [UIColor colorFromHex:0x1EBBFE];
            } completion:^(BOOL finished){
                if (IsIphone5) {
                    [self.popTip showText:@"Click Use Photo For Next Step" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(170, 430, 105, 30)];
                } else {
                    [self.popTip showText:@"Click Use Photo For Next Step" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(170, 350, 105, 30)];
                }
                _ScanInstractionStep = ScanInstractionStepEight;
                [Nextbutton setTitle:@"NEXT" forState:UIControlStateNormal];
            }];
        }];
    }
    else if(_ScanInstractionStep == ScanInstractionStepEight) {
        
        [UIView animateWithDuration:1.0 animations:^(void){
            DataImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 animations:^(void){
                [DataImageView setImage:[UIImage imageNamed:@"IMG_INS0008.png"]];
                DataImageView.alpha = 1.0;
                [MessageTextView setText:@"No need to resize, just click on DONE"];
                self.popTip.popoverColor = [UIColor colorFromHex:0x1EBBFE];
            } completion:^(BOOL finished){
                if (IsIphone5) {
                    [self.popTip showText:@"Click On Done" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(106, 435, 105, 30)];
                } else {
                    [self.popTip showText:@"Click On Done" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(106, 350, 105, 30)];
                }
                _ScanInstractionStep = ScanInstractionStepNine;
                [Nextbutton setTitle:@"NEXT" forState:UIControlStateNormal];
            }];
        }];
    }
    else if(_ScanInstractionStep == ScanInstractionStepNine) {
        
        [UIView animateWithDuration:1.0 animations:^(void){
            DataImageView.alpha = 0.0;
        } completion:^(BOOL finished){
            [UIView animateWithDuration:1.0 animations:^(void){
                [DataImageView setImage:[UIImage imageNamed:@"IMG_INS0009.png"]];
                DataImageView.alpha = 1.0;
                [MessageTextView setText:@"Click Add Image for retake image, if image is not captured properly. Click DONE or SKIP complete demo"];
                self.popTip.popoverColor = [UIColor colorFromHex:0x1EBBFE];
            } completion:^(BOOL finished){
                if (IsIphone5) {
                    [self.popTip showText:@"Click Use Image To Start Scanning" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(160, 435, 105, 30)];
                } else {
                    [self.popTip showText:@"Click Use Image To Start Scanning" direction:AMPopTipDirectionUp maxWidth:200 inView:self.view fromFrame:CGRectMake(160, 350, 105, 30)];
                }
                _ScanInstractionStep = ScanInstractionStepComplete;
                [Nextbutton setTitle:@"DONE" forState:UIControlStateNormal];
            }];
        }];
    }
    else if(_ScanInstractionStep == ScanInstractionStepComplete) {
        OCRAppDelegate *maindelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
        ImageViewController *BirthdayView = [[ImageViewController alloc] init];
        [maindelegate SetUpTabbarControllerwithcenterView:BirthdayView];
    }
}

-(IBAction)CloseButtonClicked:(id)sender
{
    OCRAppDelegate *maindelegate = (OCRAppDelegate *)[[UIApplication sharedApplication] delegate];
    ImageViewController *BirthdayView = [[ImageViewController alloc] init];
    [maindelegate SetUpTabbarControllerwithcenterView:BirthdayView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
