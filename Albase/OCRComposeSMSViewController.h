//
//  OCRComposeSMSViewController.h
//  Albase
//
//  Created by Mac on 27/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OCRComposeSMSViewController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *helpLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *dismissButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *resizeButton;

- (IBAction)dismissButtonDidTouch:(id)sender;
- (IBAction)resizeSemiModalView:(id)sender;
@end
