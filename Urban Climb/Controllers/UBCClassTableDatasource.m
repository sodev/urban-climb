//
//  UBCClassTableDatasource.m
//  Urban Climb
//
//  Created by Sean O'Connor on 10/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCClassTableDatasource.h"

#import "UBCClassSection.h"

@interface UBCClassTableDatasource ()

@property (nonnull, strong) NSArray <UBCClassSection *> *sections;

@end

@implementation UBCClassTableDatasource

- (instancetype)initWithClasses:(nonnull NSArray <UBCClass *> *)classes
{
    self = [super init];
    if (self) {
        NSMutableArray *sections = [[NSMutableArray alloc] init];
        NSArray *dates = [classes valueForKey:@"date"];
        for (NSDate *date in dates) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", date];
            NSArray *classesForDate = [classes filteredArrayUsingPredicate:predicate];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU"];
            dateFormatter.dateFormat = @"E MMMM dd, yyyy";
            
            NSString *title = [dateFormatter stringFromDate:date];
            
            UBCClassSection *section = [[UBCClassSection alloc] initWithTitle:title classes:classesForDate];
            [sections addObject:section];
            
            _sections = sections;
        }
    }
    
    return self;
}

- (NSInteger)numberOfSections
{
    return self.sections.count;
}

- (NSString *)titleForSection:(NSInteger)sectionIndex
{
    UBCClassSection *section = self.sections[sectionIndex];
    
    return section.title;
}

- (NSInteger)numberOfRowsInSection:(NSInteger)sectionIndex
{
    UBCClassSection *section = self.sections[sectionIndex];
    
    return [section numberOfRows];
}

- (UBCClass *)classForIndexPath:(NSIndexPath *)indexPath
{
    UBCClassSection *section = self.sections[indexPath.section];
    
    return [section classForRow:indexPath.row];
}

@end
