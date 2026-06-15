# ArgusOS Activation

Open-source Windows and Office activator featuring HWID, Ohook, and Online KMS activation methods.

## Quick Start (PowerShell) - الطريقة الصحيحة

**⚠️ Important:** Use `launcher.ps1` ONLY. Do NOT pipe `ArgusOS_AIO.cmd` directly through `iex`.

Run PowerShell as **Administrator** and execute:

```powershell
irm https://raw.githubusercontent.com/ar4us/ArgusOS-Activation/main/launcher.ps1 | iex
```

## Alternative: Direct Download

Download `ArgusOS_AIO.cmd` manually, then **right-click → Run as Administrator**.

## Activation Methods

| Option | Method | Target | Duration | Internet |
|--------|--------|--------|----------|----------|
| [1] | HWID | Windows 10/11 | Permanent | Yes |
| [2] | Ohook | Office (all versions) | Permanent | Yes |
| [3] | Online KMS | Windows + Office | 180 days (auto-renew) | Yes |

## Project Structure

```
ArgusOS-Activation/
├── ArgusOS_AIO.cmd      # Batch script (run via cmd.exe as admin)
├── launcher.ps1         # PowerShell launcher (use with irm | iex)
├── README.md
├── LICENSE
└── .gitignore
```

**How it works:** `launcher.ps1` downloads `ArgusOS_AIO.cmd` to a temp folder, then launches it via `cmd.exe` as Administrator. This is the correct way to run the script from PowerShell.

## How It Works

- **HWID** (option 1): Downloads and runs MAS HWID module to generate a digital license via GenuineTicket.xml
- **Ohook** (option 2): Downloads and runs MAS Ohook module to deploy custom sppc.dll for permanent Office activation
- **Online KMS** (option 3): Self-contained - installs GVLK keys, configures KMS server, activates, and creates auto-renewal task

## Requirements

- Windows 7 SP1 and above (Windows 10/11 for HWID)
- PowerShell (Full Language Mode)
- Administrator access
- Internet connection (for HWID/Ohook modules and Online KMS)

## Notes

- HWID and Ohook methods reference the [MAS](https://github.com/massgravel/Microsoft-Activation-Scripts) project for activation modules (GPL-3.0)
- Online KMS is fully self-contained in this script
- Always verify the URL before executing any script

## License

GPL-3.0
