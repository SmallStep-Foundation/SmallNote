//
//  NoteListController.m
//  SmallNote
//

#import "NoteListController.h"
#import "MainWindow.h"
#import "NoteStore.h"

@implementation NoteListController

@synthesize mainWindow = _mainWindow;
@synthesize tableView = _tableView;
@synthesize notes = _notes;

- (id)initWithMainWindow:(MainWindow *)mw tableView:(NSTableView *)tv {
    self = [super init];
    if (self) {
        _mainWindow = mw;
        _tableView = [tv retain];
        _notes = [NSArray array];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [_tableView setTarget:self];
        [_tableView setDoubleAction:@selector(doubleClickedRow:)];
    }
    return self;
}

- (void)reloadData {
    NoteStore *store = [NoteStore sharedStore];
    NSError *err = nil;
    NSArray *list = [store listNotes:&err];
    [self setNotes:list ? list : [NSArray array]];
    [_tableView reloadData];
    if (_notes.count > 0 && [_tableView selectedRow] < 0) {
        [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        [_mainWindow selectNoteAtPath:[[_notes objectAtIndex:0] path]];
    }
}

- (NSString *)selectedNotePath {
    NSInteger row = [_tableView selectedRow];
    if (row < 0 || row >= (NSInteger)[_notes count]) return nil;
    return [[_notes objectAtIndex:row] path];
}

- (void)selectNoteAtPath:(NSString *)path {
    NSUInteger i;
    for (i = 0; i < _notes.count; i++) {
        if ([[[_notes objectAtIndex:i] path] isEqual:path]) {
            [_tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:i] byExtendingSelection:NO];
            [_tableView scrollRowToVisible:i];
            return;
        }
    }
}

- (void)doubleClickedRow:(id)sender {
    (void)sender;
    NSString *path = [self selectedNotePath];
    if (path) [_mainWindow selectNoteAtPath:path];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    (void)tv;
    return (NSInteger)[_notes count];
}

- (id)tableView:(NSTableView *)tv objectValueForTableColumn:(NSTableColumn *)col row:(NSInteger)row {
    (void)tv;
    (void)col;
    if (row < 0 || row >= (NSInteger)[_notes count]) return nil;
    SNNoteItem *item = [_notes objectAtIndex:row];
    return item.title;
}

#pragma mark - NSTableViewDelegate

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    (void)notification;
    NSString *path = [self selectedNotePath];
    if (path) [_mainWindow selectNoteAtPath:path];
}

- (void)dealloc {
    [_tableView release];
    [_notes release];
    [super dealloc];
}

@end
