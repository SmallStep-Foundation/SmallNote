//
//  NoteEditorController.m
//  SmallNote
//

#import "NoteEditorController.h"
#import "MainWindow.h"
#import "NoteStore.h"
#import "TodoParser.h"

@implementation NoteEditorController

@synthesize mainWindow = _mainWindow;
@synthesize textView = _textView;
@synthesize currentPath = _currentPath;

- (id)initWithMainWindow:(MainWindow *)mw textView:(NSTextView *)tv {
    self = [super init];
    if (self) {
        _mainWindow = mw;
        _textView = [tv retain];
        _currentPath = nil;
        [_textView setDelegate:self];
    }
    return self;
}

- (void)loadNoteAtPath:(NSString *)path {
    [self saveToCurrentPath];
    NoteStore *store = [NoteStore sharedStore];
    NSError *err = nil;
    NSString *body = [store loadNoteAtPath:path error:&err];
    [self setCurrentPath:path];
    if (body) {
        [[_textView textStorage] replaceCharactersInRange:NSMakeRange(0, [[_textView string] length]) withString:body];
    } else {
        [[_textView textStorage] replaceCharactersInRange:NSMakeRange(0, [[_textView string] length]) withString:@""];
    }
}

- (void)clearContent {
    [self setCurrentPath:nil];
    [[_textView textStorage] replaceCharactersInRange:NSMakeRange(0, [[_textView string] length]) withString:@""];
}

- (void)saveToCurrentPath {
    if (!_currentPath || _currentPath.length == 0) return;
    NSString *content = [_textView string];
    NoteStore *store = [NoteStore sharedStore];
    NSError *err = nil;
    [store saveNoteWithBody:content toPath:_currentPath error:&err];
}

- (void)toggleTodoAtCurrentLine {
    NSString *text = [_textView string];
    NSRange sel = [_textView selectedRange];
    // Find line index containing selection
    NSString *upToCaret = [text substringToIndex:sel.location];
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    NSUInteger lineIndex = 0;
    NSUInteger pos = 0;
    NSUInteger i;
    for (i = 0; i < lines.count; i++) {
        NSString *line = [lines objectAtIndex:i];
        NSUInteger lineLen = line.length + 1;  // + newline
        if (pos + lineLen > sel.location) { lineIndex = i; break; }
        pos += lineLen;
    }
    if (lineIndex >= lines.count) return;
    NSString *newText = [TodoParser toggleCheckboxAtLineIndex:lineIndex inLines:lines];
    [[_textView textStorage] replaceCharactersInRange:NSMakeRange(0, text.length) withString:newText];
    [_textView setSelectedRange:sel];
}

#pragma mark - NSTextViewDelegate

- (void)textDidChange:(NSNotification *)notification {
    (void)notification;
    // Optional: auto-save on timer; for now we save on switch and quit
}

- (void)dealloc {
    [_textView release];
    [_currentPath release];
    [super dealloc];
}

@end
