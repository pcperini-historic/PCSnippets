//
//  PCContainerComprehension.m
//
//  Created by Patrick Perini on 3/29/12.
//  Copyright (c) 2012 Inspyre Technologies. MIT License.
//

#import "PCContainerExtensions.h"

@implementation NSArray (Comprehension)

- (NSArray *)arrayByComprehendingWithBlock:(id (^)(id))comprehensionBlock
{
    NSMutableArray *comprehensiveArray = [NSMutableArray array];
    for (id element in self)
    {
        id newElement = comprehensionBlock(element);
        if (newElement)
            [comprehensiveArray addObject: newElement];
    }
    return (NSArray *) [comprehensiveArray copy];
}

@end

@implementation NSDictionary (Comprehension)

- (NSDictionary *)dictionaryByComprehendingWithBlock:(id (^)(NSString *, id))comprehensionBlock
{
    NSMutableDictionary *comprehensiveDictionary = [NSMutableDictionary dictionary];
    for (NSString *key in self)
    {
        id newElement = comprehensionBlock(key, [self objectForKey: key]);
        if (newElement)
            [comprehensiveDictionary setObject: newElement
                                        forKey: key];
    }
    return (NSDictionary *) [comprehensiveDictionary copy];
}

@end

@implementation NSSet (Comprehension)

- (NSSet *)setByComprehendingWithBlock:(id (^)(id))comprehensionBlock
{
    NSMutableSet *comprehensiveSet = [NSMutableSet set];
    for (id element in self)
    {
        id newElement = comprehensionBlock(element);
        if (element)
            [comprehensiveSet addObject: newElement];
    }
    return (NSSet *) [comprehensiveSet copy];
}

@end

@implementation NSObject (ContainerExtensions)

- (BOOL)isIn:(id)container
{
    if ([container isKindOfClass: [NSDictionary class]])
    {
        return [[container allKeys] containsObject: self];
    }
    else if ([container respondsToSelector: @selector(containsObject:)])
    {
        return [container containsObject: self];
    }
    else
    {
        return NO;
    }
}

- (BOOL)areIn:(id)container
{
    BOOL elementsAreInContainer = NO;
    if ([self respondsToSelector: @selector(countByEnumeratingWithState:objects:count:)])
    {
        elementsAreInContainer = YES;
        for (id element in self)
        {
            elementsAreInContainer &= [element isIn: container];
        }
    }
    
    return elementsAreInContainer;
}

@end