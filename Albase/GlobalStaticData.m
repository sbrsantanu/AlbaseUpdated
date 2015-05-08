//
//  GlobalStaticData.m
//  Albase
//
//  Created by Mac on 24/11/14.
//  Copyright (c) 2014 sbrtech. All rights reserved.
//

#import "GlobalStaticData.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <CommonCrypto/CommonHMAC.h>
#import <objc/runtime.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <ifaddrs.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * String OCRErrorDomain
 */
NSString * const OCRErrorDomain                 = @"OCRErrorDomain";

/**
 * String AbbyScannerApplicationId
 * Live Data - ALBase Productivity App
 */
NSString * const AbbyScannerApplicationId       = @"PRA_CLOUDOCR";

/**
 * Live Data - fEsmI+dHga6isFwquJhsI/Fy
 * String AbbyScannerApplicationSecret
 */
NSString * const AbbyScannerApplicationSecret   = @"C1W9MMemCF4QyrP+DAX5LsZi";

/**
 * String AbbyScannerDataRetunType
 */
NSString * const AbbyScannerDataRetunTypeLang   = @"English";

/**
 * String AbbyScannerDataRetunType
 */
NSString * const AbbyScannerExportFormat        = @"txt";

/**
 * String AbbyScannerLoadingMessge
 */
NSString * const AbbyScannerLoadingMessge       = @"Loading image...";

/**
 * String AbbyScannerUploadingMessage
 */
NSString * const AbbyScannerUploadingMessage    = @"Uploading image...";

/**
 * String AbbyScannerProcessingMessage
 */
NSString * const AbbyScannerProcessingMessage   = @"Processing image...";

/**
 * String AbbyScannerDownloadingMessage
 */
NSString * const AbbyScannerDownloadingMessage  = @"Downloading result ...";

/**
 * String AbbyWaitingMessage
 */
NSString * const AbbyWaitingMessage             = @"Waiting for image processing complete...";


/**
 * **************************************************
 * **************** View Controller data ************
 * **************************************************
*/


/**
 * String AbbyWaitingMessage
 */
NSString * const ScanAccidentPolicyStepOneLarge = @"OCRAddAccidentPolicyStepOneViewController";

/**
 * String AbbyWaitingMessage
 */
NSString * const ScanAccidentPolicyStepOneSmall = @"OCRAddAccidentPolicyStepOneViewController4s";

/**
 * String AbbyWaitingMessage
 */
NSString * const ScanAccidentPolicyStepTwoLarge = @"OCRAddAccidentPolicyStepTwoViewController";

/**
 * String AbbyWaitingMessage
 */
NSString * const ScanAccidentPolicyStepTwoSmall = @"OCRAddAccidentPolicyStepTwoViewController4s";


@implementation GlobalStringData

+(NSString *)ScannerApplicationId { return AbbyScannerApplicationId; }

+(NSString *)ScannerApplicationSecret { return AbbyScannerApplicationSecret; }

+(NSString *)ScannerLoadingMessge { return AbbyScannerLoadingMessge; }

+(NSString *)ScannerUploadingMessage { return AbbyScannerUploadingMessage; }

+(NSString *)ScannerProcessingMessage { return AbbyScannerProcessingMessage; }

+(NSString *)ScannerDownloadingMessage { return AbbyScannerDownloadingMessage; }

+(NSString *)ScannerWaitingMessage { return AbbyWaitingMessage; }

+(NSString *)ScannerReturnedExportType { return AbbyScannerExportFormat; }

+(NSString *)ScannerLanguageType { return AbbyScannerDataRetunTypeLang; }

+(NSString *)ScannerParamType {
    
    NSString *ParamString = [NSString stringWithFormat:@"language=%@&exportFormat=%@",GlobalStringData.ScannerLanguageType,GlobalStringData.ScannerReturnedExportType];
    return ParamString;
}

@end

@implementation GlobalImageData : NSObject

@end

@implementation GlobalViewControllerData : NSObject

+(NSString *)ScanAccidentPolicyStepOne { return ((([[UIScreen mainScreen] bounds].size.height)>500))?ScanAccidentPolicyStepOneLarge:ScanAccidentPolicyStepOneSmall; }

+(NSString *)ScanAccidentPolicyStepTwo { return ((([[UIScreen mainScreen] bounds].size.height)>500))?ScanAccidentPolicyStepTwoLarge:ScanAccidentPolicyStepTwoSmall; }

@end

@implementation GlobalWebsericeData : NSObject

@end

@implementation GlobalViewPositionData : NSObject

@end

@implementation GlobalAnimationDurationData : NSObject

@end

@implementation GlobalClassMetodData

/**
 * Scanner Private Key
 */

+(NSString *)ScannerPrivateKey
{
    return @"";
}

/**
 * Scanner Secret Key
 */

+(NSString *)ScannerSecretKey
{
    return @"";
}

- (NSError *)checkError:(id)json {
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSArray *errors = json[@"errors"];
        
        if (errors.count > 0) {
            return [NSError errorWithDomain:OCRErrorDomain code:418 userInfo:@{NSLocalizedDescriptionKey: @"Multiple Errors", @"errors": errors}];
        }
    }
    return nil;
}

/**
 *  POSTBodyWithParams
 */

+(NSData *)POSTBodyWithParams:(NSDictionary *)params boundary:(NSString *)boundary {
    NSMutableData *body = [NSMutableData dataWithLength:0];
    
    for (NSString *key in params.allKeys) {
        id obj = params[key];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSData *data = nil;
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
        
        if ([obj isKindOfClass:[NSData class]]) {
            [body appendData:[@"Content-Type: application/octet-stream\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            data = (NSData *)obj;
        } else if ([obj isKindOfClass:[NSString class]]) {
            data = [[NSString stringWithFormat:@"%@",(NSString *)obj]dataUsingEncoding:NSUTF8StringEncoding];
        }
        
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:data];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return body;
}

/**
 *  remove Null Object
 */

+(id)removeNullWithObject:(id)rootObject {
    
    if ([rootObject isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *sanitizedDictionary = [NSMutableDictionary dictionaryWithDictionary:rootObject];
        [rootObject enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            id sanitized = [GlobalClassMetodData removeNullWithObject:obj];
            if (!sanitized) {
                [sanitizedDictionary setObject:@"" forKey:key];
            } else {
                [sanitizedDictionary setObject:sanitized forKey:key];
            }
        }];
        return [NSMutableDictionary dictionaryWithDictionary:sanitizedDictionary];
    }
    
    if ([rootObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *sanitizedArray = [NSMutableArray arrayWithArray:rootObject];
        [rootObject enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            id sanitized = [GlobalClassMetodData removeNullWithObject:obj];
            if (!sanitized) {
                [sanitizedArray replaceObjectAtIndex:[sanitizedArray indexOfObject:obj] withObject:@""];
            } else {
                [sanitizedArray replaceObjectAtIndex:[sanitizedArray indexOfObject:obj] withObject:sanitized];
            }
        }];
        return [NSMutableArray arrayWithArray:sanitizedArray];
    }
    
    if ([rootObject isKindOfClass:[NSNull class]]) {
        return (id)nil;
    } else {
        return rootObject;
    }
}

/**
 * Check InternetConnection
 */


+(BOOL)isConnectedToInternet {
    
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&zeroAddress);
    
    if (reachability) {
        SCNetworkReachabilityFlags flags;
        BOOL worked = SCNetworkReachabilityGetFlags(reachability, &flags);
        CFRelease(reachability);
        
        if (worked) {
            
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0) {
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
                return YES;
            }
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand) != 0) || (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0)) {
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0) {
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN) {
                return YES;
            }
        }
        
    }
    return NO;
}

/*
 Remove Null Objects
 */

/*
- (void)send_http_get_request:(NSString *)url_str vars:(NSDictionary *)vars {
    NSMutableString *url_str_with_vars = [NSMutableString stringWithString:url_str];
    if (vars != nil && vars.count > 0) {
        BOOL first = YES;
        for (NSString *key in vars) {
            [url_str_with_vars appendString:(first ? @"?" : @"&")];
            [url_str_with_vars appendString:[self urlencode:key]];
            [url_str_with_vars appendString:@"="];
            [url_str_with_vars appendString:[self urlencode:[vars valueForKey:key]]];
            first = NO;
        }
    }
    
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPShouldHandleCookies:NO];
    [request setValue:@"Agent name goes here" forHTTPHeaderField:@"User-Agent"];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)send_url_encoded_http_post_request:(NSString *)url_str vars:(NSDictionary *)vars {
    
    NSMutableString *vars_str = [NSMutableString new];
    if (vars != nil && vars.count > 0) {
        BOOL first = YES;
        for (NSString *key in vars) {
            if (!first) {
                [vars_str appendString:@"&"];
            }
            first = NO;
            
            [vars_str appendString:[self urlencode:key]];
            [vars_str appendString:@"="];
            [vars_str appendString:[self urlencode:[vars valueForKey:key]]];
        }
    }
    
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:NO];
    [request setValue:@"Agent name goes here" forHTTPHeaderField:@"User-Agent"];
    [request setHTTPBody:[vars_str dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (NSString *)urlencode:(NSString *)input {
    
    const char *input_c = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *result = [NSMutableString new];
    for (NSInteger i = 0, len = strlen(input_c); i < len; i++) {
        unsigned char c = input_c[i];
        if (
            (c >= '0' && c <= '9')
            || (c >= 'A' && c <= 'Z')
            || (c >= 'a' && c <= 'z')
            || c == '-' || c == '.' || c == '_' || c == '~'
            ) {
            [result appendFormat:@"%c", c];
        }
        else {
            [result appendFormat:@"%%%02X", c];
        }
    }
    return result;
}

- (IBAction)on_button_click:(id)sender {
    NSString *url_str = @"http://www.example.com/path/to/page.php";
    
    NSMutableDictionary *vars = [NSMutableDictionary new];
    [vars setObject:@"value1" forKey:@"key1"];
    [vars setObject:@"value2" forKey:@"key2"];
    
    [self send_http_get_request:url_str vars:vars];
}

- (NSString *)http_attribute_encode:(NSString *)input attribute_name:(NSString *)attribute_name {
    // result structure follows RFC 5987
    
    BOOL need_utf_encoding = NO;
    NSMutableString *result = [NSMutableString new];
    const char *input_c = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSInteger i;
    NSInteger len = strlen(input_c);
    unsigned char c;
    for (i = 0; i < len; i++) {
        c = input_c[i];
        if (c == '\\' || c == '/' || c == '\0' || c < ' ' || c > '~') {
            // ignore and request utf-8 version
            need_utf_encoding = YES;
        }
        else if (c == '"') {
            [result appendString:@"\\\""];
        }
        else {
            [result appendFormat:@"%c", c];
        }
    }
    
    if (result.length == 0) {
        need_utf_encoding = YES;
        [result appendString:@"file"];
    }
    
    if (!need_utf_encoding) {
        // return a simple version
        return [NSString stringWithFormat:@"%@=\"%@\"", attribute_name, result];
    }
    
    NSMutableString *result_utf8 = [NSMutableString new];
    for (i = 0; i < len; i++) {
        c = input_c[i];
        if (
            (c >= '0' && c <= '9')
            || (c >= 'A' && c <= 'Z')
            || (c >= 'a' && c <= 'z')
            ) {
            [result_utf8 appendFormat:@"%c", c];
        }
        else {
            [result_utf8 appendFormat:@"%%%02X", c];
        }
    }
    
    // return enhanced version with UTF-8 support
    return [NSString stringWithFormat:@"%@=\"%@\"; %@*=utf-8''%@", attribute_name, result, attribute_name, result_utf8];
}

- (void)send_multipart_http_post_request:(NSString *)url_str vars:(NSDictionary *)vars files:(NSArray *)files {
    NSString *str;
    NSMutableData *data = [NSMutableData new];
    
    NSMutableString *boundary = [NSMutableString new];
    [boundary appendString:@"__-----------------------"];
    [boundary appendFormat:@"%ld", arc4random() % 2147483648];
    [boundary appendFormat:@"%ld", (long) ([[NSDate new] timeIntervalSince1970] * 1000)];
    
    NSData *boundary_body = [boundary dataUsingEncoding:NSUTF8StringEncoding];
    NSData *boundary_delimiter = [@"--" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *new_line = [@"\r\n" dataUsingEncoding:NSUTF8StringEncoding];
    
    // add variables
    if (vars != nil) {
        for (NSString *key in vars) {
            // add boundary
            [data appendData:boundary_delimiter];
            [data appendData:boundary_body];
            [data appendData:new_line];
            
            // add header
            NSString *form_name = [self http_attribute_encode:key attribute_name:@"name"];
            str = [NSString stringWithFormat:@"Content-Disposition: form-data; %@", form_name];
            [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:new_line];
            
            str = @"Content-Type: text/plain";
            [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:new_line];
            
            // add header to body splitter
            [data appendData:new_line];
            
            // add variable content
            str = [vars valueForKey:key];
            [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:new_line];
        }
    }
    
    // add files
    if (files != nil) {
        for (NSInteger i = 0; i < files.count; i++) {
            NSMutableDictionary *file_parameters = [files objectAtIndex:i];
            
            NSString *variable_name = [file_parameters objectForKey:@"variable_name"];
            NSString *request_filename = [file_parameters objectForKey:@"request_filename"];
            NSString *mime_type = [file_parameters objectForKey:@"mime_type"];
            NSString *local_filename = [file_parameters objectForKey:@"local_filename"];
            
            // ensure necessary variables are available
            if (
                variable_name == nil || variable_name.length == 0
                || local_filename == nil || local_filename.length == 0
                || ![[NSFileManager defaultManager] fileExistsAtPath:local_filename]
                ) {
                // silent abort current file
                continue;
            }
            
            // ensure filename for the request
            if (request_filename == nil || request_filename.length == 0) {
                request_filename = [local_filename lastPathComponent];
                if (request_filename.length == 0) {
                    // silent abort current file
                    continue;
                }
            }
            
            // add boundary
            [data appendData:boundary_delimiter];
            [data appendData:boundary_body];
            [data appendData:new_line];
            
            // add header
            str = [NSString stringWithFormat:@"Content-Disposition: form-data; %@; %@",
                   [self http_attribute_encode:variable_name attribute_name:@"name"],
                   [self http_attribute_encode:request_filename attribute_name:@"filename"]
                   ];
            [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:new_line];
            
            if (mime_type != nil && mime_type.length > 0) {
                str = [NSString stringWithFormat:@"Content-Type: %@", mime_type];
                [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
                [data appendData:new_line];
            }
            
            str = @"Content-Transfer-Encoding: binary";
            [data appendData:[str dataUsingEncoding:NSUTF8StringEncoding]];
            [data appendData:new_line];
            
            // add header to body splitter
            [data appendData:new_line];
            
            // add file content
            [data appendData:[NSData dataWithContentsOfFile:local_filename]];
            [data appendData:new_line];
        }
    }
    
    // add end of body
    [data appendData:boundary_delimiter];
    [data appendData:boundary_body];
    [data appendData:boundary_delimiter];
    
    // join parts and send the request
    NSURL *url = [NSURL URLWithString:url_str];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPShouldHandleCookies:NO];
    [request setValue:@"Agent name goes here" forHTTPHeaderField:@"User-Agent"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (IBAction)on_button_click:(id)sender {
    NSString *url_str = @"http://www.example.com/path/to/page.php";
    
    // set up regular variables
    NSMutableDictionary *vars = [NSMutableDictionary new];
    [vars setObject:@"value1" forKey:@"key1"];
    [vars setObject:@"value2" forKey:@"key2"];
    
    // prepare variables for files
    NSMutableArray *files = [NSMutableArray new];
    NSMutableDictionary *file_parameters;
    
    // set up first file
    file_parameters = [NSMutableDictionary new];
    [file_parameters setObject:@"file1" forKey:@"variable_name"];
    [file_parameters setObject:@"/path/to/file1.png" forKey:@"local_filename"];
    [file_parameters setObject:@"file1.png" forKey:@"request_filename"];
    [file_parameters setObject:@"image/png" forKey:@"mime_type"];
    [files addObject:file_parameters];
    
    // set up second file
    file_parameters = [NSMutableDictionary new];
    [file_parameters setObject:@"file2" forKey:@"variable_name"];
    [file_parameters setObject:@"/path/to/file2.png" forKey:@"local_filename"];
    [file_parameters setObject:@"file2.png" forKey:@"request_filename"];
    [file_parameters setObject:@"image/png" forKey:@"mime_type"];
    [files addObject:file_parameters];
    
    // execute request
    [self send_multipart_http_post_request:url_str vars:vars files:files];
}
*/

@end

@implementation Remotenotification

-(void)RegisterDeviceForPushNotification
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)];
}
-(void)CancelAllNotification
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
-(void)ResetAllBadge
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

@end