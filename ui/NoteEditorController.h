//
//  NoteEditorController.h
//  SmallNote
//
//  Controls the note editor (NSTextView): load/save text, toggle to-do at current line.
//

#import <AppKit/AppKit.h>

#if defined(GNUSTEP)
#  define SN_ASSUME_NONNULL_BEGIN
#  define SN_ASSUME_NONNULL_END
#else
#  define SN_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#  define SN_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#endif

@class MainWindow;

SN_ASSUME_NONNULL_BEGIN

@interface NoteEditorController : NSObject <NSTextViewDelegate> {
    MainWindow *_mainWindow;
    NSTextView *_textView;
    NSString *_currentPath;
}
@property (nonatomic, assign) MainWindow *mainWindow;
@property (nonatomic, retain) NSTextView *textView;
@property (nonatomic, copy) NSString *currentPath;

- (id)initWithMainWindow:(MainWindow *)mainWindow textView:(NSTextView *)textView;

- (void)loadNoteAtPath:(NSString *)path;
- (void)clearContent;
- (void)saveToCurrentPath;
- (void)toggleTodoAtCurrentLine;

@end

SN_ASSUME_NONNULL_END
