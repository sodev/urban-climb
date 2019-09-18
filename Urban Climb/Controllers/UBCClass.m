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
    return [NSString stringWithFormat:@"%@ (%lul) with %@ at %@ on %@(%@)", self.name, (unsigned long)self.type, self.instructor, self.time, self.date, self.bookingUrlString];
}

- (NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU"];
    dateFormatter.dateFormat = @"E MMMM dd, yyyy";
    
    return [dateFormatter stringFromDate:self.date];
}

@end
