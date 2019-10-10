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
        RLMResults <UBCClass *> *classes = [UBCClass objectsWhere:@"date >= %@", startDate];
        
        NSMutableArray *classesArray = [[NSMutableArray alloc] init];
        for (UBCClass *class in classes) {
            [classesArray addObject:class];
        }
        
        NSMutableArray *sections = [[NSMutableArray alloc] init];
        NSSet *uniqueDateStrings = [NSSet setWithArray:[classesArray valueForKey:@"dateString"]];
        
        NSArray *sortedDateStrings = [uniqueDateStrings.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
        
        for (NSString *dateString in sortedDateStrings) {
            NSArray <UBCClass *> *classesForDate = [classesArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"dateString == %@", dateString]];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU"];
            dateFormatter.dateFormat = @"E MMMM dd, yyyy";
            
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

@end
