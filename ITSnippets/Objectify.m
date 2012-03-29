//
//  Objectify.m
//
//  Created by Patrick Perini on 3/21/12.
//  Copyright (c) 2012 Inspyre Technologies. MIT License.
//

#import "Objectify.h"

id __objectify__(char *type, ...)
{
    va_list args;
    va_start(args, type);
    
    id objectValue = nil;
    switch (type[0])
    {
        case 'c': objectValue = [NSNumber numberWithChar: va_arg(args, int)];           break;
        case 'i': objectValue = [NSNumber numberWithInt: va_arg(args, int)];            break;
        case 's': objectValue = [NSNumber numberWithShort: va_arg(args, int)];          break;
        case 'q': objectValue = [NSNumber numberWithLong: va_arg(args, long)];          break;
        case 'f': objectValue = [NSNumber numberWithFloat: va_arg(args, double)];       break;
        case 'd': objectValue = [NSNumber numberWithDouble: va_arg(args, double)];      break;
        case 'B': objectValue = [NSNumber numberWithBool: va_arg(args, int)];           break;
        case '[': objectValue = [NSString stringWithUTF8String: va_arg(args, char *)];  break;
        case '*': objectValue = [NSString stringWithUTF8String: va_arg(args, char *)];  break;
        case '@': objectValue = va_arg(args, id);                                       break;
        case '#': objectValue = va_arg(args, Class);                                    break;
        case ':': objectValue = NSStringFromSelector(va_arg(args, SEL));                break;
        case '^': objectValue = [NSNull null];                                          break;
    }
    
    va_end(args);
    
    return objectValue;
}