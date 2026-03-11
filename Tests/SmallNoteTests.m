//
//  SmallNoteTests.m — SmallNote unit tests (TodoParser)
//

#import <Foundation/Foundation.h>
#import "SSTestMacros.h"
#import "../core/TodoParser.h"

static void testTodoParserState(void)
{
    CREATE_AUTORELEASE_POOL(pool);
    SS_TEST_ASSERT([TodoParser stateOfLine:@"- [ ] task"] == SNTodoLineStateUnchecked, "unchecked");
    SS_TEST_ASSERT([TodoParser stateOfLine:@"- [x] done"] == SNTodoLineStateChecked, "checked");
    SS_TEST_ASSERT([TodoParser stateOfLine:@"plain line"] == SNTodoLineStateNotCheckbox, "not checkbox");
    SS_TEST_ASSERT([TodoParser stateOfLine:@"  - [ ] indented"] == SNTodoLineStateUnchecked, "indented");
    RELEASE(pool);
}

static void testTodoParserToggle(void)
{
    CREATE_AUTORELEASE_POOL(pool);
    NSString *unchecked = @"- [ ] item";
    NSString *toggled = [TodoParser toggleCheckboxInLine:unchecked];
    SS_TEST_ASSERT(toggled != nil && [toggled rangeOfString:@"[x]"].location != NSNotFound, "toggle to checked");
    NSString *back = [TodoParser toggleCheckboxInLine:toggled];
    SS_TEST_ASSERT(back != nil && [back rangeOfString:@"[ ]"].location != NSNotFound, "toggle back to unchecked");
    SS_TEST_ASSERT_EQUAL_STR([TodoParser toggleCheckboxInLine:@"plain"], @"plain", "non-checkbox unchanged");
    RELEASE(pool);
}

int main(int argc, char **argv) {
    (void)argc;(void)argv;
    CREATE_AUTORELEASE_POOL(pool);
    testTodoParserState();
    testTodoParserToggle();
    SS_TEST_SUMMARY();
    RELEASE(pool);
    return SS_TEST_RETURN();
}
