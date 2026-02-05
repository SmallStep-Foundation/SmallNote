//
//  NoteStore.h
//  SmallNote
//
//  Note storage: list, load, save notes as plain text / Markdown in a directory.
//  Uses SmallStep SSFileSystem for paths and I/O; no external FOSS libs.
//

#import <Foundation/Foundation.h>

#if defined(GNUSTEP)
#  define SN_ASSUME_NONNULL_BEGIN
#  define SN_ASSUME_NONNULL_END
#else
#  define SN_ASSUME_NONNULL_BEGIN NS_ASSUME_NONNULL_BEGIN
#  define SN_ASSUME_NONNULL_END NS_ASSUME_NONNULL_END
#endif

SN_ASSUME_NONNULL_BEGIN

/// Represents a single note (display title and file path).
@interface SNNoteItem : NSObject {
    NSString *_title;
    NSString *_path;
    NSDate *_modificationDate;
}
@property (nonatomic, copy) NSString *title;   // Display name (filename without .md or first line)
@property (nonatomic, copy) NSString *path;    // Full path to .md file
@property (nonatomic, copy) NSDate *modificationDate;
+ (instancetype)noteWithTitle:(NSString *)title path:(NSString *)path modificationDate:(NSDate *)date;
@end

/// Manages the notes directory: list, load, save, create, delete.
@interface NoteStore : NSObject

+ (instancetype)sharedStore;

/// Notes directory (Application Support/SmallNote/Notes or equivalent).
- (NSString *)notesDirectory;

/// Set a custom notes directory (e.g. user-chosen folder). Nil = default.
- (void)setNotesDirectory:(NSString * _Nullable)path;

/// List all notes (.md files) in the notes directory, sorted by modification date (newest first).
- (NSArray *)listNotes:(NSError **)error;

/// Load note body from path. Returns nil on error.
- (NSString * _Nullable)loadNoteAtPath:(NSString *)path error:(NSError **)error;

/// Save body to path. Overwrites existing file. Returns NO on error.
- (BOOL)saveNoteWithBody:(NSString *)body toPath:(NSString *)path error:(NSError **)error;

/// Create a new note with given title; filename = sanitized title + .md. Returns path or nil.
- (NSString * _Nullable)createNoteWithTitle:(NSString *)title error:(NSError **)error;

/// Delete note at path. Returns NO on error.
- (BOOL)deleteNoteAtPath:(NSString *)path error:(NSError **)error;

/// Rename/move note from oldPath to new filename (sanitized title). Returns new path or nil.
- (NSString * _Nullable)renameNoteAtPath:(NSString *)oldPath toTitle:(NSString *)newTitle error:(NSError **)error;

@end

SN_ASSUME_NONNULL_END
