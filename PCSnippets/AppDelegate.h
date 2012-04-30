//
//  AppDelegate.h
//  ITSnippets
//
//  Created by Patrick Perini on 3/29/12.
//  Copyright (c) 2012 Inspyre Technologies. MIT License.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (retain) NSString *stringProperty;
@property (retain) NSNumber *numberProperty;

@end
