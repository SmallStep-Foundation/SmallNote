//
//  TodoParser.m
//  SmallNote
//

#import "TodoParser.h"

@implementation TodoParser

+ (SNTodoLineState)stateOfLine:(NSString *)line {
    NSString *trimmed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    // - [ ] or - [x] (and * [ ] / * [x] for compatibility)
    if ([trimmed hasPrefix:@"- [ ]"] || [trimmed hasPrefix:@"* [ ]"]) return SNTodoLineStateUnchecked;
    if ([trimmed hasPrefix:@"- [x]"] || [trimmed hasPrefix:@"- [X]"] ||
        [trimmed hasPrefix:@"* [x]"] || [trimmed hasPrefix:@"* [X]"]) return SNTodoLineStateChecked;
    return SNTodoLineStateNotCheckbox;
}

+ (NSString *)toggleCheckboxInLine:(NSString *)line {
    SNTodoLineState state = [self stateOfLine:line];
    if (state == SNTodoLineStateNotCheckbox) return line;

    NSString *trimmed = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSRange prefixRange = NSMakeRange(0, 0);
    if ([trimmed hasPrefix:@"- [ ]"]) prefixRange = NSMakeRange(0, 5);
    else if ([trimmed hasPrefix:@"- [x]"] || [trimmed hasPrefix:@"- [X]"]) prefixRange = NSMakeRange(0, 5);
    else if ([trimmed hasPrefix:@"* [ ]"]) prefixRange = NSMakeRange(0, 5);
    else if ([trimmed hasPrefix:@"* [x]"] || [trimmed hasPrefix:@"* [X]"]) prefixRange = NSMakeRange(0, 5);
    if (prefixRange.length == 0) return line;

    NSString *rest = [trimmed substringFromIndex:5];
    NSString *prefix = [trimmed substringToIndex:5];
    BOOL isChecked = [prefix rangeOfString:@"x" options:NSCaseInsensitiveSearch].length > 0;
    NSMutableString *out = [line mutableCopy];
    // Find and replace the checkbox part in original line (preserve leading whitespace)
    NSRange match = [out rangeOfString:@"[ ]"];
    if (match.location != NSNotFound) {
        [out replaceCharactersInRange:match withString:@"[x]"];
        return [out autorelease];
    }
    match = [out rangeOfString:@"[x]" options:NSCaseInsensitiveSearch];
    if (match.location != NSNotFound) {
        [out replaceCharactersInRange:NSMakeRange(match.location, match.length) withString:@"[ ]"];
        return [out autorelease];
    }
    [out release];
    return line;
}

+ (NSString *)toggleCheckboxAtLineIndex:(NSUInteger)index inLines:(NSArray *)lines {
    if (index >= lines.count) return [lines componentsJoinedByString:@"\n"];
    NSMutableArray *m = [lines mutableCopy];
    NSString *line = [lines objectAtIndex:index];
    [m replaceObjectAtIndex:index withObject:[self toggleCheckboxInLine:line]];
    NSString *result = [m componentsJoinedByString:@"\n"];
    [m release];
    return result;
}

+ (NSString *)toggleCheckboxAtLineIndex:(NSUInteger)index inText:(NSString *)text {
    NSArray *lines = [text componentsSeparatedByString:@"\n"];
    return [self toggleCheckboxAtLineIndex:index inLines:lines];
}

@end
