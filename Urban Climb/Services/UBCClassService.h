//
//  UBCClassService.h
//  Urban Climb
//
//  Created by Sean O'Connor on 11/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UBCClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface UBCClassService : NSObject

- (void)fetchClassesFromServer:(void (^)(NSArray <UBCClass *> *classes, NSError * _Nullable error))completionHandler;

- (void)bookClass:(UBCClass *)classObject completion:(void (^)(NSError * _Nullable error))completionHandler;

@end

NS_ASSUME_NONNULL_END
