//
//  PCContainerComprehension.h
//
//  Created by Patrick Perini on 3/29/12.
//  Copyright (c) 2012 Inspyre Technologies. MIT License.
//

#import <Foundation/Foundation.h>

@interface NSArray (Comprehension)
- (NSArray *)arrayByComprehendingWithBlock: (id (^)(id element))comprehensionBlock;
@end

@interface NSDictionary (Comprehension)
- (NSDictionary *)dictionaryByComprehendingWithBlock: (id (^)(NSString *key, id element))comprehensionBlock;
@end
