//
//  OCRAddAppointmentViewController.h
//  Albase
//
//  Created by Mac on 27/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"
#import "RMPickerViewController.h"
#import "OCRInvitesViewController.h"
#import "OCRGlobalMethods.h"
typedef enum {
    UserObjectModelNone,
    UserObjectModelWithData
} UserObjectModelStatus;

@interface OCRAddAppointmentViewController : OCRGlobalMethods<RMDateSelectionViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate,UITextFieldDelegate,OCRInvitesViewControllerDelegate>

@property (nonatomic,retain) id ContactObject;
@property (assign) UserObjectModelStatus ObjectCarrierMode;
@end
