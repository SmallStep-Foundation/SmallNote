//
//  MainWindow.m
//  SmallNote
//
//  Main window: split view with note list (left) and editor (right).
//

#import "MainWindow.h"
#import "SNAppDelegate.h"
#import "NoteListController.h"
#import "NoteEditorController.h"
#import "NoteStore.h"
#import "SmallStep.h"

#if defined(GNUSTEP)
#  define NSWindowStyleMaskTitled       NSTitledWindowMask
#  define NSWindowStyleMaskClosable    NSClosableWindowMask
#  define NSWindowStyleMaskMiniaturizable NSMiniaturizableWindowMask
#  define NSWindowStyleMaskResizable   NSResizableWindowMask
#  define NSBackingStoreBuffered       NSBackingStoreBuffered
#  define NSModalResponseOK           NSOKButton
#  define NSFileHandlingPanelOKButton NSOKButton
#endif

@implementation MainWindow

@synthesize appDelegate = _appDelegate;
@synthesize noteListController = _noteListController;
@synthesize editorController = _editorController;

- (id)initWithAppDelegate:(SNAppDelegate *)delegate {
    NSRect contentRect = NSMakeRect(100, 100, 900, 600);
    NSUInteger style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable;
    self = [super initWithContentRect:contentRect
                             styleMask:style
                               backing:NSBackingStoreBuffered
                                 defer:NO];
    if (self) {
        _appDelegate = delegate;

        NSView *contentView = [self contentView];
        NSRect bounds = [contentView bounds];

        NSSplitView *splitView = [[NSSplitView alloc] initWithFrame:bounds];
        [splitView setVertical:YES];
        [splitView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

        // Left: note list (table in scroll view)
        NSRect leftFrame = NSMakeRect(0, 0, 220, bounds.size.height);
        NSView *leftView = [[NSView alloc] initWithFrame:leftFrame];
        [leftView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];

        NSScrollView *tableScroll = [[NSScrollView alloc] initWithFrame:leftFrame];
        [tableScroll setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [tableScroll setHasVerticalScroller:YES];
        [tableScroll setHasHorizontalScroller:NO];
        [tableScroll setBorderType:NSBezelBorder];
        [tableScroll setAutohidesScrollers:YES];

        NSTableView *tableView = [[NSTableView alloc] initWithFrame:NSZeroRect];
        NSTableColumn *col = [[NSTableColumn alloc] initWithIdentifier:@"title"];
        [col setTitle:@"Notes"];
        [col setWidth:200];
        [tableView addTableColumn:col];
        [col release];
        [tableView setHeaderView:nil];
        [tableView setAllowsEmptySelection:YES];
        [tableView setAllowsMultipleSelection:NO];

        [tableScroll setDocumentView:tableView];
        [tableView release];
        [leftView addSubview:tableScroll];
        [tableScroll release];

        _noteListController = [[NoteListController alloc] initWithMainWindow:self tableView:[tableScroll documentView]];

        [splitView addSubview:leftView];
        [leftView release];

        // Right: editor (text view in scroll view)
        NSRect rightFrame = NSMakeRect(0, 0, bounds.size.width - 230, bounds.size.height);
        NSScrollView *editorScroll = [[NSScrollView alloc] initWithFrame:rightFrame];
        [editorScroll setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [editorScroll setHasVerticalScroller:YES];
        [editorScroll setHasHorizontalScroller:NO];
        [editorScroll setBorderType:NSNoBorder];
        [editorScroll setAutohidesScrollers:YES];

        NSTextView *textView = [[NSTextView alloc] initWithFrame:NSZeroRect];
        [textView setMinSize:NSMakeSize(0, 0)];
        [textView setMaxSize:NSMakeSize(1e7, 1e7)];
        [textView setVerticallyResizable:YES];
        [textView setHorizontallyResizable:NO];
        [textView setAutoresizingMask:NSViewWidthSizable];
        [[textView textContainer] setContainerSize:NSMakeSize(rightFrame.size.width - 24, 1e7)];
        [[textView textContainer] setWidthTracksTextView:YES];
        [textView setFont:[NSFont userFontOfSize:12]];
        [textView setRichText:NO];
        [textView setAllowsUndo:YES];

        [editorScroll setDocumentView:textView];
        [textView release];

        _editorController = [[NoteEditorController alloc] initWithMainWindow:self textView:textView];

        [splitView addSubview:editorScroll];
        [editorScroll release];

        [contentView addSubview:splitView];
        [splitView release];

        [splitView setPosition:220 ofDividerAtIndex:0];

        [self setTitle:@"SmallNote"];
        [self setReleasedWhenClosed:NO];

        [_noteListController reloadData];
    }
    return self;
}

- (void)createNewNote {
    NoteStore *store = [NoteStore sharedStore];
    NSError *err = nil;
    NSString *path = [store createNoteWithTitle:@"Untitled" error:&err];
    if (path) {
        [self reloadNoteList];
        [self selectNoteAtPath:path];
    }
}

- (void)chooseNotesFolder {
    SSFileDialog *dialog = [SSFileDialog openDialog];
    [dialog setCanChooseFiles:NO];
    [dialog setCanChooseDirectories:YES];
    [dialog setAllowsMultipleSelection:NO];
    NSArray *urls = [dialog showModal];
    if (urls && urls.count > 0) {
        NSString *path = [[urls objectAtIndex:0] path];
        [[NoteStore sharedStore] setNotesDirectory:path];
        [self reloadNoteList];
    }
}

- (void)deleteSelectedNote {
    NSString *path = [_noteListController selectedNotePath];
    if (!path) return;
    NoteStore *store = [NoteStore sharedStore];
    NSError *err = nil;
    if ([store deleteNoteAtPath:path error:&err]) {
        [_editorController clearContent];
        [self reloadNoteList];
    }
}

- (void)toggleTodoAtCurrentLine {
    [_editorController toggleTodoAtCurrentLine];
}

- (void)saveCurrentNoteIfNeeded {
    [_editorController saveToCurrentPath];
}

- (void)selectNoteAtPath:(NSString *)path {
    [_editorController loadNoteAtPath:path];
    [_noteListController selectNoteAtPath:path];
}

- (void)reloadNoteList {
    [_noteListController reloadData];
}

- (void)dealloc {
    [_noteListController release];
    [_editorController release];
    [super dealloc];
}

@end
