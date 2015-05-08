//
//  UIKeyboardListener.h
//  Albase
//
//  Created by Mac on 06/02/15.
//  Copyright (c) 2015 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UIKeyboardListener : NSObject
{
    BOOL _visible;
}
+ (UIKeyboardListener*) shared;
-(BOOL) isVisible;
@end
