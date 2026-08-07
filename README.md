# SmallNote

A modern note-taking app (Obsidian-lite / Apple Notes–style) with to-dos and task management for **GNUStep** in Objective-C.

## Features

- **Notes**: Plain text / Markdown notes stored as `.md` files in a configurable folder (default: Application Support/SmallNote/Notes).
- **To-dos**: Markdown-style checkboxes (`- [ ]` / `- [x]`) in note body; toggle with **Cmd+Enter** or menu **Toggle To-Do**.
- **UI**: Main window with a note list (sidebar) and editor; New Note, Open Notes Folder, Delete Note, Quit.

## Dependencies

- **GNUStep** (base, gui)
- **SmallStepLib** (`../SmallStepLib`): app lifecycle, file system, main menu, file dialog

Core logic uses **Foundation only** (no extra FOSS libraries): note storage via SmallStep’s `SSFileSystem`, checkbox parsing in Objective-C.

## Build

SmallStepLib is built first automatically by [`../build_all.sh`](../build_all.sh); to build this app alone:

```bash
. /tmp/gnustep-toolchain/setup-env.sh    # or your GNUstep env (GNUstep.sh)
make -C ../SmallStepLib CC=clang         # once
make CC=clang                            # from this directory
```

## Run

```bash
openapp ./SmallNote.app                  # from this directory
# or: ./SmallNote.app/SmallNote
```

## Test

```bash
make -f Tests/GNUmakefile CC=clang all && ./Tests/obj/test_SmallNote
```

## Project layout

- `main.m` – entry point, uses `SSHostApplication runWithDelegate:`.
- `app/SNAppDelegate` – implements `SSAppDelegate`; builds menu via `SSMainMenu`, owns `MainWindow`.
- `core/NoteStore` – list/load/save/create/delete notes; uses `SSFileSystem`.
- `core/TodoParser` – parse and toggle `- [ ]` / `- [x]` in text.
- `ui/MainWindow` – split view: note list + editor.
- `ui/NoteListController` – table data source, selection.
- `ui/NoteEditorController` – load/save text, toggle to-do at current line.

See **SMALLCORE.md** for shared patterns across Small* apps and possible refactoring into a common core.

## HiDPI

GNUstep renders at 1:1 pixels; on high-DPI screens set the `GSScaleFactor`
user default once to scale every GNUstep app (see the workspace
[README](../README.md#hidpi-displays)).

## License

GNU AGPLv3 (see LICENSE).
