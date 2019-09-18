//
//  UBCClassSection.m
//  Urban Climb
//
//  Created by Sean O'Connor on 16/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCClassSection.h"

@interface UBCClassSection ()

@property (nonnull, strong) NSString *title;
@property (nonnull, strong) NSArray <UBCClass *> *classes;

@end

@implementation UBCClassSection

- (instancetype _Nullable )initWithTitle:(NSString *_Nonnull)title classes:(NSArray <UBCClass *> *_Nonnull)classes
{
    self = [super init];
    if (self) {
        _title = title;
        _classes = classes;
    }
    
    return self;
}

- (NSInteger)numberOfRows
{
    return self.classes.count;
}

- (UBCClass *_Nonnull)classForRow:(NSInteger)row
{
    return self.classes[row];
}

@end
