//
//  SDVUserService.m
//  Urban Climb
//
//  Created by Sean O'Connor on 8/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCUserService.h"

static NSString * const UBC_STORED_BARCODEKEY = @"UBCStoredUserBarcodeKey";

@implementation UBCUserService

- (nullable UBCUser *)retrieveStoredUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *storedBarcode = [userDefaults objectForKey:UBC_STORED_BARCODEKEY];
    
    if (storedBarcode == nil) {
        return NULL;
    }
    
    return [[UBCUser alloc] initWithBarcode:storedBarcode];
}

- (void)storeUser:(UBCUser *)user
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:user.barcode forKey:UBC_STORED_BARCODEKEY];
    [userDefaults synchronize];
}

- (void)removeUser
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:UBC_STORED_BARCODEKEY];
    [userDefaults synchronize];
}

@end
