//
//  OCRNoteDetailsViewController.h
//  OCRScanner
//
//  Created by Mac on 23/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCRGlobalMethods.h"
#import "OCRAddEditNoteViewController.h"

@interface OCRNoteDetailsViewController : OCRGlobalMethods <OCRAddEditNoteViewControllerDelegate,UIAlertViewDelegate>
@property (nonatomic,retain) id noteobject;
@end
