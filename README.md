# Zoom Installer (Arch / Garuda / Manjaro)

Unofficial installer for **Zoom Meeting** on Arch-based Linux distributions.

Неофициальный установщик **Zoom Meeting** для дистрибутивов на базе Arch Linux.

---

## ✨ Features / Возможности

- ✅ Fetches the **latest Zoom build** directly from Zoom
- ✅ Verifies integrity via **SHA256 checksum**
- ✅ Installs binaries into **`/opt/zoom`**
- ✅ Creates a convenient **`zoom`** launcher in `*/usr/local/bin*`
- ✅ Installs **.desktop launcher** and application icon
- ✅ Applies **Chrome-style sandbox** fix for better compatibility
- ✅ **Idempotent:** re-running the installer updates Zoom Meeting to the latest version

---

## 📂 Repository

GitHub: https://github.com/Esko1m/zoom-installer

---

## 🇬🇧 INSTALL / UPDATE

### 1. Clone the repository

```bash
git clone https://github.com/Esko1m/zoom-installer.git
cd zoom-installer
```

### 2. Make the installer executable

```bash
chmod +x zoom-installer.sh
```

### 3. Run the installer

```bash
./zoom-installer.sh
```

The script will:

- Fetch the latest Zoom Meeting package from Zoom
- Verify SHA256 checksum
- Install files into `/opt/zoom`
- Create a symlink `/usr/local/bin/zoom`
- Install desktop entries and icons
- Apply sandbox fixes if needed

### 4. Run Zoom Meeting

```bash
zoom
```

### 5. Uninstall

```bash
./zoom-installer.sh --uninstall
```

This will remove Zoom binaries, symlinks, and desktop entries installed by the script.

---

## ⚠️ Disclaimer

- This installer is **unofficial** and is **not affiliated with or endorsed by Zoom**.
- Use at your own risk. Always review shell scripts before running them with elevated privileges.
- The script aims to be safe and minimal, but you are responsible for your own system.

---

## 🛠 Support / Поддержка

If you find a bug or have a feature request:

- Open an issue in the repository: https://github.com/Esko1m/zoom-installer/issues

Если вы нашли баг или хотите предложить улучшение:

- Создайте issue в репозитории: https://github.com/Esko1m/zoom-installer/issues

Contributions, pull requests, and feedback are welcome! 
