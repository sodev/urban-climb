//
//  UBCClassService.m
//  Urban Climb
//
//  Created by Sean O'Connor on 11/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCClassService.h"

#import "UBCClassListSerializer.h"

#import <ASIHTTPRequest/ASIFormDataRequest.h>

@implementation UBCClassService

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
    // https://portal.urbanclimb.com.au/uc-services/member-class/login.aspx?classId=1f31212f-9671-44e9-bba4-5000e213d3b3&url='
    
    
//    NSString *urlString = [classObject.bookingUrlString stringByReplacingOccurrencesOfString:@"enrol" withString:@"login"];
    NSString *urlString = @"https://portal.urbanclimb.com.au/uc-services/member-class/login.aspx?classId=f17619e2-31e9-4876-aea5-ff343c1ddb5e&url=";
    
    NSString *bodyString = @"barcode=2731927";
    NSData *bodyData = [NSData dataWithBytes:[bodyString UTF8String] length:[bodyString length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    request.HTTPMethod = @"POST";
    
    // for alternative 1:
    [request setURL:[NSURL URLWithString:urlString]];
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
                                                
                                                NSString *dataString = [NSString stringWithUTF8String:data.bytes];
                                                NSLog(@"%@", dataString);
                                                NSLog(@"%@", error);
                                            }];
    [task resume];
}


@end
