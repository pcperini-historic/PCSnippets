//
//  NSWindow+Flipping.m
//  OMNE Suite
//
//  Created by Patrick Perini on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSWindow+Flipping.h"
#import <QuartzCore/QuartzCore.h>

#pragma mark NSAnimation Subclassing
#pragma mark - Internal Constants
NSInteger const NSWindowFlippingAnimationNullDuration = 1.0E8;

@interface NSWindowFlippingAnimation : NSAnimation

#pragma mark - Properties
@property NSView *animatingContentView;

#pragma mark - Initializers
- (id)initWithAnimationCurve:(NSAnimationCurve)animationCurve animatingContentView:(NSView *)aView;

#pragma mark - Progress Handlers
- (void)startAtProgress:(NSAnimationProgress)value withDuration:(NSTimeInterval)duration;

@end

@implementation NSWindowFlippingAnimation

#pragma mark - Properties
@synthesize animatingContentView;

#pragma mark - Initializers
- (id)initWithAnimationCurve:(NSAnimationCurve)animationCurve animatingContentView:(NSView *)aView
{
    self = [super initWithDuration: NSWindowFlippingAnimationNullDuration
                    animationCurve: animationCurve];
    if (!self)
        return nil;
    
    animatingContentView = aView;
    
    return self;
}

#pragma mark - Progress Handlers
- (void)startAtProgress:(NSAnimationProgress)value withDuration:(NSTimeInterval)duration
{
    [super setCurrentProgress: value];
    [self setDuration: duration];
    [self startAnimation];
}

- (void)setCurrentProgress:(NSAnimationProgress)progress
{
    [super setCurrentProgress: progress];
    if ([self isAnimating] && (progress < 0.99))
    {
        [animatingContentView display];
    }
}

@end

#pragma mark NSView Subclassing
#pragma mark - Internal Constants
NSString *const NSWindowFlippingViewAnimationTransitionFilterName = @"CIPerspectiveTransform";
NSString *const NSWindowFlippingViewAnimationTransitionFilterInputImageKey = @"inputImage";
NSString *const NSWindowFlippingViewAnimationTransitionFilterOutputImageKey = @"outputImage";
NSString *const NSWindowFlippingViewAnimationTransitionFilterInputTopRightKey = @"inputTopRight";
NSString *const NSWindowFlippingViewAnimationTransitionFilterInputTopLeftKey = @"inputTopLeft";
NSString *const NSWindowFlippingViewAnimationTransitionFilterInputBottomRightKey = @"inputBottomRight";
NSString *const NSWindowFlippingViewAnimationTransitionFilterInputBottomLeftKey = @"inputBottomLeft";

#define NSWindowFlippingViewAnimationDefaultShadowColor [[NSColor shadowColor] colorWithAlphaComponent: .8]
NSInteger const NSWindowFlippingViewAnimationDefaultShadowBlurRadius = 45;
NSSize const NSSwindowFlippingViewAnimationDefaultShadowOffset = {0, -20};

CGFloat const NSWindowFlippingViewAnimationDefaultDuration = 0.75;
CGFloat const NSWindowFlippingViewAnimationDurationOfManualFrames = (NSWindowFlippingViewAnimationDefaultDuration / 15);

CGFloat const NSWindowFlippingViewAnimationDefaultDistanceRatio = 5.0;

CGFloat const NSWindowFlippingViewAnimationTimeDeltaAccuracy = 1.0E9;

@interface NSWindowFlippingView : NSView <NSAnimationDelegate>

#pragma mark - Initializers
- (id)initWithFrame:(NSRect)frameRect andOriginalFrame:(NSRect)originalFrameRect;

#pragma mark - Mutatoris
- (void)setInitialWindow:(NSWindow *)anInitialWindow finalWindow:(NSWindow *)aFinalWindow andFlippingDirection:(BOOL)isForward;

@end

@implementation NSWindowFlippingView
{
    NSRect originalFrame;
    NSShadow *windowShadow;
    
    NSWindow *initialWindow;
    NSWindow *finalWindow;
    
    CIImage *finalImage;
    CIFilter *transitionFilter;
    
    NSWindowFlippingAnimation *animation;
    CGFloat animationDirection;
    CGFloat animationFrameTime;
}

#pragma mark - Initializers
- (id)initWithFrame:(NSRect)frameRect andOriginalFrame:(NSRect)originalFrameRect
{
    self = [super initWithFrame: frameRect];
    if (!self)
        return nil;
    
    originalFrame = originalFrameRect;
    
    transitionFilter = [CIFilter filterWithName: NSWindowFlippingViewAnimationTransitionFilterName];
    [transitionFilter setDefaults];
    
    windowShadow  = [[NSShadow alloc] init];
    [windowShadow setShadowColor: NSWindowFlippingViewAnimationDefaultShadowColor];
    [windowShadow setShadowBlurRadius: NSWindowFlippingViewAnimationDefaultShadowBlurRadius];
    [windowShadow setShadowOffset: NSSwindowFlippingViewAnimationDefaultShadowOffset];
    
    return self;
}

#pragma mark - Accessors
- (BOOL)isOpaque
{
    return NO;
}

#pragma mark - Mutators
- (void)setInitialWindow:(NSWindow *)anInitialWindow finalWindow:(NSWindow *)aFinalWindow andFlippingDirection:(BOOL)isForward
{
    // Initialize Variables
    initialWindow = anInitialWindow;
    finalWindow = aFinalWindow;
    animationDirection = isForward? 1 : -1;
    NSWindow *flippingContainerWindow = [NSWindow flippingContainerWindow];
    
    // Reposition and Resize
    NSRect contentWindowFrame = [initialWindow frame];
    NSRect flippingContainerWindowFrame = [flippingContainerWindow frame];
    
    flippingContainerWindowFrame.origin.x = contentWindowFrame.origin.x - originalFrame.origin.x;
    flippingContainerWindowFrame.origin.y = contentWindowFrame.origin.y - originalFrame.origin.y;
    
    flippingContainerWindowFrame.size.width += NSWidth(contentWindowFrame) - NSWidth(originalFrame);
    flippingContainerWindowFrame.size.height += NSHeight(contentWindowFrame) - NSHeight(originalFrame);
    
    [flippingContainerWindow setFrame: flippingContainerWindowFrame
                              display: NO];
    
    originalFrame.size = contentWindowFrame.size;
    
    // Build Content Images
    NSView *windowViewSuperview = [[initialWindow contentView] superview];
    NSRect windowViewSuperViewFrame = [windowViewSuperview bounds];
    
    NSBitmapImageRep *windowBitmapRepresentation = [windowViewSuperview bitmapImageRepForCachingDisplayInRect: windowViewSuperViewFrame];
    [windowViewSuperview cacheDisplayInRect: windowViewSuperViewFrame
                           toBitmapImageRep: windowBitmapRepresentation];
    
    CIImage *initialImage = [[CIImage alloc] initWithBitmapImageRep: windowBitmapRepresentation];
    [transitionFilter setValue: initialImage forKey: NSWindowFlippingViewAnimationTransitionFilterInputImageKey];
    initialImage = nil;
    
    // Draw Initial Frames
    CGFloat totalTime = animationFrameTime;
    NSDisableScreenUpdates();
    {
        [finalWindow makeKeyAndOrderFront: nil];
        
        windowViewSuperview = [[finalWindow contentView] superview];
        windowViewSuperViewFrame = [windowViewSuperview bounds];
        
        windowBitmapRepresentation = [windowViewSuperview bitmapImageRepForCachingDisplayInRect: windowViewSuperViewFrame];
        [windowViewSuperview cacheDisplayInRect: windowViewSuperViewFrame
                               toBitmapImageRep: windowBitmapRepresentation];
        
        finalImage = [[CIImage alloc] initWithBitmapImageRep: windowBitmapRepresentation];
        
        [finalWindow setAlphaValue: 0];
        [initialWindow orderOut: nil];
        
        animation = [[NSWindowFlippingAnimation alloc] initWithAnimationCurve: NSAnimationEaseInOut animatingContentView: self];
        [animation setDelegate: self];
        
        // Begin Animations
        [animation setCurrentProgress: 0];
        
        [flippingContainerWindow orderWindow: NSWindowBelow
                                  relativeTo: [finalWindow windowNumber]];
        
        [animation setCurrentProgress: NSWindowFlippingViewAnimationDurationOfManualFrames];
    }
    NSEnableScreenUpdates();
    
    totalTime += animationFrameTime;
    [animation startAtProgress: (totalTime / NSWindowFlippingViewAnimationDefaultDuration)
                  withDuration: NSWindowFlippingViewAnimationDefaultDuration];
}

#pragma mark - Animation Callbacks
- (void)animationDidEnd:(NSAnimation *)anAnimation
{
    NSDisableScreenUpdates();
    {
        [[NSWindow flippingContainerWindow] orderOut: nil];
        
        [finalWindow setAlphaValue: 1];
        [finalWindow display];
    }
    NSEnableScreenUpdates();
    
    initialWindow = nil;
    finalWindow = nil;
    
    finalImage = nil;
    
    animation = nil;
}

#pragma mark - Drawers
- (void)drawRect:(NSRect)dirtyRect
{
    if (!initialWindow)
        return;
    
    // Initialize Variables
    AbsoluteTime startTime = UpTime();
    float currentTime = [animation currentValue];
    
    float flipRadius = NSWidth(originalFrame) / 2;
    float flipWidth = flipRadius;
    float flipHeight = NSHeight(originalFrame) / 2;
    float flipDistance = flipRadius * NSWindowFlippingViewAnimationDefaultDistanceRatio;
    float flipAngle = animationDirection * (M_PI * currentTime);
    
    // Initialize Ethereal Math Variables
    float px1 = flipRadius * cos(flipAngle);
    float pz = flipRadius * sin(flipAngle);
    float pz1 = flipDistance + pz;
    float px2 = -px1;
    float pz2 = flipDistance - pz;
    
    if (currentTime > 0.5)
    {
        if (finalImage)
        {
            [transitionFilter setValue: finalImage forKey: NSWindowFlippingViewAnimationTransitionFilterInputImageKey];
            finalImage = nil;
        }
        
        swapf(px1, px2);
        swapf(pz1, pz2);
    }
    
    float sx1 = (flipDistance * px1 / pz1);
    float sy1 = (flipDistance * flipHeight / pz1);
    float sx2 = (flipDistance * px2 / pz2);
    float sy2 = (flipDistance * flipHeight / pz2);
    
    // Adjust CoreImage Filter
    [transitionFilter setValue: [CIVector vectorWithX: (flipWidth + sx1) Y: (flipHeight + sy1)] forKey: NSWindowFlippingViewAnimationTransitionFilterInputTopRightKey];
    [transitionFilter setValue: [CIVector vectorWithX: (flipWidth + sx2) Y: (flipHeight + sy2)] forKey: NSWindowFlippingViewAnimationTransitionFilterInputTopLeftKey];
    [transitionFilter setValue: [CIVector vectorWithX: (flipWidth + sx1) Y: (flipHeight - sy1)] forKey: NSWindowFlippingViewAnimationTransitionFilterInputBottomRightKey];
    [transitionFilter setValue: [CIVector vectorWithX: (flipWidth + sx2) Y: (flipHeight - sy2)] forKey: NSWindowFlippingViewAnimationTransitionFilterInputBottomLeftKey];
    
    CIImage *outputImage = [transitionFilter valueForKey: NSWindowFlippingViewAnimationTransitionFilterOutputImageKey];
    
    // Draw
    NSRect originalBounds = NSMakeRect(-originalFrame.origin.x,
                                       -originalFrame.origin.y,
                                       NSWidth([self bounds]),
                                       NSHeight([self bounds]));
    
    [windowShadow set];
    [outputImage drawInRect: [self bounds]
                   fromRect: originalBounds
                  operation: NSCompositeSourceOver
                   fraction: 1];
    
    animationFrameTime = (UnsignedWideToUInt64(AbsoluteDeltaToNanoseconds(UpTime(), startTime)) / NSWindowFlippingViewAnimationTimeDeltaAccuracy);
}

@end

#pragma mark NSWindow Categorizing
#pragma mark - Internal Constants
#define NSWindowFlippingContainerWindowDefaultContentRect NSMakeRect(0, 0, 512, 768)
#define NSWindowFlippingContainerWindowDefaultOriginalFrame NSInsetRect(NSWindowFlippingContainerWindowDefaultContentRect, 64, 256)
@implementation NSWindow (Flipping)

#pragma mark - Singletons
static NSWindow *flippingContainerWindow;
+ (NSWindow *)flippingContainerWindow
{
    if (!flippingContainerWindow)
    {
        flippingContainerWindow = [[NSWindow alloc] initWithContentRect: NSWindowFlippingContainerWindowDefaultContentRect
                                                              styleMask: NSBorderlessWindowMask
                                                                backing: NSBackingStoreBuffered
                                                                  defer: NO];
        [flippingContainerWindow setOpaque: NO];
        [flippingContainerWindow setHasShadow: NO];
        [flippingContainerWindow setOneShot: YES];
        [flippingContainerWindow setBackgroundColor: [NSColor clearColor]];
        
        NSWindowFlippingView *flippingView = [[NSWindowFlippingView alloc] initWithFrame: NSWindowFlippingContainerWindowDefaultContentRect
                                                                        andOriginalFrame: NSWindowFlippingContainerWindowDefaultOriginalFrame];
        [flippingView setAutoresizingMask: NSViewWidthSizable | NSViewHeightSizable];
        
        [flippingContainerWindow setContentView: flippingView];
    }
    
    return flippingContainerWindow;
}

- (void)flipToShowWindow:(NSWindow *)window forward:(BOOL)forward
{
    [window setFrame: [self frame]
             display: NO];
    
    [(NSWindowFlippingView *) [[NSWindow flippingContainerWindow] contentView] setInitialWindow: self
                                                                                    finalWindow: window
                                                                           andFlippingDirection: forward];
}

@end
