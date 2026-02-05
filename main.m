//
//  main.m
//  SmallNote
//
//  Obsidian-lite / Apple Notes–style note-taking with to-dos for GNUStep.
//  Uses SmallStep for app lifecycle and platform APIs.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "SNAppDelegate.h"
#import "SmallStep.h"

int main(int argc, const char * argv[]) {
#if defined(GNUSTEP) && !__has_feature(objc_arc)
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
#endif
    id<SSAppDelegate> delegate = [[SNAppDelegate alloc] init];
    [SSHostApplication runWithDelegate:delegate];
#if defined(GNUSTEP) && !__has_feature(objc_arc)
    [delegate release];
    [pool release];
#endif
    return 0;
}
