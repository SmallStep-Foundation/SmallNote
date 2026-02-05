# SmallNote

A modern note-taking app (Obsidian-lite / Apple Notes–style) with to-dos and task management for **GNUStep** in Objective-C.

## Features

- **Notes**: Plain text / Markdown notes stored as `.md` files in a configurable folder (default: Application Support/SmallNote/Notes).
- **To-dos**: Markdown-style checkboxes (`- [ ]` / `- [x]`) in note body; toggle with **Cmd+Enter** or menu **Toggle To-Do**.
- **UI**: Main window with a note list (sidebar) and editor; New Note, Open Notes Folder, Delete Note, Quit.

## Dependencies

- **GNUStep** (base, gui)
- **SmallStep** (../SmallStep): app lifecycle, file system, main menu, file dialog

Core logic uses **Foundation only** (no extra FOSS libraries): note storage via SmallStep’s `SSFileSystem`, checkbox parsing in Objective-C.

## Build (Linux/GNUStep)

1. Build SmallStep first (must link with libobjc for NSView+SSTag; SmallStep GNUmakefile sets `SmallStep_LIBRARIES_DEPEND_UPON = -lobjc`):
   ```bash
   . /usr/share/GNUstep/Makefiles/GNUstep.sh
   cd ../SmallStep && make && make install
   cd ../SmallNote
   ```
2. Build SmallNote:
   ```bash
   . /usr/share/GNUstep/Makefiles/GNUstep.sh
   make
   ```
   If you see undefined reference to `objc_getAssociatedObject` when linking, ensure SmallStep was rebuilt with `SmallStep_LIBRARIES_DEPEND_UPON = -lobjc` so that `libSmallStep.so` has `libobjc` in its NEEDED list. SmallNote uses `-Wl,--allow-shlib-undefined` so the linker allows SmallStep’s runtime dependency on libobjc to be resolved at load time.
3. Run:
   ```bash
   openapp ./SmallNote.app
   ```
   Or: `./SmallNote.app/SmallNote`

## Project layout

- `main.m` – entry point, uses `SSHostApplication runWithDelegate:`.
- `app/SNAppDelegate` – implements `SSAppDelegate`; builds menu via `SSMainMenu`, owns `MainWindow`.
- `core/NoteStore` – list/load/save/create/delete notes; uses `SSFileSystem`.
- `core/TodoParser` – parse and toggle `- [ ]` / `- [x]` in text.
- `ui/MainWindow` – split view: note list + editor.
- `ui/NoteListController` – table data source, selection.
- `ui/NoteEditorController` – load/save text, toggle to-do at current line.

See **SMALLCORE.md** for shared patterns across Small* apps and possible refactoring into a common core.

## License

GNU AGPLv3 (see LICENSE).
