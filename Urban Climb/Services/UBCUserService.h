//
//  SDVUserService.h
//  Urban Climb
//
//  Created by Sean O'Connor on 8/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBCUser.h"

@interface UBCUserService : NSObject

- (nullable UBCUser *)retrieveStoredUser;

- (void)storeUser:(UBCUser *)user;

- (void)removeUser;

@end
