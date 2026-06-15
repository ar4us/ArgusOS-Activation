# ArgusOS Activation

Open-source Windows and Office activator featuring HWID, Ohook, and Online KMS activation methods.

## Quick Start (PowerShell)

Run PowerShell as **Administrator** and execute:

```powershell
irm https://raw.githubusercontent.com/ArgusOs/ArgusOS-Activation/main/launcher.ps1 | iex
```

Or download `ArgusOS_AIO.cmd` manually, right-click and **Run as Administrator**.

## Activation Methods

| Option | Method | Target | Duration | Internet |
|--------|--------|--------|----------|----------|
| [1] | HWID | Windows 10/11 | Permanent | Yes |
| [2] | Ohook | Office (all versions) | Permanent | Yes |
| [3] | Online KMS | Windows + Office | 180 days (auto-renew) | Yes |

## Project Structure

```
ArgusOS-Activation/
├── ArgusOS_AIO.cmd      # Main all-in-one activation script (run as admin)
├── launcher.ps1         # PowerShell launcher for irm | iex
├── README.md
├── LICENSE
└── .gitignore
```

## How to Upload to GitHub

1. Create a new repository on GitHub named `ArgusOS-Activation`
2. Run these commands in the project folder:

```powershell
cd "C:\Users\ArgusOs\Desktop\cluade\win act\ArgusOS-Activation"
git init
git add .
git commit -m "Initial release: ArgusOS Activation v1.0"
git remote add origin https://github.com/ArgusOs/ArgusOS-Activation.git
git branch -M main
git push -u origin main
```

3. After uploading, the PowerShell command will work (replace `ArgusOs` with your GitHub username):
```powershell
irm https://raw.githubusercontent.com/ArgusOs/ArgusOS-Activation/main/launcher.ps1 | iex
```

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

- HWID and Ohook methods reference the [MAS](https://github.com/massgravel/Microsoft-Activation-Scripts) project for activation modules
- Online KMS is fully self-contained in this script
- Always verify the URL before executing any script

## License

GPL-3.0
