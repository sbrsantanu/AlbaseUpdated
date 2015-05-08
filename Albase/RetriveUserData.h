//
//  RetriveUserData.h
//  Albase
//
//  Created by Mac on 18/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RetriveUserData;

@protocol RetriveUserDataDelegate <NSObject>

@required

-(void)GetRetrivedUserDataWithError:(RetriveUserData *)UserData
                        Errordata:(NSError *)Error;
-(void)GetRetrivedUserDataWithSuccess:(RetriveUserData *)UserData
                        ObjectCarrier:(id)ObjectCarrier;

@end

@interface RetriveUserData : NSObject
{
    __weak id <RetriveUserDataDelegate> _delegate;
}
@property (nonatomic, weak) id <RetriveUserDataDelegate> delegate;

-(void)GetUserList;

@end
