# Shared core patterns across Small* apps

This document summarizes common functionality used by **SmallNote**, **SmallBarcoder**, **SmallColourSync**, and other Small* apps, and suggests what could be extracted or refactored into a reusable core (e.g. inside **SmallStep** or a separate **SmallCore**).

## What SmallStep already provides

- **SSHostApplication** + **SSAppDelegate**: Cross-platform app lifecycle; desktop apps call `[SSHostApplication runWithDelegate:myDelegate]`.
- **SSFileSystem**: Documents, cache, application support directories; read/write/list/delete files.
- **SSMainMenu**: Build a desktop main menu from an array of item descriptors + Quit.
- **SSFileDialog**: Open/save file dialogs (modal or completion handler).
- **SSPlatform**: Platform detection (macOS, iOS, Linux, Windows).
- **SSWindowStyle**, **SSConcurrency**, **NSView+SSTag**: Additional helpers.

## Patterns repeated across Small* apps

### 1. App entry and delegate

- **SmallBarcoder**: `main.m` creates `NSApplication`, sets `AppDelegate` as `NSApplicationDelegate`, runs. No SmallStep lifecycle.
- **SmallColourSync**: Same: `AppController` as `NSApplicationDelegate`.
- **SmallNote**: Uses `[SSHostApplication runWithDelegate:SNAppDelegate]` (SmallStep pattern).

**Recommendation**: Prefer **SSHostApplication** + **SSAppDelegate** for new apps so lifecycle and “quit after last window” are consistent. Optionally refactor SmallBarcoder/SmallColourSync to use it.

### 2. Main menu

- **SmallBarcoder**: Uses **SSApplicationMenu** (Barcode-specific: File, Decode, Encode, Symbologies, etc.).
- **SmallColourSync**: Custom or GORM; no SSMainMenu in the snippet seen.
- **SmallNote**: Uses **SSMainMenu** with generic items (New Note, Open Folder…, Delete, Toggle To-Do, Quit).

**Recommendation**: Use **SSMainMenu** for apps that need a simple app menu + Quit. Keep **SSApplicationMenu** (or app-specific menus) for domain-heavy menus.

### 3. File and directory paths

- All use either **SSFileSystem** (SmallStep) or `NSSearchPathForDirectoriesInDomains` / platform paths.
- **SmallNote**: Notes directory = `[SSFileSystem applicationSupportDirectory]/AppName/Notes`.

**Recommendation**: Standardize on **SSFileSystem** for app support, documents, cache, and all file I/O so behaviour is consistent on Linux (XDG), macOS, and Windows.

### 4. Optional FOSS libraries

- **SmallBarcoder**: ZBar, ZInt (optional; pkg-config, conditional compile).
- **SmallColourSync**: lcms2, OpenGL, Vulkan (optional).
- **SmallNote**: No extra libs; core logic is Foundation + SmallStep.

**Recommendation**: Keep optional libs behind `HAVE_*` and conditional linking; document in each app’s README. No need to put these in a “core”; they stay app-specific.

### 5. Build system (GNUmakefile)

- All use `GNUSTEP_MAKEFILES`, `common.make`, `application.make` (or framework for SmallStep).
- SmallStep path: `-I../SmallStep/SmallStep/Core` (and Platform/Linux); link `-lSmallStep` and optional rpath.

**Recommendation**: Extract a small snippet or script for “link to SmallStep from a sibling app” (include path, TOOL_LIBS, LDFLAGS) so new Small* apps can paste and adjust.

## What could become “SmallCore” (or live in SmallStep)

- **App delegate template**: Minimal `SSAppDelegate` implementation (menu build + main window) as a starting point.
- **Document/window pattern**: “One main window, one document type” helper (e.g. list + editor) is currently app-specific; could stay that way or become an optional pattern doc.
- **Settings/preferences**: If several apps need the same “load/save plist in Application Support” behaviour, a thin **SSPreferences** or **SSSettings** in SmallStep could be added later.

No code need be moved immediately; this doc is a reference for consistent patterns and future refactors.

## Summary

| Concern           | Source        | Reuse / recommendation                          |
|------------------|---------------|--------------------------------------------------|
| App lifecycle    | SmallStep     | Use SSHostApplication + SSAppDelegate           |
| Paths & file I/O | SmallStep     | Use SSFileSystem everywhere                     |
| Main menu        | SmallStep     | Use SSMainMenu for simple apps                  |
| File dialogs     | SmallStep     | Use SSFileDialog for open/save                  |
| Optional libs    | Per-app       | Keep optional; document; no core extraction     |
| Build            | Per-app       | Share SmallStep link snippet in docs            |

SmallNote follows these recommendations and uses SmallStep for as much as possible; core note and to-do logic is implemented with Foundation only and no extra FOSS libraries.
