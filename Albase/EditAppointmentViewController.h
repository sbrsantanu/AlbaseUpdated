//
//  EditAppointmentViewController.h
//  Albase
//
//  Created by Mac on 06/02/15.
//  Copyright (c) 2015 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMDateSelectionViewController.h"
#import "RMPickerViewController.h"
#import "OCRInvitesViewController.h"
#import "OCRGlobalMethods.h"
#import "OCRDataObjectModel.h"

@interface EditAppointmentViewController : OCRGlobalMethods <RMDateSelectionViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITextViewDelegate,UITextFieldDelegate,OCRInvitesViewControllerDelegate>

@property (assign) OCRAppointmentDataObjectModel *EditableObjectCarrier;
@end
