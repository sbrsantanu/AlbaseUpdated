//
//  OCRAddInsuranceViewController.h
//  AlbaseNew
//
//  Created by Mac on 03/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCRDataObjectModel.h"
#import "OCRGlobalMethods.h"
#import "RMDateSelectionViewController.h"
#import "RMPickerViewController.h"

@interface OCRAddInsuranceViewController : OCRGlobalMethods <UIAlertViewDelegate,UITextFieldDelegate,RMDateSelectionViewControllerDelegate,RMPickerViewControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,retain) OCRScanDataObjectModel *DataModel;
@property (nonatomic,retain) EditableUserData *UserEditedData;

@end
