#!/bin/bash

# Synology NAS Cleanup Script - Delete files older than 90 days
# Description: Safely removes files older than 90 days from specified directory
# Usage: ./cleanup_old_files.sh [TARGET_FOLDER] [DRY_RUN]
# Example: ./cleanup_old_files.sh "/volume1/backup" false

# Configuration
TARGET_FOLDER="${1:-/volume1/data}"  # Change default path as needed
DRY_RUN="${2:-false}"  # Set to 'true' for testing without deleting
DAYS_OLD=90
LOG_FILE="/var/log/cleanup_old_files.log"
SCRIPT_LOG="/tmp/cleanup_$(date +%Y%m%d_%H%M%S).log"

# Color codes for logging
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log messages
log_message() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[${timestamp}] [${level}] ${message}" | tee -a "$SCRIPT_LOG"
}

# Function to display usage
usage() {
    echo "Usage: $0 [TARGET_FOLDER] [DRY_RUN]"
    echo ""
    echo "Arguments:"
    echo "  TARGET_FOLDER - Path to folder to clean (default: /volume1/data)"
    echo "  DRY_RUN       - true/false to preview deletions without removing (default: false)"
    echo ""
    echo "Examples:"
    echo "  $0 '/volume1/backup' true    # Test run for /volume1/backup"
    echo "  $0 '/volume1/backup' false   # Actually delete from /volume1/backup"
    exit 1
}

# Main script
main() {
    log_message "INFO" "========================================="
    log_message "INFO" "Starting cleanup script"
    log_message "INFO" "Target folder: $TARGET_FOLDER"
    log_message "INFO" "Days to keep: $DAYS_OLD"
    log_message "INFO" "Dry run mode: $DRY_RUN"
    log_message "INFO" "========================================="
    
    # Validate folder exists
    if [ ! -d "$TARGET_FOLDER" ]; then
        log_message "ERROR" "Target folder does not exist: $TARGET_FOLDER"
        exit 1
    fi
    
    # Check write permissions
    if [ ! -w "$TARGET_FOLDER" ]; then
        log_message "ERROR" "No write permission for: $TARGET_FOLDER"
        exit 1
    fi
    
    # Get file count before
    local count_before=$(find "$TARGET_FOLDER" -type f -mtime +$DAYS_OLD 2>/dev/null | wc -l)
    log_message "INFO" "Files found older than $DAYS_OLD days: $count_before"
    
    if [ $count_before -eq 0 ]; then
        log_message "INFO" "No files to delete. Cleanup completed."
        exit 0
    fi
    
    # List files that will be deleted
    log_message "INFO" "Files to be deleted:"
    find "$TARGET_FOLDER" -type f -mtime +$DAYS_OLD -print | while read file; do
        local file_age=$(find "$file" -type f -printf '%T@\n' 2>/dev/null | awk '{print int((systime()-$1)/86400)}')
        log_message "INFO" "  - $file (${file_age} days old)"
    done
    
    # Perform deletion or dry run
    if [ "$DRY_RUN" = "true" ]; then
        log_message "WARN" "DRY RUN MODE - No files will be deleted"
    else
        log_message "INFO" "Deleting files..."
        local deleted=0
        local errors=0
        
        find "$TARGET_FOLDER" -type f -mtime +$DAYS_OLD -delete 2>/dev/null
        
        # Verify deletion
        local count_after=$(find "$TARGET_FOLDER" -type f -mtime +$DAYS_OLD 2>/dev/null | wc -l)
        deleted=$((count_before - count_after))
        
        if [ $? -eq 0 ]; then
            log_message "INFO" "Successfully deleted $deleted files"
        else
            log_message "ERROR" "Some files could not be deleted"
            errors=$((errors + 1))
        fi
    fi
    
    # Clean up empty subdirectories (optional)
    log_message "INFO" "Cleaning up empty directories..."
    find "$TARGET_FOLDER" -type d -empty -delete 2>/dev/null
    
    log_message "INFO" "========================================="
    log_message "INFO" "Cleanup script completed"
    log_message "INFO" "Log saved to: $SCRIPT_LOG"
    log_message "INFO" "========================================="
}

# Input validation
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    usage
fi

# Run main function
main
