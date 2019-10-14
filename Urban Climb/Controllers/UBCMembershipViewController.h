//
//  UBCMembershipViewController.h
//  Urban Climb
//
//  Created by Sean O'Connor on 10/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UBCUser.h"

@class UBCMembershipViewController;

@protocol UBCMembershipViewControllerDelegate <NSObject>

- (void)membershipRemovedByViewController:(UBCMembershipViewController *_Nonnull)viewController;

@end

@interface UBCMembershipViewController : UIViewController

@property (nonnull, strong) UBCUser *currentUser;

@property (weak) id <UBCMembershipViewControllerDelegate> _Nullable delegate;

@end
