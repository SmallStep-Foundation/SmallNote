//
//  TodoParser.h
//  SmallNote
//
//  Parse and toggle Markdown-style to-do checkboxes (- [ ] / - [x]) in note text.
//  Pure Foundation; no external FOSS libs.
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

/// Result of parsing a single line: is it a checkbox line, and is it checked?
typedef NS_ENUM(NSInteger, SNTodoLineState) {
    SNTodoLineStateNotCheckbox = 0,
    SNTodoLineStateUnchecked,
    SNTodoLineStateChecked
};

@interface TodoParser : NSObject

/// Detect checkbox state of a single line (e.g. "  - [ ] task" or "- [x] done").
+ (SNTodoLineState)stateOfLine:(NSString *)line;

/// Toggle the checkbox on the given line. If line is not a checkbox, returns line unchanged.
+ (NSString *)toggleCheckboxInLine:(NSString *)line;

/// Replace the line at the given index in `lines` with the toggled version; return new full text.
+ (NSString *)toggleCheckboxAtLineIndex:(NSUInteger)index inLines:(NSArray *)lines;

/// Given full note text, toggle checkbox at line index (0-based). Returns new full text.
+ (NSString *)toggleCheckboxAtLineIndex:(NSUInteger)index inText:(NSString *)text;

@end

SN_ASSUME_NONNULL_END
