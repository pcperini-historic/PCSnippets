//
//  PCContainerComprehension.m
//
//  Created by Patrick Perini on 3/29/12.
//  Copyright (c) 2012 Inspyre Technologies. MIT License.
//

#import "PCContainerComprehension.h"

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
    return comprehensiveArray;
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
    return comprehensiveDictionary;
}

@end