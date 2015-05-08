//
//  OCRAddContactFromOCRViewController.h
//  AlbaseNew
//
//  Created by Mac on 31/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {

    DataAditionStatusSimple,
    DataAditionStatusOcr
} PagedataaditionStatus;


#import "OCRDataObjectModel.h"
#import "OCRGlobalMethods.h"
#import "RMDateSelectionViewController.h"
#import "RMPickerViewController.h"

@interface OCRAddContactFromOCRViewController : OCRGlobalMethods <UIAlertViewDelegate,UITextFieldDelegate,RMDateSelectionViewControllerDelegate,RMPickerViewControllerDelegate,UIScrollViewDelegate>

@property (assign) PagedataaditionStatus dataadtionstatus;
@property (nonatomic,retain) OCRScanDataObjectModel *DataModel;
@property (nonatomic,retain) NSMutableDictionary *DataDictionary;

@end
