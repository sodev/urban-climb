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
    
- (void)fetchClassesFromServer:(void (^)(NSArray <UBCClass *> *classes, NSError * _Nullable error))completionHandler
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
    // watch out: error is nil here, but you never do that in production code. Do proper checks!
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"GET";
    
    // for alternative 1:
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
                                                
                                                UBCClassListSerializer *serializer = [[UBCClassListSerializer alloc] init];
                                                NSArray *classes = [serializer serializeClassData:data];
                                                
                                                completionHandler(classes, error);
                                            }];
    [task resume];
}

- (void)bookClass:(UBCClass *)classObject completion:(void (^)(NSError * _Nullable error))completionHandler
{
    NSString *classId = classObject.idString;
    NSString *barcode = self.barcode;
    NSString *url1 = @"https://portal.urbanclimb.com.au/uc-services/member-class/login.aspx?classId=";
    NSString *url2 = @"&url=https%3a%2f%2fportal.urbanclimb.com.au%2fuc-services%2fmember-class%2fenrol.aspx%3fclassId%";
    NSString *bodyStringFormat1 = @"__EVENTTARGET=ctl00%24cphBody%24btnSubmit&__EVENTARGUMENT=&__VIEWSTATE=%2FwEPDwUJNzQwNjUzMTIxD2QWAmYPDxYCHgtfUGFnZUJyYW5jaAUkODY3NGUzNTAtZDM0MC00YWIzLWE0NjItNTU5NTA2MWE2OTUwZBYCAgEPZBYCAgEPZBYIAgEPFgIeBFRleHQFBFlvZ2FkAgMPFgIfAQUgTW9uZGF5LCAxNCBPY3RvYmVyIDIwMTkgMDY6MDAgUE1kAgUPFgIfAQULQ29sbGluZ3dvb2RkAgcPDxYCHgdWaXNpYmxlaGQWAmYPFgIfAQUgTW9uZGF5LCAxNCBPY3RvYmVyIDIwMTkgMDY6MDAgUE1kZP5z9Fe%2FfuXfF4v8Chj4akMK9tyu9M0OoUdwGXmFiA1F&__VIEWSTATEGENERATOR=F13564C9&__EVENTVALIDATION=%2FwEdAAYdMfWDRNuEo96azk71E3eFj1h8Oz8w%2FlVuOhG12xvNE%2FgEIT9boQjD2miQ%2F22VIUUy01KFc5sYzDV3kTRwxMUIWHg7jg3JGlrn88Mp8JvAgm6nWYzGHEBU%2BYWpM%2BYr0v675rvlBGgShcleatuEJX7b9BxciN1FpwfsuYlmqPbmJg%3D%3D&ctl00%24cphBody%24txtBarcode=";
    NSString *bodyStringFormat2 = @"&ctl00%24cphBody%24txtName=";
    
    NSString *requestUrlString = [NSString stringWithFormat:@"%@%@%@%@", url1, classId, url2, classId];
    
    
    NSString *bodyString = [NSString stringWithFormat:@"%@%@%@", bodyStringFormat1, barcode, bodyStringFormat2];
        
    NSData *bodyData = [NSData dataWithBytes:[bodyString UTF8String] length:[bodyString length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"POST";
    
    // for alternative 1:
    [request setURL:[NSURL URLWithString:requestUrlString]];
    [request setHTTPBody:bodyData];
    [request setAllHTTPHeaderFields:@{@"authority": @"portal.urbanclimb.com.au", @"cache-control": @"max-age=0", @"origin": @"https://portal.urbanclimb.com.au", @"upgrade-insecure-requests": @"1", @"content-type": @"application/x-www-form-urlencoded"}];
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                          delegate:nil
                                                     delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData * _Nullable data,
                                                                NSURLResponse * _Nullable response,
                                                                NSError * _Nullable error) {
                                                
                                                completionHandler(error);
                                            }];
    [task resume];
}
    
    
//- (void)bookClass:(UBCClass *)classObject completion:(void (^)(NSError * _Nullable error))completionHandler
//{
//    // https://portal.urbanclimb.com.au/uc-services/member-class/login.aspx?classId=1f31212f-9671-44e9-bba4-5000e213d3b3&url='
//
//
////    NSString *urlString = [classObject.bookingUrlString stringByReplacingOccurrencesOfString:@"enrol" withString:@"login"];
////    NSString *urlString = @"https://portal.urbanclimb.com.au/uc-services/member-class/login.aspx?classId=f17619e2-31e9-4876-aea5-ff343c1ddb5e&url=";
//    NSString *urlString = @"https://portal.urbanclimb.com.au/uc-services/member-class/login.aspx?classId=b2f51f0b-941b-4c0b-b707-078e1498b5f1&url=https%3a%2f%2fportal.urbanclimb.com.au%2fuc-services%2fmember-class%2fenrol.aspx%3fclassId%3db2f51f0b-941b-4c0b-b707-078e1498b5f1";
//
////    NSString *bodyString = @"txtBarcode=2731927";
//
//    NSString *bodyString = @"__EVENTTARGET=ctl00%24cphBody%24btnSubmit&__EVENTARGUMENT=&__VIEWSTATE=%2FwEPDwUJNzQwNjUzMTIxD2QWAmYPDxYCHgtfUGFnZUJyYW5jaAUkODY3NGUzNTAtZDM0MC00YWIzLWE0NjItNTU5NTA2MWE2OTUwZBYCAgEPZBYCAgEPZBYIAgEPFgIeBFRleHQFBFlvZ2FkAgMPFgIfAQUgTW9uZGF5LCAxNCBPY3RvYmVyIDIwMTkgMDY6MDAgUE1kAgUPFgIfAQULQ29sbGluZ3dvb2RkAgcPDxYCHgdWaXNpYmxlaGQWAmYPFgIfAQUgTW9uZGF5LCAxNCBPY3RvYmVyIDIwMTkgMDY6MDAgUE1kZP5z9Fe%2FfuXfF4v8Chj4akMK9tyu9M0OoUdwGXmFiA1F&__VIEWSTATEGENERATOR=F13564C9&__EVENTVALIDATION=%2FwEdAAYdMfWDRNuEo96azk71E3eFj1h8Oz8w%2FlVuOhG12xvNE%2FgEIT9boQjD2miQ%2F22VIUUy01KFc5sYzDV3kTRwxMUIWHg7jg3JGlrn88Mp8JvAgm6nWYzGHEBU%2BYWpM%2BYr0v675rvlBGgShcleatuEJX7b9BxciN1FpwfsuYlmqPbmJg%3D%3D&ctl00%24cphBody%24txtBarcode=2731927&ctl00%24cphBody%24txtName=";
//
//    NSData *bodyData = [NSData dataWithBytes:[bodyString UTF8String] length:[bodyString length]];
//
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    request.HTTPMethod = @"POST";
//
//    // for alternative 1:
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPBody:bodyData];
//    [request setAllHTTPHeaderFields:@{@"authority": @"portal.urbanclimb.com.au", @"cache-control": @"max-age=0", @"origin": @"https://portal.urbanclimb.com.au", @"upgrade-insecure-requests": @"1", @"content-type": @"application/x-www-form-urlencoded"}];
//
//
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config
//                                                          delegate:nil
//                                                     delegateQueue:[NSOperationQueue mainQueue]];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
//                                            completionHandler:^(NSData * _Nullable data,
//                                                                NSURLResponse * _Nullable response,
//                                                                NSError * _Nullable error) {
//
//                                                NSString *dataString = [NSString stringWithUTF8String:data.bytes];
//                                                NSLog(@"%@", dataString);
//                                                NSLog(@"%@", error);
//                                            }];
//    [task resume];
//}


@end
