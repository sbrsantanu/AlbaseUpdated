//
//  main.m
//  Albase
//
//  Created by Mac on 10/12/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCRAppDelegate.h"
#define allTrim( object ) [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet] ]

int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([OCRAppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"Exception is ---%@",[NSString stringWithFormat:@"%@",exception]);
        }
    }
}
