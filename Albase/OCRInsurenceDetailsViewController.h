//
//  OCRInsurenceDetailsViewController.h
//  Albase
//
//  Created by Mac on 03/12/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCRGlobalMethods.h"

@interface OCRInsurenceDetailsViewController : OCRGlobalMethods <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) NSString *InsurenceId;
@end