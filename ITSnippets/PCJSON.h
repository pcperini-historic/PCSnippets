//
//  PCJSON.h
//
//  Created by Patrick Perini on 3/19/12.
//  Copyright (c) 2012 Inspyre Technologies. MIT License.
//

#import <Foundation/Foundation.h>

@interface NSObject (JSON)

- (BOOL)isJSONSerializable;

- (NSString *)JSONSerialize;
- (NSString *)JSONRepresentation;
- (NSString *)JSONDumpWithBlock:    (id (^)())dumpBlock;
- (NSString *)JSONDumpWithSelector: (SEL)dumpSelector;

@end

@interface NSString (JSON)

- (id)JSONValue;

@end