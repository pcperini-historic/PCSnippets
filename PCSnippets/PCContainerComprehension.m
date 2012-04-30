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
        [comprehensiveArray addObject: comprehensionBlock(element)];
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
        [comprehensiveDictionary setObject: comprehensionBlock(key, [self objectForKey: key])
                                    forKey: key];
    }
    return comprehensiveDictionary;
}

@end