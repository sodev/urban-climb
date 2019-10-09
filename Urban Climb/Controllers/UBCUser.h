//
//  UBCUser.h
//  Urban Climb
//
//  Created by Sean O'Connor on 7/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Realm/Realm.h>

@interface UBCUser : RLMObject

- (instancetype _Nonnull)initWithBarcode:(nonnull NSString *)barcode;

@property NSString *barcode;
@property BOOL isCurrentUser;

@end
