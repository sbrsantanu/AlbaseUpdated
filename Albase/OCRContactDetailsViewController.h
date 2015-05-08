//
//  OCRContactDetailsViewController.h
//  OCRScanner
//
//  Created by Mac on 23/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

typedef enum {
    redirectedFromContactList,
    redirectedFromBirthdayList
} redirectedFrom;

#import <UIKit/UIKit.h>
#import "OCRDataObjectModel.h"
#import "OCRGlobalMethods.h"
@interface OCRContactDetailsViewController : OCRGlobalMethods
@property (assign) OCRUserDataObjectModel *UserDataObject;
@property (assign) redirectedFrom UserRedirectedFrom;
@property (nonatomic,retain) NSMutableDictionary *UserDataDictionary;
@end
