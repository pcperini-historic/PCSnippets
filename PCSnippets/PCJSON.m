//
//  PCJSON.m
//
//  Created by Patrick Perini on 3/19/12.
//  Copyright (c) 2012 Inspyre Technologies. MIT License.
//

#import "PCJSON.h"
#import "Objectify.h"
#import <objc/runtime.h>

@implementation NSObject (JSON)

- (BOOL)isJSONSerializable
{
    return [self isKindOfClass: [NSDictionary class]] ||
           [self isKindOfClass: [NSArray class]]      ||
           [self isKindOfClass: [NSNumber class]]     ||
           [self isKindOfClass: [NSString class]]     ||
           [self isKindOfClass: [NSNull class]];
}

- (NSString *)JSONSerialize
{
    uint propertiesLength;
    objc_property_t     *properties = class_copyPropertyList([self class], &propertiesLength);
    NSMutableDictionary *JSONObject = [[NSMutableDictionary alloc] initWithCapacity: propertiesLength];
    
    for (int i = 0; i < propertiesLength; i++)
    {
        NSString *propertyName = [NSString stringWithCString: property_getName(properties[i])
                                                    encoding: NSUTF8StringEncoding];
        id propertyValue = objectify([self valueForKey: propertyName]);
        
        if ([propertyValue isJSONSerializable])
        {
            [JSONObject setObject: propertyValue
                           forKey: propertyName];
        }
    }
    
    free(properties);
    
    return [JSONObject JSONRepresentation];
}

- (NSString *)JSONRepresentation
{
    NSError  *JSONError = nil;
    NSString *JSON      = nil;
    
    if ([NSJSONSerialization isValidJSONObject: self])
    {
        JSON = [[NSString alloc] initWithData: [NSJSONSerialization dataWithJSONObject: self
                                                                               options: 0
                                                                                 error: &JSONError]
                                     encoding: NSUTF8StringEncoding];
    }
    
    if (JSON && !JSONError)
        return JSON;
    
    @throw JSONError;
    return nil;
}

- (NSString *)JSONDumpWithBlock:(id (^)())dumpBlock
{
    id JSONObject = dumpBlock();
    return [JSONObject JSONRepresentation];
}

- (NSString *)JSONDumpWithSelector:(SEL)dumpSelector
{
    id JSONObject = [self performSelector: dumpSelector];
    return [JSONObject JSONRepresentation];
}

@end

@implementation NSString (JSON)

- (id)JSONValue
{
    NSError *JSONError  = nil;
    id       JSONObject = nil;
    
    JSONObject = [NSJSONSerialization JSONObjectWithData: [self dataUsingEncoding: NSUTF8StringEncoding]
                                                 options: 0
                                                   error: &JSONError];
    
    if (JSONObject && !JSONError)
        return JSONObject;
    
    @throw JSONError;
    return nil;
}

@end