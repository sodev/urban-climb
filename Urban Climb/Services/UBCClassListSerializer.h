//
//  UBCClassListSerializer.h
//  Urban Climb
//
//  Created by Sean O'Connor on 13/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UBCClass.h"

@interface UBCClassListSerializer : NSObject

- (NSArray <UBCClass *> *)serializeClassData:(NSData *)classData;

@end
