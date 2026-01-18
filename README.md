# MPV Add to Playlist (Windows Context Menu)
**[English]** | [中文指南](#中文指南)

A lightweight set of scripts to add an **"Add to mpv playlist"** option to the Windows right-click context menu.

Unlike the default "Open with...", this script checks if MPV is already running:
1.  **If MPV is running:** It appends the video to the current playlist via IPC (Named Pipe) without stealing focus.
2.  **If MPV is NOT running:** It starts a new MPV instance with the selected file.

## 📂 File Structure
Ensure all these files are in the **same directory** as `mpv.exe`:

*   `mpv.exe` (Your original MPV player)
*   `mpv-add.ps1` (The core logic script)
*   `register-context-menu.bat` (Installer)
*   `unregister-context-menu.bat` (Uninstaller)

## ⚙️ Prerequisites (Recommended)
For the best experience, enable the IPC socket in your MPV configuration.
Add the following line to your `mpv.conf` (usually located in `portable_config` or `%APPDATA%\mpv\`):

```ini
input-ipc-server=mpvsocket
```
*Note: The script attempts to start MPV with this socket enabled, but adding it to the config ensures it works even if you start MPV manually first.*

## 🚀 Installation
1.  Download or copy the scripts into your MPV folder.
2.  Right-click `register-context-menu.bat` and select **Run as administrator**.
3.  Follow the prompts. A success message will appear.

## 🗑️ Uninstallation
1.  Right-click `unregister-context-menu.bat` and select **Run as administrator**.
2.  The menu item will be removed from your registry.

## 🔧 Troubleshooting
*   **"Administrator privileges required"**: You must run the `.bat` files as Admin to modify the Registry.
*   **Menu does nothing**: Check if the path to `mpv.exe` in the registry matches reality. Re-running the installer updates the path.
*   **PowerShell Window Flashes**: This is normal. The script runs with `-WindowStyle Hidden` to minimize disruption.

---

# <a id="中文指南"></a>中文指南
# Windows系统鼠标右键添加到 MPV 播放列表

这是一个轻量级的脚本工具，用于在 Windows 右键菜单中添加 **"Add to mpv playlist"**（添加到 MPV 播放列表）选项。

它比系统默认的“打开方式”更智能：
1.  **如果 MPV 正在运行**：它会通过 IPC（命名管道）将视频追加到当前播放列表，且不会抢占窗口焦点。
2.  **如果 MPV 未运行**：它会自动启动一个新的 MPV 进程并播放文件。

## 📂 文件结构
请确保以下文件与您的 `mpv.exe` 位于 **同一目录**：

*   `mpv.exe` (您的 MPV 主程序)
*   `mpv-add.ps1` (核心逻辑脚本)
*   `register-context-menu.bat` (安装脚本 - 右键管理员运行)
*   `unregister-context-menu.bat` (卸载脚本 - 右键管理员运行)

## ⚙️ 前置配置 (推荐)
为了获得最佳体验，建议在 `mpv.conf` 配置文件中开启 IPC 支持（通常位于 `portable_config` 或 `%APPDATA%\mpv\` 目录下）：

```ini
input-ipc-server=mpvsocket
```
*注：虽然脚本在启动 MPV 时会尝试强制开启此功能，但写入配置文件能确保您手动双击打开 MPV 时，脚本也能正常连接。*

## 🚀 安装方法
1.  下载脚本并放入 MPV 所在文件夹。
2.  鼠标右键点击 `register-context-menu.bat`，选择 **"以管理员身份运行"**。
3.  看到 "SUCCESS" 提示即表示安装成功。

## 🗑️ 卸载方法
1.  鼠标右键点击 `unregister-context-menu.bat`，选择 **"以管理员身份运行"**。
2.  脚本将自动清理相关的注册表项。

## 🔧 常见问题
*   **提示权限不足 (Administrator privileges required)**：必须以管理员身份运行 `.bat` 文件才能修改注册表。
*   **点击菜单无反应**：可能是 MPV 路径发生了变化。请在当前 MPV 目录下重新运行一次安装脚本以更新路径。
*   **PowerShell 窗口闪烁**：这是正常现象，脚本已配置为隐藏模式运行，窗口会瞬间消失。

---
*Created for personal use, shared for the community.*
