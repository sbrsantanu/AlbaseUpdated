//
//  OCRInvitesViewController.h
//  Albase
//
//  Created by Mac on 29/10/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

@class OCRInvitesViewController;

#import <UIKit/UIKit.h>
#import "OCRGlobalMethods.h"

@protocol OCRInvitesViewControllerDelegate <NSObject>
@required
- (void)HandleDataObject:(OCRInvitesViewController *)myObj ObjectCarrier:(id)ObjectCarrier;
@end
@interface OCRInvitesViewController : OCRGlobalMethods
{
    __weak id <OCRInvitesViewControllerDelegate> _delegate;
}
@property (nonatomic, weak) id <OCRInvitesViewControllerDelegate> delegate;
@end

