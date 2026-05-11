# Synology NAS Cleanup Script Setup Guide (DSM 7)

## Overview
This guide helps you set up the cleanup script to automatically delete files older than x days from a specified folder on your Synology NAS using the Task Scheduler.

---

## Step 1: Transfer the Script to Your NAS

### Option A: Using File Station (Easiest)
1. Open **File Station** in DSM
2. Navigate to `/home/[your-admin-username]` or create a dedicated folder like `/volume1/scripts`
3. Upload `cleanup_old_files.sh` to this location
4. Right-click the file → **Properties** → **Permissions**
5. Make sure the file is readable and executable for your user
6. Alternative: Set permissions via SSH with `chmod 755 /path/to/cleanup_old_files.sh`

### Option B: Using SSH (More Direct)
1. SSH into your Synology (enable SSH in Control Panel → Terminal & SNMP)
   ```bash
   ssh admin@your-nas-ip
   ```
2. Upload the script or create it:
   ```bash
   vi /volume1/scripts/cleanup_old_files.sh
   # Paste the script content, then save
   ```
3. Set execute permissions:
   ```bash
   chmod 755 /volume1/scripts/cleanup_old_files.sh
   ```

---

## Step 2: Test the Script

Before automating, test it with a dry run:

```bash
ssh admin@your-nas-ip

# Test run (won't delete anything)
/volume1/scripts/cleanup_old_files.sh "/volume1/backup" true

# Check the log output
tail -f /tmp/cleanup_*.log
```

Once you're confident, run with dry_run=false to actually delete files:
```bash
/volume1/scripts/cleanup_old_files.sh "/volume1/backup" false
```

---

## Step 3: Create Task Scheduler Task in DSM 7

### A. Open Task Scheduler
1. Go to **Control Panel** → **Task Scheduler**
2. Click **Create** → **Triggered Task** → **User-defined script**

### B. Configure the Task - General Tab
- **Task name:** `Delete Old Backup Files` (or your preferred name)
- **User:** Select a user with permissions to the target folder (usually admin or root)
- **Enabled:** Check this box
- **Notifications:** Optional (email notifications on task completion)

### C. Configure Schedule - Schedule Tab
Choose based on your preference:

**Option 1: Daily Schedule**
- Select **Daily**
- **Time:** Set to off-peak hours (e.g., 2:00 AM)
- **Every:** 1 day

**Option 2: Weekly Schedule**
- Select **Weekly**
- Choose days (e.g., Sunday)
- **Time:** Set to off-peak hours

**Option 3: Monthly Schedule**
- Select **Monthly**
- Choose date (e.g., 1st of month)
- **Time:** Set to off-peak hours

### D. Configure Task - Task Settings Tab
Paste this in the **Run command** field:

```bash
/volume1/scripts/cleanup_old_files.sh "/volume1/backup" false
```

**Important adjustments:**
- Replace `/volume1/backup` with your actual target folder path
- Change `/volume1/scripts/cleanup_old_files.sh` if you saved it elsewhere
- Use `true` instead of `false` for a dry-run test task

### E. Advanced Options
- **Send run details by email:** Enable if you want email notifications
- **Send result only if script terminates abnormally:** Recommended to reduce email spam

---

## Step 4: Verify and Monitor

### Check Task Status
1. In **Task Scheduler**, your task should appear in the list
2. Click on it to view:
   - Last execution time
   - Last execution result (Success/Failed)
   - Execution log

### View Logs
SSH into your NAS and check the latest cleanup log:
```bash
cat /tmp/cleanup_*.log
tail -f /tmp/cleanup_*.log  # Follow live logs
```

---

## Customization

### Change the Number of Days
Edit the script and modify this line:
```bash
DAYS_OLD=90  # Change 90 to your desired number of days
```

### Change the Target Folder
When creating the task, modify the command:
```bash
/volume1/scripts/cleanup_old_files.sh "/volume1/your-folder-path" false
```

### Multiple Cleanup Tasks
Create separate tasks for different folders:
- Task 1: `/volume1/scripts/cleanup_old_files.sh "/volume1/backup" false`
- Task 2: `/volume1/scripts/cleanup_old_files.sh "/volume1/temp" false`

---

## Important Considerations

### ⚠️ Backup First
- **Always backup important data** before running automated deletion scripts
- Test with dry run mode first (`true` parameter)

### Performance Impact
- Running during off-peak hours prevents performance degradation
- Large folder scans can take time; allow extra minutes in your schedule

### Permissions
- The script user must have read AND write permissions on the target folder
- Default admin user usually has sufficient permissions

### Logging
- Logs are created in `/tmp/cleanup_*.log` with timestamp
- Consider moving important logs to a persistent location:
  ```bash
  cp /tmp/cleanup_*.log /volume1/logs/
  ```

### Firewall/Network
- Ensure SSH is enabled if using remote testing (Control Panel → Terminal & SNMP)
- Task Scheduler runs locally without requiring network access

---

## Troubleshooting

### Task Won't Run
1. Check if Task Scheduler is enabled
2. Verify the script path is correct
3. Ensure the script has execute permissions (755)
4. Check user permissions for the target folder

### "Permission Denied" Error
```bash
# Re-set permissions
chmod 755 /volume1/scripts/cleanup_old_files.sh
chown admin:admin /volume1/scripts/cleanup_old_files.sh
```

### Script Runs but No Files Deleted
1. Check the log file for details
2. Verify the folder path is correct
3. Ensure files are actually older than 90 days
4. Run dry-run mode to see what would be deleted

### Finding Logs After Task Runs
In DSM Task Scheduler:
1. Right-click task → **View result**
2. Or SSH: `ls -lt /tmp/cleanup_*.log | head -1`

---

## Security Notes

- This script deletes files permanently (not to trash)
- Test thoroughly before scheduling automated runs
- Consider setting folder permissions to prevent accidental access
- Keep the script file protected from unauthorized modification

---

## Example Commands Reference

```bash
# Test run (shows what would be deleted)
/volume1/scripts/cleanup_old_files.sh "/volume1/backup" true

# Actual run (deletes files)
/volume1/scripts/cleanup_old_files.sh "/volume1/backup" false

# Delete files 60 days old instead of 90 (edit script first)
/volume1/scripts/cleanup_old_files.sh "/volume1/backup" false

# Check last cleanup log
cat /tmp/cleanup_*.log | tail -30
```

---

## Need Help?

If the script encounters errors:
1. Check `/tmp/cleanup_*.log` for detailed error messages
2. Verify folder path and permissions
3. Ensure bash is available (should be on DSM)
4. Test manually via SSH first before scheduling

Good luck with your cleanup automation!
