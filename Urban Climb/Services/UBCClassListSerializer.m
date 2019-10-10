//
//  UBCClassListSerializer.m
//  Urban Climb
//
//  Created by Sean O'Connor on 13/9/19.
//  Copyright © 2019 Sodev. All rights reserved.
//

#import "UBCClassListSerializer.h"

#import "TFHpple.h"

@implementation UBCClassListSerializer

- (void)serializeClassData:(NSData *)classData error:(NSError **)error
{
    TFHpple *parser = [TFHpple hppleWithHTMLData:classData];
    NSString *rowXpathQueryString = @"//tr";
    NSArray *rowNodes = [parser searchWithXPathQuery:rowXpathQueryString];

    // classes are grouped by date
    // we need to keep a record of the active date
    // to set it on the related classes
    TFHppleElement *activeDateElement;
    
    for (TFHppleElement *rowElement in rowNodes) {
        
        // date element has 4 children nodes
        if (rowElement.children.count == 4) {
            activeDateElement = rowElement;
        }
        // class element has 5 children nodes
        else if (rowElement.children.count == 5) {
            TFHppleElement *classElement = rowElement;
            [self serializeClassElement:classElement withDateElement:activeDateElement error:error];
        }
    }
    
    NSMutableArray <UBCClass *> *classArray = [[NSMutableArray alloc] init];
    RLMResults<UBCClass *> *classes = [UBCClass allObjects];
    for (UBCClass *class in classes) {
        [classArray addObject:class];
    }
}

- (void)serializeClassElement:(TFHppleElement *)classElement withDateElement:(TFHppleElement *)dateElement error:(NSError **)error
{
    NSDate *date = [self serializeDateFromDateElement:dateElement classElement:classElement error:error];
    // get the gym -- TODO, for now we know that we are only getting classes for collingwood
    
    // we will use the date and time (and TODO gym) as unique identifiers for a class as bookm classes don't provide a guid
    RLMResults<UBCClass *> *classes = [UBCClass objectsWhere:@"date == %@", date];
    
    UBCClass *class = [[UBCClass alloc] init];
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    if (classes.count == 0) {
        class.date = date;
        class.isBooked = NO;
        [realm transactionWithBlock:^{
            [realm addObject:class];
        }];
    } else {
        class = classes.firstObject;
    }
    
    [realm beginWriteTransaction];
    [self serializeClass:class withClassElement:classElement error:error];
    [realm commitWriteTransaction];
}

- (UBCClass *)serializeClass:(UBCClass *)class withClassElement:(TFHppleElement *)classElement error:(NSError **)error
{
    // All the required data lives on the children of the first node
    NSArray *elements = classElement.firstChild.children; // grandChildren
    if (elements.count == 9) {
        // if class is full there are 9 elements, 3 node relates to it being full
        class.instructor = [self contentFromElement:classElement forNodePath:@[@0, @8, @0] error:error]; // [[elements[8] children][0] content];
        class.name = [self contentFromElement:classElement forNodePath:@[@0, @5, @1] error:error]; // [[elements[5] children][1] content];
        class.isFull = @YES;
        class.type = [self contentFromElement:classElement forNodePath:@[@0, @5, @0, @0] error:error]; // [[[elements[5] children][0] children][0] content];
    }
    else if (elements.count == 8) {
        class.instructor = [self contentFromElement:classElement forNodePath:@[@0, @7, @0] error:error]; // class.instructor = [[elements[7] children][0] content];
        class.name = [self contentFromElement:classElement forNodePath:@[@0, @4, @1] error:error]; // [[elements[4] children][1] content];
        class.isFull = @NO;
        class.type = [self contentFromElement:classElement forNodePath:@[@0, @4, @0, @0] error:error]; //[[[elements[4] children][0] children][0] content];
        class.bookingUrlString = [self attributeFromElement:classElement forNodePath:@[@1, @0] withKey:@"href" error:error];
    }
    
    return class;
}

- (NSDate *)serializeDateFromDateElement:(TFHppleElement *)dateElement classElement:(TFHppleElement *)classElement error:(NSError **)error
{
    NSString *dateString = [self contentFromElement:dateElement forNodePath:@[@0, @0] error:error];
    dateString = [dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *timeString = [self contentFromElement:classElement forNodePath:@[@0, @0, @0] error:error];
    timeString = [timeString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *timedateString = [NSString stringWithFormat:@"%@, %@", dateString, timeString];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"E MMMM dd, yyyy, hh:mm a";
    NSDate *date = [dateFormatter dateFromString:timedateString];
    
    return date;
}

- (NSString *)contentFromElement:(TFHppleElement *)element forNodePath:(NSArray *)nodeIndices error:(NSError **)error
{
    TFHppleElement *node = [self nodeFromElement:element forNodePath:nodeIndices error:error];
    
    return node.content;
}

- (NSString *)attributeFromElement:(TFHppleElement *)element forNodePath:(NSArray *)nodeIndices withKey:(NSString *)key error:(NSError **)error
{
    TFHppleElement *node = [self nodeFromElement:element forNodePath:nodeIndices error:error];
    NSDictionary *attributes = node.attributes;
    
    return attributes[key];
}

- (TFHppleElement *)nodeFromElement:(TFHppleElement *)element forNodePath:(NSArray *)nodeIndices error:(NSError **)error
{
    TFHppleElement *currentNode = element;
    for (NSNumber *nodeIndex in nodeIndices) {
        NSArray *children = currentNode.children;
        // check nodeIndex is within range of array
        if (nodeIndex.integerValue < children.count ) {
            currentNode = children[nodeIndex.integerValue];
        } else {
            *error = [NSError errorWithDomain:@"co.sodev.ucapp" code:1001 userInfo:NULL];
        }
    }
    
    return currentNode;
}

@end
