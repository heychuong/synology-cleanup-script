# Synology Cleanup Script

Automated shell script for **Synology NAS (DSM 7)** to delete files older than x days.

## ✨ Features

- ✅ Automatically delete files older than x days (configurable)
- ✅ **Dry-run mode** for safe testing before actual deletion
- ✅ Detailed logging with timestamps (saved to File Station)
- ✅ Automatic cleanup of empty directories
- ✅ Permission validation before execution
- ✅ Easy integration with Task Scheduler
- ✅ Comprehensive error handling

## 🚀 Quick Start

### 1. Upload Script to Your NAS

Download `cleanup_old_files.sh` and upload it to your Synology NAS (e.g., `/volume1/scripts/`)

### 2. Test with Dry Run

```bash
/volume1/scripts/cleanup_old_files.sh "/volume1/your-folder" true
```

This shows what would be deleted **without actually deleting**.

### 3. Run Actual Cleanup

```bash
/volume1/scripts/cleanup_old_files.sh "/volume1/your-folder" false
```

### 4. Automate with Task Scheduler

See [SYNOLOGY_SETUP_GUIDE.md](SYNOLOGY_SETUP_GUIDE.md) for step-by-step Task Scheduler setup.

## 📖 Usage

```bash
./cleanup_old_files.sh [TARGET_FOLDER] [DRY_RUN]
```

### Arguments

| Argument | Description | Example |
|----------|-------------|---------|
| `TARGET_FOLDER` | Path to folder to clean | `/volume1/backup` |
| `DRY_RUN` | `true` = test mode, `false` = actual deletion | `true` or `false` |

### Examples

```bash
# Test run - preview files to be deleted
./cleanup_old_files.sh "/volume1/backup" true

# Actual deletion
./cleanup_old_files.sh "/volume1/backup" false

# Delete from multiple folders
./cleanup_old_files.sh "/volume1/downloads" false
./cleanup_old_files.sh "/volume1/temp" false
```

## 🔧 Configuration

### Change Days to Keep

Edit the script and modify this line:

```bash
DAYS_OLD=90  # Change to desired number of days
```

### Change Log Location

The script saves logs to: `/volume1/logs/cleanup_script/`

You can view logs directly in **File Station** → `volume1` → `logs` → `cleanup_script`

## 📋 What Gets Logged

Each cleanup creates a log file with:
- ✓ Start/end times
- ✓ Number of files found and deleted
- ✓ List of deleted files with age
- ✓ Any errors encountered

Example log entry:
```
[2025-05-11 02:00:15] [INFO] Starting cleanup script
[2025-05-11 02:00:15] [INFO] Target folder: /volume1/backup
[2025-05-11 02:00:15] [INFO] Files found older than 90 days: 5
[2025-05-11 02:00:21] [INFO]   - /volume1/backup/file1.bak (95 days old)
[2025-05-11 02:00:22] [INFO] Successfully deleted 5 files
```

## 📋 Requirements

- **Synology NAS** with DSM 7.2 (or later)
- **Bash shell** (included by default)
- **Write permissions** on target folder
- **SSH enabled** (optional, for command-line testing)

## ⚙️ Setup Instructions

For detailed setup with screenshots:
👉 **See [SYNOLOGY_SETUP_GUIDE.md](SYNOLOGY_SETUP_GUIDE.md)**

Topics covered:
- Transferring script to your NAS
- Testing safely with dry-run mode
- Creating Task Scheduler jobs
- Automating daily/weekly/monthly cleanup
- Viewing logs in File Station
- Troubleshooting common issues

## ⚠️ Important Safety Notes

- **Always backup important data** before using
- **Test with dry-run mode first** to see what will be deleted
- Files are deleted permanently (not to Trash)
- Ensure sufficient disk space for script operations

## 🐛 Troubleshooting

### Task won't run in Task Scheduler
- Verify script path is correct
- Check file permissions: `chmod 755 /path/to/cleanup_old_files.sh`
- Ensure user has write permissions on target folder
- Check Task Scheduler logs in DSM

### No files deleted but script runs successfully
- Verify files are actually older than 90 days
- Check target folder path is correct
- Review log file for details

### Permission denied error
```bash
chmod 755 /volume1/scripts/cleanup_old_files.sh
```

For more troubleshooting, see [SYNOLOGY_SETUP_GUIDE.md](SYNOLOGY_SETUP_GUIDE.md#troubleshooting).

## 📚 Files Included

```
synology-cleanup-script/
├── README.md                        # This file
├── cleanup_old_files.sh            # Main script
├── SYNOLOGY_SETUP_GUIDE.md        # Detailed setup guide
└── LICENSE                         # MIT License
```

## 🔄 Typical Automation Schedule

Popular setups:

| Schedule | Use Case |
|----------|----------|
| **Daily at 2 AM** | High-volume temp folders |
| **Weekly (Sunday)** | Regular backups |
| **Monthly (1st)** | Large archives |

## 💡 Use Cases

- Clean up old backup files
- Remove temporary downloads
- Archive old logs
- Free up space automatically
- Manage large media libraries

## 📜 License

MIT License - Feel free to use, modify, and share!

## 🤝 Contributing

Found a bug or have an improvement?
- Create an Issue
- Submit a Pull Request
- Share your feedback

## 📞 Support

Having issues? Check:
1. [SYNOLOGY_SETUP_GUIDE.md](SYNOLOGY_SETUP_GUIDE.md) - Detailed instructions
2. Troubleshooting section above
3. Log files in `/volume1/logs/cleanup_script/`

## 🎯 Roadmap

Future enhancements:
- [ ] Support for different file patterns
- [ ] Email notifications on completion
- [ ] Disk space savings report
- [ ] Multiple folder batch processing

## ⭐ If you find this useful

- Star ⭐ this repository
- Share with other Synology users
- Open an issue to report bugs
- Suggest improvements

---

**Last Updated:** May 2025
**Tested On:** DSM 7.2.2-72806 Update 5
