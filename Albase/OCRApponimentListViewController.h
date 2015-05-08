//
//  OCRApponimentListViewController.h
//  OCRScanner
//
//  Created by Mac on 29/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

typedef enum {
    LastVisitedViewSidebar,
    LastVisitedViewCalender
} LastVisitedView;
#import <UIKit/UIKit.h>
#import "OCRGlobalMethods.h"

@interface OCRApponimentListViewController : OCRGlobalMethods
@property (nonatomic,retain) NSDate *SelectedDate;
@property (assign) LastVisitedView LastVisitedViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil LastVisitedView:(LastVisitedView )ParamLastVisitedView SelectedDate:(NSDate *)ParamSelectedDate;
@end
