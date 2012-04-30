//
//  NSObject+RuntimeAssociations.m
//
//  Created by Patrick Perini on 3/23/12.
//  Copyright (c) 2012 Inspyre Technologies. MIT License.
//

#import "NSObject+RuntimeAssociations.h"
#import <objc/runtime.h>

@implementation NSObject (RuntimeAssociations)

- (void)associateWithObject:(id)object forKey:(void *)key
{
    [self associateWithObject: object
                       forKey: key
                       policy: NSObjectRuntimeAssociationPolicyRetain];
}

- (void)associateWithObject:(id)object forKey:(void *)key policy:(NSInteger)policy
{
    objc_AssociationPolicy objc_policy;
    
    switch (policy)
    {
        case NSObjectRuntimeAssociationPolicyAssign:
        {
            objc_policy = OBJC_ASSOCIATION_ASSIGN;
            break;
        }
            
        case NSObjectRuntimeAssociationPolicyRetain:
        {
            objc_policy = OBJC_ASSOCIATION_RETAIN;
            break;
        }
            
        case NSObjectRuntimeAssociationPolicyCopy:
        {
            objc_policy = OBJC_ASSOCIATION_COPY;
            break;
        }
            
        case NSObjectRuntimeAssociationPolicyNonatomic|NSObjectRuntimeAssociationPolicyRetain:
        {
            objc_policy = OBJC_ASSOCIATION_RETAIN_NONATOMIC;
            break;
        }
            
        case NSObjectRuntimeAssociationPolicyNonatomic|NSObjectRuntimeAssociationPolicyCopy:
        {
            objc_policy = OBJC_ASSOCIATION_COPY_NONATOMIC;
            break;
        }
            
        default:
        {
            objc_policy = OBJC_ASSOCIATION_RETAIN;
            break;
        }
    }
    
    objc_setAssociatedObject(self,
                             key,
                             object,
                             objc_policy);
}

- (id)associatedObjectForKey:(void *)key
{
    return objc_getAssociatedObject(self,
                                    key);
}

- (void)disassociateWithObectForKey:(void *)key
{
    objc_setAssociatedObject(self,
                             key,
                             nil,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (void)disassociateWithAllObjects
{
    objc_removeAssociatedObjects(self);
}

@end
