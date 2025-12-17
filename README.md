# Dueling Batteries

A Wear OS Watch face showing watch and phone battery level, weather and heart rate, in Watch Face Format.

This repository contains helper scripts to **build** and **extract** Watch Face Studio (`.wfs`) project files.

---

## 📂 Project Structure

```

/ # repository root directory
├── build/ # generated output files (.zip, .wfs, validation-tail.bin)
├── src/ # Watch Face Studio source files
└── scripts/ # Scripts for converting between source files and Watch Face Studio files

```

---

## 🚀 Build Workflow

### Windows (PowerShell)

From the repo root:

```powershell
.\scripts\build.ps1
```

This will:

- Delete and recreate the `build\` directory to ensure a clean run.
- Compress the contents of `src\` into a zip.
- Append the required 16‑byte validation tail (`normal_watchface`).
- Produce `DuelingBatteries.wfs` in the `build\` directory.

If you see an error like _“running scripts is disabled on this system”_, temporarily allow script execution:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Once generated, you can open the [DuelingBatteries.wfs](./build/DuelingBatteries.wfs) file in [Watch Face Studio](https://developer.samsung.com/watch-face-studio/overview.html).

---

### Linux / macOS (Bash)

From the repo root:

```bash
./scripts/build.sh
```

Make sure the script is executable first:

```bash
chmod +x scripts/build.sh
```

This will:

- Delete and recreate the `build/` directory to ensure a clean run.
- Compress the contents of `src/` into a zip.
- Append the validation tail.
- Produce `DuelingBatteries.wfs` in the `build/` directory.

Once generated, you can open the [DuelingBatteries.wfs](./build/DuelingBatteries.wfs) file in [Watch Face Studio](https://developer.samsung.com/watch-face-studio/overview.html).

---

## 🔄 Extract Workflow

### Windows (PowerShell)

From the repo root:

```powershell
.\scripts\extract.ps1
```

This will:

- Verify that `build\DuelingBatteries.wfs` exists.
- Strip the 16‑byte validation tail.
- Delete and recreate the `src\` directory.
- Expand the archive into `src\`.

---

### Linux / macOS (Bash)

From the repo root:

```bash
./scripts/extract.sh
```

Make sure the script is executable first:

```bash
chmod +x scripts/extract.sh
```

This will:

- Verify that `build/DuelingBatteries.wfs` exists.
- Strip the 16‑byte validation tail.
- Delete and recreate the `src/` directory.
- Expand the archive into `src/`.

---

## ✅ Round‑trip workflow

- **Build:** edit files in `src/` → run `build` → get `.wfs` in `build/` for Watch Face Studio.
- **Extract:** take `.wfs` from Watch Face Studio → run `extract` → update files in `src/` for Git.

---
