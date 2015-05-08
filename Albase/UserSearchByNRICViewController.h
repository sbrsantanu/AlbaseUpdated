//
//  UserSearchByNRICViewController.h
//  Albase
//
//  Created by Mac on 25/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCRGlobalMethods.h"

@class UserSearchByNRICViewController;

@protocol UserSearchByNRICViewControllerDelegate <NSObject>

@required

- (void)HandleDataObject:(UserSearchByNRICViewController *)myObj ObjectCarrier:(id)ObjectCarrier WithUserId:(NSString *)UserId;

@end

@interface UserSearchByNRICViewController : OCRGlobalMethods
{
    __weak id <UserSearchByNRICViewControllerDelegate> _delegate;
}
@property (nonatomic,weak) id<UserSearchByNRICViewControllerDelegate> delegate;
@end
