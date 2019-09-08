//
//  UBCUser.h
//  Urban Climb
//
//  Created by Sean O'Connor on 7/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UBCUser : NSObject

- (instancetype _Nonnull)initWithBarcode:(nonnull NSString *)barcode;

@property (nonnull, readonly, copy) NSString *barcode;

@end
