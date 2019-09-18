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

- (NSArray <UBCClass *> *)serializeClassData:(NSData *)classData
{
    NSMutableArray <UBCClass *> *classes = [[NSMutableArray alloc] init];
    
    TFHpple *tutorialsParser = [TFHpple hppleWithHTMLData:classData];
    NSString *rowXpathQueryString = @"//tr";
    NSArray *rowNodes = [tutorialsParser searchWithXPathQuery:rowXpathQueryString];

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
            UBCClass *class = [self serializeClassElement:classElement withDateElement:activeDateElement];
            [classes addObject:class];
        }
    }
    
    return classes;
}

- (UBCClass *)serializeClassElement:(TFHppleElement *)classElement withDateElement:(TFHppleElement *)dateElement
{
    UBCClass *class = [self serializeClassElement:classElement];
    class.date = [self serializeDateElement:dateElement];
    
    return class;
}

- (UBCClass *)serializeClassElement:(TFHppleElement *)classElement
{
    // All the required data lives on the children of the first node
    NSArray *elements = classElement.firstChild.children; // grandChildren
    
    UBCClass *class = [[UBCClass alloc] init];
    
    if (elements.count == 9) {
        // if class is full there are 9 elements, 3 node relates to it being full
        class.time = [self contentFromElement:classElement forNodePath:@[@0, @0, @0]]; // [[elements[0] children][0] content]; // node path 0, 0
        class.instructor = [self contentFromElement:classElement forNodePath:@[@0, @8, @0]]; // [[elements[8] children][0] content];
        class.name = [self contentFromElement:classElement forNodePath:@[@0, @5, @1]]; // [[elements[5] children][1] content];
        class.isFull = @YES;
        
        NSString *classTypeString = [self contentFromElement:classElement forNodePath:@[@0, @5, @0, @0]]; // [[[elements[5] children][0] children][0] content];
        class.type = [self classTypeFromString:classTypeString];
    }
    else if (elements.count == 8) {
        class.time = [self contentFromElement:classElement forNodePath:@[@0, @0, @0]]; // [[elements[0] children][0] content]; // node path 0, 0
        class.instructor = [self contentFromElement:classElement forNodePath:@[@0, @7, @0]]; // class.instructor = [[elements[7] children][0] content];
        class.name = [self contentFromElement:classElement forNodePath:@[@0, @4, @1]]; // [[elements[4] children][1] content];
        class.isFull = @NO;
        
        NSString *classTypeString = [self contentFromElement:classElement forNodePath:@[@0, @4, @0, @0]]; //[[[elements[4] children][0] children][0] content];
        class.type = [self classTypeFromString:classTypeString];
        
        class.bookingUrlString = [self attributeFromElement:classElement forNodePath:@[@1, @0] withKey:@"href"];
    }
    
    return class;
}

- (NSDate *)serializeDateElement:(TFHppleElement *)dateElement
{
    NSString *dateString = [self contentFromElement:dateElement forNodePath:@[@0, @0]];
    NSString *trimmedDateString = [dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_AU"];
    dateFormatter.dateFormat = @"E MMMM dd, yyyy";
    
    return [dateFormatter dateFromString:trimmedDateString];;
}

- (NSString *)contentFromElement:(TFHppleElement *)element forNodePath:(NSArray *)nodeIndices
{
    TFHppleElement *node = [self nodeFromElement:element forNodePath:nodeIndices];
    
    return node.content;
}

- (NSString *)attributeFromElement:(TFHppleElement *)element forNodePath:(NSArray *)nodeIndices withKey:(NSString *)key
{
    TFHppleElement *node = [self nodeFromElement:element forNodePath:nodeIndices];
    NSDictionary *attributes = node.attributes;
    
    return attributes[key];
}

- (TFHppleElement *)nodeFromElement:(TFHppleElement *)element forNodePath:(NSArray *)nodeIndices
{
    TFHppleElement *currentNode = element;
    for (NSNumber *nodeIndex in nodeIndices) {
        NSArray *children = currentNode.children;
        // check nodeIndex is within range of array
        if (nodeIndex.integerValue < children.count ) {
            currentNode = children[nodeIndex.integerValue];
        }
    }
    
    return currentNode;
}

- (ClassType)classTypeFromString:(NSString *)classTypeString
{
    NSDictionary *typeMapping = @{
                                  @"Yoga": @(kYogaClass),
                                  @"Fitness": @(kFitnessClass),
                                  @"Climbing": @(kClimbingClass),
                                  };
    
    return [typeMapping[classTypeString] integerValue];
}

@end
