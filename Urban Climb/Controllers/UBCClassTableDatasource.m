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

- (instancetype)initWithStartDate:(NSDate *)startDate
{
    self = [super init];
    if (self) {
        RLMResults <UBCClass *> *classes = [UBCClass objectsWhere:@"datetime >= %@", startDate];
        
        NSMutableArray *sections = [[NSMutableArray alloc] init];
        NSSet *uniqueDates = [NSSet setWithArray:[classes valueForKey:@"date"]];
        
        NSArray *sortedDates = [uniqueDates.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
        
        for (NSDate *date in sortedDates) {
            RLMResults <UBCClass *> *classesForDate = [classes objectsWhere:@"date == %@", date];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU"];
            dateFormatter.dateFormat = @"E MMMM dd, yyyy";
            
            NSString *dateString = [dateFormatter stringFromDate:date];
            
            UBCClassSection *section = [[UBCClassSection alloc] initWithTitle:dateString classes:classesForDate];
            [sections addObject:section];
        }
        
        _sections = sections;
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

- (BOOL)canSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UBCClass *class = [self classForIndexPath:indexPath];
    
    return class.isBooked == NO && class.isFull == NO;
}

@end
