//
//  Objectify.h
//
//  Created by Patrick Perini on 3/21/12.
//  Copyright (c) 2012 Inspyre Technologies. MIT License.
//

#import <Foundation/Foundation.h>

id __objectify__(char *type, ...);

#ifndef $
    #define $(var) __objectify__(@encode(typeof(var)), var)
#endif

#ifndef objectify
    #define objectify(var) __objectify__(@encode(typeof(var)), var)
#endif