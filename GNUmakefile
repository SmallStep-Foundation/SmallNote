# GNUmakefile for SmallNote (Linux/GNUStep)
#
# Obsidian-lite / Apple Notes–style note-taking app with to-dos and task management.
# Uses SmallStep for platform abstraction; core logic uses Foundation only (no extra FOSS libs).

include $(GNUSTEP_MAKEFILES)/common.make

APP_NAME = SmallNote

SmallNote_OBJC_FILES = \
	main.m \
	app/SNAppDelegate.m \
	core/NoteStore.m \
	core/TodoParser.m \
	ui/MainWindow.m \
	ui/NoteListController.m \
	ui/NoteEditorController.m

SmallNote_HEADER_FILES = \
	app/SNAppDelegate.h \
	core/NoteStore.h \
	core/TodoParser.h \
	ui/MainWindow.h \
	ui/NoteListController.h \
	ui/NoteEditorController.h

SmallNote_INCLUDE_DIRS = \
	-I. \
	-Iapp \
	-Icore \
	-Iui \
	-I../SmallStep/SmallStep/Core \
	-I../SmallStep/SmallStep/Platform/Linux

# SmallStep framework/library
SMALLSTEP_FRAMEWORK := $(shell find ../SmallStep -name "SmallStep.framework" -type d 2>/dev/null | head -1)
ifneq ($(SMALLSTEP_FRAMEWORK),)
  SMALLSTEP_LIB_DIR := $(shell cd $(SMALLSTEP_FRAMEWORK)/Versions/0 2>/dev/null && pwd)
  SMALLSTEP_LIB_PATH := -L$(SMALLSTEP_LIB_DIR)
  SMALLSTEP_LDFLAGS := -Wl,-rpath,$(SMALLSTEP_LIB_DIR)
else
  SMALLSTEP_LIB_PATH :=
  SMALLSTEP_LDFLAGS :=
endif

SmallNote_LIBRARIES_DEPEND_UPON = -lobjc -lgnustep-gui -lgnustep-base
# SmallStep.so depends on libobjc (see SmallStep GNUmakefile). Allow shlib undefined refs so they resolve at load time.
SmallNote_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -Wl,--allow-shlib-undefined
SmallNote_ADDITIONAL_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -lSmallStep
SmallNote_TOOL_LIBS = -lSmallStep -lobjc

before-all::
	mkdir -p Resources && cp -f ../SmallStepLib/Resources/logo.png Resources/logo.png 2>/dev/null || true
SmallNote_RESOURCE_FILES = Resources/logo.png

include $(GNUSTEP_MAKEFILES)/application.make
