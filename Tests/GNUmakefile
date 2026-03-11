#
# SmallNote unit tests
# Build from SmallNote: make -f Tests/GNUmakefile
# Run: ./Tests/obj/test_SmallNote
#

include $(GNUSTEP_MAKEFILES)/common.make

SMALLSTEP_FRAMEWORK := $(shell find ../../SmallStepLib -name "SmallStep.framework" -type d 2>/dev/null | head -1)
ifneq ($(SMALLSTEP_FRAMEWORK),)
  SMALLSTEP_LIB_DIR := $(shell cd $(SMALLSTEP_FRAMEWORK)/Versions/0 2>/dev/null && pwd)
  SMALLSTEP_LIB_PATH := -L$(SMALLSTEP_LIB_DIR)
  SMALLSTEP_LDFLAGS := -Wl,-rpath,$(SMALLSTEP_LIB_DIR)
else
  SMALLSTEP_LIB_PATH :=
  SMALLSTEP_LDFLAGS :=
endif

TOOL_NAME = test_SmallNote
test_SmallNote_OBJC_FILES = SmallNoteTests.m ../core/TodoParser.m
test_SmallNote_INCLUDE_DIRS = -I.. -I../app -I../core -I../ui
test_SmallNote_INCLUDE_DIRS += -I../../SmallStepLib/SmallStep/Core -I../../SmallStepLib/SmallStep/Platform/Linux -I../../SmallStepLib/Tests
test_SmallNote_TOOL_LIBS = -lgnustep-base -lobjc
test_SmallNote_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS)

include $(GNUSTEP_MAKEFILES)/tool.make
