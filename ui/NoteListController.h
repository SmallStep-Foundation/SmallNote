//
//  NoteListController.h
//  SmallNote
//
//  Controls the note list (sidebar): NSTableView data source, selection, reload.
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
@class SNNoteItem;

SN_ASSUME_NONNULL_BEGIN

@interface NoteListController : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
    MainWindow *_mainWindow;
    NSTableView *_tableView;
    NSArray *_notes;
}
@property (nonatomic, assign) MainWindow *mainWindow;
@property (nonatomic, retain) NSTableView *tableView;
@property (nonatomic, retain) NSArray *notes;

- (id)initWithMainWindow:(MainWindow *)mainWindow tableView:(NSTableView *)tableView;

- (void)reloadData;
- (NSString * _Nullable)selectedNotePath;
- (void)selectNoteAtPath:(NSString *)path;

@end

SN_ASSUME_NONNULL_END
