//
//  GlobalStaticData.h
//  Albase
//
//  Created by Mac on 24/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalStringData : NSObject

/**
 * Return ScannerApplicationId
 */
+(NSString *)ScannerApplicationId;

/**
 * Return ScannerApplicationSecret
 */
+(NSString *)ScannerApplicationSecret;

/**
 * Return ScannerLoadingMessge
 */
+(NSString *)ScannerLoadingMessge;

/**
 * Return ScannerUploadingMessage
 */
+(NSString *)ScannerUploadingMessage;

/**
 * Return ScannerProcessingMessage
 */
+(NSString *)ScannerProcessingMessage;

/**
 * Return ScannerDownloadingMessage
 */
+(NSString *)ScannerDownloadingMessage;

/**
 * Return ScannerWaitingMessage
 */
+(NSString *)ScannerWaitingMessage;

/**
 * Return Scanner Export type ( txt or xml )
 */
+(NSString *)ScannerReturnedExportType;

/**
 * Return Scanner language type, English
 */
+(NSString *)ScannerLanguageType;

/**
 * Return Scanner param type
 */
+(NSString *)ScannerParamType;

@end

@interface GlobalImageData : NSObject

@end

@interface GlobalViewControllerData : NSObject

/**
 * Return Scan Accident Policy Step One
 * User Normal Data save
 */
+(NSString *)ScanAccidentPolicyStepOne;


/**
 * Return Scan Accident Policy Step Two
 * User Accident policy Data save
 */
+(NSString *)ScanAccidentPolicyStepTwo;

@end

@interface GlobalWebsericeData : NSObject

@end

@interface GlobalViewPositionData : NSObject

@end

@interface GlobalAnimationDurationData : NSObject

@end

@interface GlobalClassMetodData : NSObject

/**
 * Scanner Private Key
 */

+(NSString *)ScannerPrivateKey;

/**
 * Scanner Secret Key
 */

+(NSString *)ScannerSecretKey;

/**
 * Check InternetConnection
 */

+(BOOL)isConnectedToInternet;

/**
 *  remove Null Object
 */

+(id)removeNullWithObject:(id)rootObject;

/**
 *  POSTBodyWithParams
 */

+(NSData *)POSTBodyWithParams:(NSDictionary *)params boundary:(NSString *)boundary;

@end

@interface GlobalObjectMetodData : NSObject

@end

@interface Remotenotification : NSObject

-(void)RegisterDeviceForPushNotification;
-(void)CancelAllNotification;
-(void)ResetAllBadge;

@end