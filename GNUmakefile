# GNUmakefile for SmallNote (Linux/GNUStep)
#
# Obsidian-lite / Apple Notes–style note-taking app with to-dos and task management.
# Uses SmallStepLib for platform abstraction; core logic uses Foundation only (no extra FOSS libs).
#
# Build SmallStepLib first: cd ../SmallStepLib && make
# Then: make

include $(GNUSTEP_MAKEFILES)/common.make

# Guard: always build the app by default. An explicit .DEFAULT_GOAL makes
# plain 'make' immune to reordering of rules below (e.g. a before-all::
# block before the application.make include would otherwise become the
# default goal and silently skip the app build).
.DEFAULT_GOAL := all

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
	$(SMALLSTEP_INCLUDE_DIRS)

# SmallStep framework (shared discovery - SmallStepLib/GNUmakefile.include)
-include ../SmallStepLib/GNUmakefile.include

SmallNote_LIBRARIES_DEPEND_UPON = -lobjc -lgnustep-gui -lgnustep-base
SmallNote_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -Wl,--allow-shlib-undefined
SmallNote_ADDITIONAL_LDFLAGS = $(SMALLSTEP_LIB_PATH) $(SMALLSTEP_LDFLAGS) -lSmallStep
SmallNote_TOOL_LIBS = -lSmallStep -lobjc

SmallNote_RESOURCE_FILES = \
	Resources/SmallNote.png \
	Resources/logo.png
# Application icon (bare filename; copied into the bundle Resources dir)
SmallNote_APPLICATION_ICON = SmallNote.png

include $(GNUSTEP_MAKEFILES)/application.make

# Copy the shared logo into Resources before the build (defined after
# the application.make include so it is not the makefile default goal)
before-all::
	mkdir -p Resources && cp -f ../SmallStepLib/Resources/logo.png Resources/logo.png 2>/dev/null || true
