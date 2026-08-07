#
# SmallNote unit tests
# Build from SmallNote: make -f Tests/GNUmakefile
# Run: ./Tests/obj/test_SmallNote
#

include $(GNUSTEP_MAKEFILES)/common.make

# SmallStep framework (shared discovery - SmallStepLib/GNUmakefile.include)
-include ../../SmallStepLib/GNUmakefile.include

TOOL_NAME = test_SmallNote
test_SmallNote_OBJC_FILES = SmallNoteTests.m ../core/TodoParser.m
test_SmallNote_INCLUDE_DIRS = -I.. -I../app -I../core -I../ui
test_SmallNote_INCLUDE_DIRS += $(SMALLSTEP_INCLUDE_DIRS) -I../../SmallStepLib/Tests
test_SmallNote_TOOL_LIBS = -lgnustep-base -lobjc
test_SmallNote_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS)

include $(GNUSTEP_MAKEFILES)/tool.make
