# Dueling Batteries

A Wear OS watch face showing watch and phone battery levels, weather and heart rate — packaged in [Watch Face Format](https://developer.android.com/training/wearables/wff).

This repository includes Node‑based helper scripts to **build** and **extract** Watch Face Studio project files.

---

## 📂 Project Structure

```
/  # repository root
├── build/    # generated .wfs file
├── src/      # Watch Face Studio project source files
└── scripts/  # Node/TypeScript build + extract utilities
```

---

## Requirements

- [Node.js](https://nodejs.org)
- [npm](https://www.npmjs.com/) (bundled with Node)

---

## 🚀 Build Workflow

From the repo root:

```
npm run build
```

This command will:

- Remove and recreate the `build/` directory.
- Zip the contents of `src/` using Node + TypeScript.
- Append the required 16‑byte validation tail (`normal_watchface`).
- Output `DuelingBatteries.wfs` into the `build/` directory.

You can then open the generated `.wfs` file in
[Watch Face Studio](https://developer.samsung.com/watch-face-studio/overview.html).

---

## 🔄 Extract Workflow

From the repo root:

```
npm run extract
```

This will:

- Verify that `build/DuelingBatteries.wfs` exists.
- Strip the 16‑byte validation tail.
- Remove and recreate the `src/` directory.
- Unzip the archive contents into `src/`.

This gives you a clean, Git‑friendly version of the project.

---

## 🔁 Round‑trip Workflow

1. **Build** → run `npm run build` to generate a `.wfs` file for Watch Face Studio.
2. **Modify** → open the `.wfs` in Watch Face Studio, make changes, save.
3. **Extract** → run `npm run extract` to sync the updated `.wfs` back into `src/`.
