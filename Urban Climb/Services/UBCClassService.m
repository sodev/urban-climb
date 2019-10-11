//
//  UBCClassService.m
//  Urban Climb
//
//  Created by Sean O'Connor on 11/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCClassService.h"
#import "UBCUserService.h"

#import "UBCClassListSerializer.h"

#import <ASIHTTPRequest/ASIFormDataRequest.h>

@interface UBCClassService ()

@property (nonnull, nonatomic, strong) NSString *barcode;
    
@end

@implementation UBCClassService

- (instancetype)init
    {
        self = [super init];
        if (self) {
            UBCUserService *userService = [[UBCUserService alloc] init];
            UBCUser *currentUser = [userService retrieveStoredUser];
            _barcode = currentUser.barcode;
        }
        
        return self;
    }
    
- (void)fetchClassesFromServer:(void (^)(NSError * _Nullable error))completionHandler
{
    NSString *urlString = @"https://portal.urbanclimb.com.au/uc-admin/api/classes/website/class-data.ashx";

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *startDate = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary *jsonBodyDict = @{
                                   @"sunday" : @NO,
                                   @"monday": @NO,
                                   @"tuesday" : @NO,
                                   @"wednesday" : @NO,
                                   @"thursday" : @NO,
                                   @"friday" : @NO,
                                   @"saturday" : @NO,
                                   @"gyms" : @[@"8674e350-d340-4ab3-a462-5595061a6950"],
                                   @"startDate" : startDate,
                                   @"classType": @"yoga",
                                   };
    
    NSData *jsonBodyData = [NSJSONSerialization dataWithJSONObject:jsonBodyDict options:kNilOptions error:nil];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"POST";
    [request setURL:[NSURL URLWithString:urlString]];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonBodyData];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (error) {
                                                    completionHandler(error);
                                                } else {
                                                    UBCClassListSerializer *serializer = [[UBCClassListSerializer alloc] init];
                                                    NSError *serializingError;
                                                    [serializer serializeClassData:data error:&serializingError];
                                                    
                                                    completionHandler(serializingError);
                                                }
                                            }];
    [task resume];
}

- (void)bookClass:(UBCClass *)classObject completion:(void (^)(NSError * _Nullable error))completionHandler
{
    NSString *classId = classObject.idString;
    NSString *barcode = self.barcode ?: @"2731927";
    NSString *requestUrlString = [@"https://portal.urbanclimb.com.au/uc-services/member-class/login.aspx?classId={{class_id}}&url=https://portal.urbanclimb.com.au/uc-services/member-class/enrol.aspx?classId={{class_id}}" stringByReplacingOccurrencesOfString:@"{{class_id}}" withString:classId];
    
    NSDictionary *bodyDict = @{
        @"__EVENTTARGET" : @"ctl00%24cphBody%24btnSubmit",
        @"__EVENTARGUMENT" : @"",
        @"__VIEWSTATE" : @"%2FwEPDwUJNzQwNjUzMTIxD2QWAmYPDxYCHgtfUGFnZUJyYW5jaAUkODY3NGUzNTAtZDM0MC00YWIzLWE0NjItNTU5NTA2MWE2OTUwZBYCAgEPZBYCAgEPZBYIAgEPFgIeBFRleHQFBFlvZ2FkAgMPFgIfAQUgTW9uZGF5LCAxNCBPY3RvYmVyIDIwMTkgMDY6MDAgUE1kAgUPFgIfAQULQ29sbGluZ3dvb2RkAgcPDxYCHgdWaXNpYmxlaGQWAmYPFgIfAQUgTW9uZGF5LCAxNCBPY3RvYmVyIDIwMTkgMDY6MDAgUE1kZP5z9Fe%2FfuXfF4v8Chj4akMK9tyu9M0OoUdwGXmFiA1F",
        @"__VIEWSTATEGENERATOR" : @"F13564C9",
        @"__EVENTVALIDATION" : @"%2FwEdAAYdMfWDRNuEo96azk71E3eFj1h8Oz8w%2FlVuOhG12xvNE%2FgEIT9boQjD2miQ%2F22VIUUy01KFc5sYzDV3kTRwxMUIWHg7jg3JGlrn88Mp8JvAgm6nWYzGHEBU%2BYWpM%2BYr0v675rvlBGgShcleatuEJX7b9BxciN1FpwfsuYlmqPbmJg%3D%3D",
        @"ctl00%24cphBody%24txtBarcode" : barcode,
        @"ctl00%24cphBody%24txtName" : @"",
    };
    
    NSMutableString *bodyString = [[NSMutableString alloc] init];
    for (NSString *key in bodyDict.allKeys) {
        NSString *value = bodyDict[key];
        [bodyString appendFormat:@"%@=%@&", key, value];
    }
    
    NSData *bodyData = [NSData dataWithBytes:[bodyString UTF8String] length:[bodyString length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"POST";
    [request setURL:[NSURL URLWithString:requestUrlString]];
    [request setHTTPBody:bodyData];
    [request setValue:@"portal.urbanclimb.com.au" forHTTPHeaderField:@"authority"];
    [request setValue:@"max-age=0" forHTTPHeaderField:@"cache-control"];
    [request setValue:@"https://portal.urbanclimb.com.au" forHTTPHeaderField:@"origin"];
    [request setValue:@"1" forHTTPHeaderField:@"upgrade-insecure-requests"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                if (error ) {
                                                    completionHandler(error);
                                                } else {
                                                    NSString *dataString = [NSString stringWithUTF8String:data.bytes];
                                                    if ([dataString containsString:@"success"] == NO) {
                                                        completionHandler([NSError errorWithDomain:@"co.sodev.ucapp" code:1002 userInfo:NULL]);
                                                    } else {
                                                        completionHandler(nil);
                                                    }
                                                }
                                            }];
    [task resume];
}

@end
