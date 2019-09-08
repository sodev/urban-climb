//
//  UBCUser.m
//  Urban Climb
//
//  Created by Sean O'Connor on 7/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCUser.h"

@implementation UBCUser

- (instancetype)initWithBarcode:(nonnull NSString *)barcode
{
    self = [super init];
    if (self) {
        _barcode = barcode;
    }
    
    return self;
}

@end
