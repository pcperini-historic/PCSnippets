//
//  AppDelegate.m
//  ITSnippets
//
//  Created by Patrick Perini on 3/29/12.
//  Copyright (c) 2012 Inspyre Technologies. MIT License.
//

#import "AppDelegate.h"
#import "Objectify.h"
#import "PCJSON.h"
#import "NSObject+RuntimeAssociations.h"
#import "PCContainerExtensions.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize stringProperty;
@synthesize numberProperty;

declareRuntimeAssociationKey(associatedString);
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Objectify Examples
    int intPrim = 5;
    NSNumber *intObj = $(intPrim);
    NSLog(@"%d, %@", intPrim, intObj);
    
    BOOL boolPrim = YES;
    NSNumber *boolObj = $(boolPrim);
    NSLog(@"%d, %@", boolPrim, boolObj);
    
    stringProperty = $("hello world");
    NSLog(@"hello world, %@", stringProperty);
    
    NSDictionary *dictObj = [NSDictionary dictionaryWithObjectsAndKeys:
        $(3.14159),                                   @"pi",
        $(@selector(applicationDidFinishLaunching:)), @"delegate-method",
        $(nil),                                       @"valid_null_object",
        nil
    ];
    NSLog(@"%@", dictObj);
    
    // PCJSON Examples
    NSString *dictJSON = [dictObj JSONRepresentation];
    NSLog(@"%@", dictJSON);
    
    numberProperty = $(42);
    NSLog(@"%@", [self JSONSerialize]);
    
    dictObj = [dictJSON JSONValue];
    NSLog(@"%@", dictObj);
    
    // Runtime Association Examples
    [self associateWithObject: @"Hello World!"
                       forKey: runtimeAssociationKey(associatedString)];
    NSLog(@"%@", [self associatedObjectForKey: runtimeAssociationKey(associatedString)]);
    
    [self disassociateWithObectForKey: runtimeAssociationKey(associatedString)];
    NSLog(@"%@", [self associatedObjectForKey: runtimeAssociationKey(associatedString)]);
    
    // Container Comprehension
    NSArray *stringArray = [NSArray arrayWithObjects:
        @"Hello|World",
        @"Hello|Goodbye",
        @"Hello|Hello",
        nil
    ];
    
    NSArray *splitStringArray = [stringArray arrayByComprehendingWithBlock: ^id (id element)
    {
        return [element componentsSeparatedByString: @"|"];
    }];
    NSLog(@"%@", splitStringArray);
    
    NSArray *splitLowerStringArray = [stringArray arrayByComprehendingWithBlock: ^id (id element)
    {
        return [[element componentsSeparatedByString: @"|"] arrayByComprehendingWithBlock: ^id (id element)
        {
            return [element lowercaseString];
        }];
    }];
    NSLog(@"%@", splitLowerStringArray);
    
    dictObj = [dictObj dictionaryByComprehendingWithBlock: ^id (NSString *key, id element)
    {
        return $(nil);
    }];
    NSLog(@"%@", dictObj);
    
    NSLog(@"%d", [@"invalidKey" isIn: dictObj]);
    NSLog(@"%d", [[dictObj allKeys] areIn: dictObj]);
}

@end
