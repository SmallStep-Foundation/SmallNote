//
//  MainWindow.h
//  SmallNote
//
//  Main window: note list (sidebar) + editor. Apple Notes / Obsidian-lite style.
//

#import <AppKit/AppKit.h>

#if defined(GNUSTEP)
#  define SN_ASSUME_NONNULL_BEGIN
#  define SN_ASSUME_NONNULL_END
#else
#  define SN_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#  define SN_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#endif

@class SNAppDelegate;
@class NoteListController;
@class NoteEditorController;

SN_ASSUME_NONNULL_BEGIN

@interface MainWindow : NSWindow {
    SNAppDelegate *_appDelegate;
    NoteListController *_noteListController;
    NoteEditorController *_editorController;
}
@property (nonatomic, assign) SNAppDelegate *appDelegate;
@property (nonatomic, retain) NoteListController *noteListController;
@property (nonatomic, retain) NoteEditorController *editorController;

- (id)initWithAppDelegate:(SNAppDelegate *)appDelegate;

- (void)createNewNote;
- (void)chooseNotesFolder;
- (void)deleteSelectedNote;
- (void)toggleTodoAtCurrentLine;
- (void)saveCurrentNoteIfNeeded;

- (void)selectNoteAtPath:(NSString *)path;
- (void)reloadNoteList;

@end

SN_ASSUME_NONNULL_END
