//
//  NSWindow+Flipping.h
//  OMNE Suite
//
//  Created by Patrick Perini on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSWindow (Flipping)

#pragma mark - Singletons
+ (NSWindow *)flippingContainerWindow;

#pragma mark - Flipping
- (void)flipToShowWindow:(NSWindow *)window forward:(BOOL)forward;

#define swapf(f1, f2) {float _ss; _ss = f1; f1 = f2; f2 = _ss;}

@end
