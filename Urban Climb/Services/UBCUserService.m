//
//  SDVUserService.m
//  Urban Climb
//
//  Created by Sean O'Connor on 8/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCUserService.h"

@implementation UBCUserService

- (nullable UBCUser *)retrieveStoredUser
{
    RLMResults<UBCUser *> *users = [UBCUser objectsWhere:@"isCurrentUser == YES"];
    if (users.count == 1) {
        return users.firstObject;
    } else {
        return NULL;
    }
}

- (void)storeUser:(UBCUser *)user
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm transactionWithBlock:^{
        user.isCurrentUser = YES;
        [realm addObject:user];
    }];
}

- (void)removeUser:(UBCUser *)user
{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    user.isCurrentUser = NO;
    [realm commitWriteTransaction];
}

@end
