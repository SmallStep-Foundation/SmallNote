//
//  SNAppDelegate.m
//  SmallNote
//

#import "SNAppDelegate.h"
#import "MainWindow.h"
#import "SmallStep.h"
#import "SSMainMenu.h"
#import "SSHostApplication.h"

#if !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#endif

@implementation SNAppDelegate

@synthesize mainWindow = _mainWindow;

- (void)applicationWillFinishLaunching {
    [self buildMenu];
}

- (void)applicationDidFinishLaunching {
    self.mainWindow = [[MainWindow alloc] initWithAppDelegate:self];
    [self.mainWindow makeKeyAndOrderFront:nil];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(id)sender {
    (void)sender;
    return YES;
}

- (void)applicationWillTerminate {
    [self.mainWindow saveCurrentNoteIfNeeded];
}

- (void)buildMenu {
#if !TARGET_OS_IPHONE
    SSMainMenu *menuBuilder = [[SSMainMenu alloc] init];
    menuBuilder.appName = @"SmallNote";
    menuBuilder.aboutAppName = @"SmallNote";
    menuBuilder.aboutVersion = @"1.0";
    menuBuilder.aboutTarget = self;
    NSArray *items = [NSArray arrayWithObjects:
        [SSMainMenuItem itemWithTitle:@"New Note" action:@selector(newNote:) keyEquivalent:@"n" modifierMask:NSCommandKeyMask target:self],
        [SSMainMenuItem itemWithTitle:@"Open Notes Folder…" action:@selector(openNotesFolder:) keyEquivalent:@"o" modifierMask:NSCommandKeyMask target:self],
        [SSMainMenuItem itemWithTitle:@"Delete Note" action:@selector(deleteNote:) keyEquivalent:@"" modifierMask:0 target:self],
        [SSMainMenuItem itemWithTitle:@"Toggle To-Do" action:@selector(toggleTodoAtCurrentLine:) keyEquivalent:@"\r" modifierMask:NSCommandKeyMask target:self],
        nil];
    [menuBuilder buildMenuWithItems:items quitTitle:@"Quit SmallNote" quitKeyEquivalent:@"q"];
    [menuBuilder release];
#endif
}

- (void)newNote:(id)sender {
    (void)sender;
    [self.mainWindow createNewNote];
}

- (void)openNotesFolder:(id)sender {
    (void)sender;
    [self.mainWindow chooseNotesFolder];
}

- (void)deleteNote:(id)sender {
    (void)sender;
    [self.mainWindow deleteSelectedNote];
}

- (void)toggleTodoAtCurrentLine:(id)sender {
    (void)sender;
    [self.mainWindow toggleTodoAtCurrentLine];
}

- (void)showAbout:(id)sender {
    (void)sender;
    [SSAboutPanel showWithAppName:@"SmallNote" version:@"1.0"];
}

- (void)dealloc {
    [self.mainWindow release];
    [super dealloc];
}

@end
