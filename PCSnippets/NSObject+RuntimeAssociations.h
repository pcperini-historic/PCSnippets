//
//  NSObject+RuntimeAssociations.h
//
//  Created by Patrick Perini on 3/23/12.
//  Copyright (c) 2012 Inspyre Technologies. MIT License.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NSObjectRuntimeAssociationPolicyAssign    = 1 << 0,
    NSObjectRuntimeAssociationPolicyRetain    = 1 << 1,
    NSObjectRuntimeAssociationPolicyCopy      = 1 << 2,
    NSObjectRuntimeAssociationPolicyNonatomic = 1 << 7, 
} NSObjectRuntimeAssociationPolicy;


@interface NSObject (RuntimeAssociations)

- (void)associateWithObject:(id)object forKey:(void *)key;
- (void)associateWithObject:(id)object forKey:(void *)key policy:(NSInteger)policy;
- (id)associatedObjectForKey:(void *)key;
- (void)disassociateWithObectForKey:(void*)key;
- (void)disassociateWithAllObjects;

@end

#define declareRuntimeAssociationKey(var) static void *varRuntimeAssociationKey
#define runtimeAssociationKey(var) varRuntimeAssociationKey