# GTA SA:MP — WindowedMode 2.2 Mouse Escape Source Patch

This is SOURCE ONLY, not a compiled .asi. The supplied archives contain empty git submodule directories, and this Linux environment cannot build the Windows 32-bit ASI. You must compile it on Windows (Visual Studio 2022 + Desktop development with C++ / x86 toolchain).

## What changed compared with v1.17
- v2.2 runs `MouseUpdate()` on every D3D Present, including `ClipCursor(&rect)` while playing.
- v1.17 uses `ProcessMouseState()` and DirectInput cooperative state changes instead of v2.2's per-frame clipping.
- v2.2 already NOPs GTA SA's base `RsMouseSetPos` call, but that does not neutralize its own `ClipCursor` lock.
- This patch alters only the v2.2 mouse-lock code, leaving game/window/Direct3D hooks intact. It does not transplant v1.17's brittle memory hooks, which can conflict with your modpack.

## New INI options
Add the following inside the `[game]` section of III.VC.SA.WindowedMode.ini:

    releaseCursorInChat=1
    disableMouseClipping=0

Behavior: pressing T or F6 in SA:MP releases `ClipCursor`; pressing Enter or Esc restores it. A regular game mouse remains confined. Requires stock SA:MP chat keyboard behavior and detection of `samp.dll`.

For troubleshooting ONLY, set `disableMouseClipping=1` (unconfines at all times, including gameplay). Set back to 0 if gameplay camera behavior is abnormal. `releaseCursorInChat=0` disables the new chat-specific behavior.

Note: This uses `WM_KEYDOWN` to infer chat opening and closing. It does NOT read the actual SA:MP chat state, and can become out of sync with unusual chat mods, dialogs, or key bindings. It also does not stop OTHER mods from explicitly calling SetCursorPos/ClipCursor. If your mouse still snaps back, identify and patch the other source, or use a compatible chat-state API. This is not a guaranteed or verified in-game fix.

## Build on Windows
1. Extract this archive.
2. Populate the missing dependency folders by cloning:
   - `https://github.com/ThirteenAG/IniReader` into `external/IniReader`
   - `https://github.com/ThirteenAG/injector` with `--recursive` into `external/injector`
   Because the original ZIP does not contain the submodules, build compatibility with the current repository heads is not guaranteed; matching version/tag dependencies are preferable.
3. Try `BUILD_ON_WINDOWS.bat` (a helper that fetches the missing dependencies and invokes Visual Studio), or run `premake5.exe vs2022` manually.
4. Build the generated solution in Visual Studio with **Release / Win32**.
5. Back up the working WindowedMode ASI/INI before testing the rebuilt ASI. Never load two WindowedMode versions simultaneously.

## Safety/testing
- This code has been verified with source-level comparisons and assertions, but it has NOT been compiled or run in GTA SA/SA:MP.
- Make the first test in a COPY of the modpack.
- If you get a crash, restore the original ASI and send the crash report and `moonloader.log`.
- `MOUSE_ESCAPE_v2.2.patch` is provided if you prefer applying the small edit to a git checkout.
