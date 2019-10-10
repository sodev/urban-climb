//
//  UBCClass.h
//  Urban Climb
//
//  Created by Sean O'Connor on 10/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

typedef enum ClassType : NSUInteger {
    kYogaClass = 1,
    kClimbingClass,
    kFitnessClass
} ClassType;

@interface UBCClass : RLMObject

//@property ClassType type;
@property (nonnull, strong) NSString *type;
@property BOOL isFull;
@property (nonnull, strong) NSString *instructor;
@property (nonnull, strong) NSString *name;
@property (nonnull, strong) NSString *time;
@property (nonnull, strong) NSDate *date;
@property (nonnull, strong) NSString *bookingUrlString;

@property (nonnull, readonly) NSString *idString;
@property (nonnull, readonly) NSString *dateString;

@end

