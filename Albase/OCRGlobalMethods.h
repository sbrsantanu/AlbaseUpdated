//
//  OCRGlobalMethods.h
//  OCRScanner
//
//  Created by Mac on 18/09/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define  IsIphone5 (([[UIScreen mainScreen] bounds].size.height)>500)?true:false


#define ShowAlert(myTitle, myMessage) [[[UIAlertView alloc] initWithTitle:myTitle message:myMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show]

@interface OCRGlobalMethods : UIViewController
{
    UIImage *image;
    UIImageView *loadingView;
}
- (void)startSpin;
- (void)stopSpin;
@end
