//
//  UIKeyboardListener.m
//  Albase
//
//  Created by Mac on 06/02/15.
//  Copyright (c) 2015 sbrtech. All rights reserved.
//

#import "UIKeyboardListener.h"

#define UIKeyboardDidShowNotification @"UIKeyboardDidShowNotification"
#define UIKeyboardDidHideNotification @"UIKeyboardDidHideNotification"

@implementation UIKeyboardListener

+ (UIKeyboardListener*) shared {
    static UIKeyboardListener *sListener;
    if ( nil == sListener ) sListener = [[UIKeyboardListener alloc] init];
    return sListener;
}
-(id) init {
    self = [super init];
    if ( self ) {
        NSNotificationCenter	*center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(noticeShowKeyboard:) name:UIKeyboardDidShowNotification object:nil];
        [center addObserver:self selector:@selector(noticeHideKeyboard:) name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}
-(void) noticeShowKeyboard:(NSNotification *)inNotification {
    _visible = true;
}
-(void) noticeHideKeyboard:(NSNotification *)inNotification {
    _visible = false;
}
-(BOOL) isVisible {
    return _visible;
}
@end
