//
//  SNAppDelegate.h
//  SmallNote
//
//  Application delegate (SSAppDelegate): lifecycle, main menu, main window.
//

#import <Foundation/Foundation.h>
#import "SSAppDelegate.h"

#if defined(GNUSTEP)
#  define SN_ASSUME_NONNULL_BEGIN
#  define SN_ASSUME_NONNULL_END
#else
#  define SN_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#  define SN_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#endif

@class MainWindow;

SN_ASSUME_NONNULL_BEGIN

@interface SNAppDelegate : NSObject <SSAppDelegate> {
    MainWindow *_mainWindow;
}
@property (nonatomic, retain) MainWindow *mainWindow;

- (void)newNote:(id)sender;
- (void)openNotesFolder:(id)sender;
- (void)deleteNote:(id)sender;
- (void)toggleTodoAtCurrentLine:(id)sender;

@end

SN_ASSUME_NONNULL_END
