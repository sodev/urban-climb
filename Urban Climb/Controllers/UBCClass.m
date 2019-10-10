//
//  UBCClass.m
//  Urban Climb
//
//  Created by Sean O'Connor on 10/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCClass.h"

@implementation UBCClass

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ (%lul) with %@ at %@ on %@ (%@)", self.name, (unsigned long)self.type, self.instructor, self.timeString, self.dateString, self.idString];
}

- (NSString *)idString
{
    return [self.bookingUrlString componentsSeparatedByString:@"classId="].lastObject;
}
    
- (NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"E MMMM dd, yyyy";
    
    return [dateFormatter stringFromDate:self.date];
}

- (NSString *)timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm a";
    
    return [dateFormatter stringFromDate:self.date];
}

@end
