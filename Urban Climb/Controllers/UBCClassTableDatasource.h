//
//  UBCClassTableDatasource.h
//  Urban Climb
//
//  Created by Sean O'Connor on 10/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UBCClass.h"

@interface UBCClassTableDatasource : NSObject

- (instancetype)initWithStartDate:(NSDate *)startDate;

- (NSInteger)numberOfSections;

- (NSString *)titleForSection:(NSInteger)sectionIndex;

- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex;

- (UBCClass *)classForIndexPath:(NSIndexPath *)indexPath;

@end
