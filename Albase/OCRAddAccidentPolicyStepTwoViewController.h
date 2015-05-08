//
//  OCRAddAccidentPolicyStepTwoViewController.h
//  Albase
//
//  Created by Mac on 27/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCRDataObjectModel.h"
#import "OCRGlobalMethods.h"

@interface OCRAddAccidentPolicyStepTwoViewController : OCRGlobalMethods 

@property (nonatomic,retain) OCRAccidentPolicydetails *DataModel;
@property (nonatomic,retain) EditableUserData *UserEditedData;
@end
