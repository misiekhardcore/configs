#!/bin/bash
# Pre-reinstall backup script
# Run as root or with sudo

BACKUP_DEST="/backup"  # Change to your external drive or remote location
TIMESTAMP=$(date '+%Y%m%d-%H%M%S')
BACKUP_DIR="${BACKUP_DEST}/ubuntu-backup-${TIMESTAMP}"

mkdir -p "$BACKUP_DIR"

echo "Starting backup to $BACKUP_DIR"

# 1. User home directories
echo "Backing up home directories..."
sudo cp -a /home/ "$BACKUP_DIR/home/"
sudo cp -a /root/ "$BACKUP_DIR/root/" 2>/dev/null || true

# 2. Package lists
echo "Saving package lists..."
dpkg --get-selections > "$BACKUP_DIR/dpkg-selections.txt"
apt-mark showmanual > "$BACKUP_DIR/manually-installed.txt"
apt list --installed 2>/dev/null > "$BACKUP_DIR/apt-installed.txt"

# 3. Important /etc files
echo "Backing up /etc..."
sudo cp -a /etc/ "$BACKUP_DIR/etc/"

# 4. Cron jobs
echo "Backing up cron jobs..."
for user in $(cut -d: -f1 /etc/passwd); do
    crontab -l -u "$user" 2>/dev/null > "$BACKUP_DIR/cron-${user}.txt"
done

# 5. SSL certificates and keys
echo "Backing up SSL certificates..."
sudo cp -a /etc/ssl/ "$BACKUP_DIR/ssl/" 2>/dev/null || true
sudo cp -a /etc/letsencrypt/ "$BACKUP_DIR/letsencrypt/" 2>/dev/null || true

# 6. SSH host keys (to preserve server fingerprint)
echo "Backing up SSH host keys..."
sudo mkdir -p "$BACKUP_DIR/ssh-host-keys"
sudo cp /etc/ssh/ssh_host_* "$BACKUP_DIR/ssh-host-keys/"

# 7. Database dumps (if databases exist)
if command -v mysqldump &>/dev/null; then
    echo "Dumping MySQL databases..."
    sudo mysqldump --all-databases > "$BACKUP_DIR/mysql-all-databases.sql" 2>/dev/null || true
fi

if command -v pg_dumpall &>/dev/null; then
    echo "Dumping PostgreSQL databases..."
    sudo -u postgres pg_dumpall > "$BACKUP_DIR/postgresql-all.sql" 2>/dev/null || true
fi

# 8. Docker volumes (if Docker is installed)
if command -v docker &>/dev/null; then
    echo "Listing Docker volumes..."
    docker volume ls > "$BACKUP_DIR/docker-volumes.txt"
    # For a full backup, you would need to backup each volume individually
fi

# 9. List all custom systemd units
sudo find /etc/systemd/system -name "*.service" -o -name "*.timer" -o -name "*.mount" | \
    sudo xargs ls -la > "$BACKUP_DIR/custom-systemd-units.txt" 2>/dev/null

# 10. Installed snap packages
snap list 2>/dev/null > "$BACKUP_DIR/snap-packages.txt"

echo ""
echo "Backup complete: $BACKUP_DIR"
echo "Backup size: $(du -sh $BACKUP_DIR | cut -f1)"
