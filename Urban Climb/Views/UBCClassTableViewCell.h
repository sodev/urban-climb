//
//  UBCClassTableViewCell.h
//  Urban Climb
//
//  Created by Sean O'Connor on 10/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UBCClass.h"

@interface UBCClassTableViewCell : UITableViewCell

- (void)configureWithClass:(UBCClass *)classObject;

@end
