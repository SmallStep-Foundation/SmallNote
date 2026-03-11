//
//  NoteStore.m
//  SmallNote
//

#import "NoteStore.h"
#import "SmallStep.h"

static NSString * const kNotesSubdir = @"Notes";
static NSString * const kDefaultAppName = @"SmallNote";

@implementation SNNoteItem

#if defined(GNUSTEP) && !__has_feature(objc_arc)
@synthesize title = _title;
@synthesize path = _path;
@synthesize modificationDate = _modificationDate;
#endif

+ (instancetype)noteWithTitle:(NSString *)title path:(NSString *)path modificationDate:(NSDate *)date {
    SNNoteItem *item = [[SNNoteItem alloc] init];
    item.title = title;
    item.path = path;
    item.modificationDate = date ?: [NSDate date];
    return [item autorelease];
}

- (void)dealloc {
    [_title release];
    [_path release];
    [_modificationDate release];
    [super dealloc];
}

@end

static NSComparisonResult compareNoteDates(id a, id b, void *context);

@implementation NoteStore

static NoteStore *s_shared = nil;
static NSString *s_customNotesDir = nil;

+ (instancetype)sharedStore {
    if (s_shared == nil) {
        s_shared = [[self alloc] init];
    }
    return s_shared;
}

- (NSString *)notesDirectory {
    if (s_customNotesDir != nil && s_customNotesDir.length > 0) {
        NSString *notesDir = [s_customNotesDir stringByAppendingPathComponent:kNotesSubdir];
        NSError *err = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:notesDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:notesDir
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&err];
        }
        return notesDir;
    }
    id<SSFileSystem> fs = [SSFileSystem sharedFileSystem];
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *appName = bundleId.length ? bundleId : kDefaultAppName;
    NSError *err = nil;
    NSString *notesDir = [fs applicationSupportSubdirectoryForAppName:appName subpath:kNotesSubdir create:YES error:&err];
    return notesDir ? notesDir : [fs applicationSupportDirectory];
}

- (void)setNotesDirectory:(NSString *)path {
    if (s_customNotesDir != path) {
        [s_customNotesDir release];
        s_customNotesDir = [path copy];
    }
}

- (NSArray *)listNotes:(NSError **)error {
    NSString *dir = [self notesDirectory];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *names = [fm contentsOfDirectoryAtPath:dir error:error];
    if (names == nil) return [NSArray array];

    NSMutableArray *items = [NSMutableArray array];
    for (NSString *name in names) {
        if (![[name pathExtension] isEqualToString:@"md"]) continue;
        NSString *path = [dir stringByAppendingPathComponent:name];
        NSDictionary *attrs = [fm attributesOfItemAtPath:path error:NULL];
        NSDate *mod = [attrs objectForKey:NSFileModificationDate];
        if (!mod) mod = [NSDate date];
        NSString *title = [name stringByDeletingPathExtension];
        [items addObject:[SNNoteItem noteWithTitle:title path:path modificationDate:mod]];
    }
    [items sortUsingFunction:(NSComparisonResult (*)(id, id, void *))compareNoteDates context:NULL];
    return items;
}

static NSComparisonResult compareNoteDates(id a, id b, void *context) {
    (void)context;
    NSDate *da = [a modificationDate];
    NSDate *db = [b modificationDate];
    return [db compare:da];
}

- (NSString *)loadNoteAtPath:(NSString *)path error:(NSError **)error {
    id<SSFileSystem> fs = [SSFileSystem sharedFileSystem];
    NSData *data = [fs readFileAtPath:path error:error];
    if (data == nil) return nil;
    NSString *s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [s autorelease];
}

- (BOOL)saveNoteWithBody:(NSString *)body toPath:(NSString *)path error:(NSError **)error {
    id<SSFileSystem> fs = [SSFileSystem sharedFileSystem];
    return [fs writeString:(body ? body : @"") toPath:path error:error];
}

- (NSString *)sanitizedFilenameFromTitle:(NSString *)title {
    NSCharacterSet *bad = [NSCharacterSet characterSetWithCharactersInString:@"/\\:*?\"<>|"];
    NSMutableString *s = [[title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
    if (s.length == 0) s = [@"Untitled" mutableCopy];
    NSInteger i;
    for (i = (NSInteger)s.length - 1; i >= 0; i--) {
        if ([bad characterIsMember:[s characterAtIndex:(NSUInteger)i]])
            [s deleteCharactersInRange:NSMakeRange((NSUInteger)i, 1)];
    }
    return [s autorelease];
}

- (NSString *)createNoteWithTitle:(NSString *)title error:(NSError **)error {
    NSString *dir = [self notesDirectory];
    NSString *base = [self sanitizedFilenameFromTitle:title];
    NSString *filename = [base stringByAppendingPathExtension:@"md"];
    NSString *path = [dir stringByAppendingPathComponent:filename];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        NSInteger suffix = 1;
        do {
            filename = [NSString stringWithFormat:@"%@ %ld.md", base, (long)suffix++];
            path = [dir stringByAppendingPathComponent:filename];
        } while ([fm fileExistsAtPath:path]);
    }
    NSString *body = [NSString stringWithFormat:@"# %@\n\n", title];
    if (![self saveNoteWithBody:body toPath:path error:error]) return nil;
    return path;
}

- (BOOL)deleteNoteAtPath:(NSString *)path error:(NSError **)error {
    id<SSFileSystem> fs = [SSFileSystem sharedFileSystem];
    return [fs deleteFileAtPath:path error:error];
}

- (NSString *)renameNoteAtPath:(NSString *)oldPath toTitle:(NSString *)newTitle error:(NSError **)error {
    NSString *dir = [oldPath stringByDeletingLastPathComponent];
    NSString *base = [self sanitizedFilenameFromTitle:newTitle];
    NSString *filename = [base stringByAppendingPathExtension:@"md"];
    NSString *newPath = [dir stringByAppendingPathComponent:filename];
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:newPath] && ![newPath isEqual:oldPath]) {
        if (error) *error = [NSError errorWithDomain:@"NoteStore" code:2 userInfo:[NSDictionary dictionaryWithObject:@"File already exists" forKey:NSLocalizedDescriptionKey]];
        return nil;
    }
    if (![fm moveItemAtPath:oldPath toPath:newPath error:error]) return nil;
    return newPath;
}

@end
