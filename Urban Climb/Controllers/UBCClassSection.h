//
//  UBCClassSection.h
//  Urban Climb
//
//  Created by Sean O'Connor on 16/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UBCClass.h"

@interface UBCClassSection : NSObject

- (instancetype _Nullable )initWithTitle:(NSString *_Nonnull)title classes:(RLMResults <UBCClass *> *_Nonnull)classes;

- (NSInteger)numberOfRows;

- (UBCClass *_Nonnull)classForRow:(NSInteger)row;

@property (nonnull, readonly) NSString *title;

@end
