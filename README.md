
# 🛡️ Automated Backup and Rotation with Google Drive Integration

This project provides a **complete automated backup solution** for Linux-based systems using `bash`, `rclone`, and `cron`. It supports **daily, weekly, and monthly backups**, with automatic rotation and cloud sync to **Google Drive**. Additionally, it includes features like **email alerts**, **quota checking**, and **on-demand restore**.

---

## 📂 Folder Structure

```
backup_project/
├── my_project_folder/             # Folder to back up
│   ├── file1.txt
│   └── file2.txt
├── project-backups/
│   ├── daily/                     # Daily backups
│   ├── weekly/                    # Weekly backups
│   └── monthly/                   # Monthly backups
├── daily_backup.sh               # Daily backup script
├── weekly_backup.sh              # Weekly backup script
├── monthly_backup.sh             # Monthly backup script
├── restore_backup.sh             # Restore script
├── check_quota.sh                # Google Drive quota script
├── backup_log.txt                # Central log file

```

## 🛠️ Tools & Technologies Used

| Tool         | Purpose                              |
|--------------|--------------------------------------|
| `bash`       | Scripting                             |
| `rclone`     | Google Drive sync                     |
| `cron`       | Automation scheduler                  |
| `msmtp`      | Email sending                         |
| `mailutils`  | Mail command interface                |
| `jq`         | JSON parsing (for quota check)        |
| `Telegram Bot API` | Optional notification alerts   |

---

## 🗂️ Backup Logic

### ✅ Daily Backup (`daily_backup.sh`)

- Backs up `my_project_folder/` to a ZIP file.
- Names it with `backup_<TIMESTAMP>.zip`
- Uploads to `project-backups/daily` on Google Drive.
- Keeps **last 7 daily backups** (old ones are auto-deleted).

### ✅ Weekly Backup (`weekly_backup.sh`)

- Creates ZIP: `MyProject_WEEKLY_<TIMESTAMP>.zip`
- Uploads to `project-backups/weekly` on Drive.
- Keeps **last 4 weekly backups**.

### ✅ Monthly Backup (`monthly_backup.sh`)

- Creates ZIP: `MyProject_MONTHLY_<TIMESTAMP>.zip`
- Uploads to `project-backups/monthly` on Drive.
- Keeps **last 12 monthly backups**.

Each script logs activity to `backup_log.txt` and sends alerts.

---

## 🔁 Restore Logic (`restore_backup.sh`)

- Prompts user for a file path on Google Drive.
- Downloads the ZIP to local machine.
- Unzips it to restore original folder.

---

## 📧 Email Alerts

- Uses `msmtp` + `mailutils`
- Setup at `~/.msmtprc` with Gmail app password.
- Alerts on backup success/failure.

> Example line:
```bash
echo "Weekly backup done" | mail -s "✅ Weekly Backup" your_email@gmail.com
```

---

## 📬 Telegram Alerts (Optional)

1. Create a bot via [@BotFather](https://t.me/BotFather)
2. Get `BOT_TOKEN` and your `CHAT_ID`
3. Add to your scripts:

```bash
curl -s -X POST https://api.telegram.org/bot<YOUR_BOT_TOKEN>/sendMessage   -d chat_id=<CHAT_ID>   -d text="✅ Daily backup successful: $ZIPFILE"
```

---

## 📏 Quota Monitoring (`check_quota.sh`)

- Checks used space of your Google Drive.
- Uses `rclone about gdrive:` and logs results to `quota_log.txt`.

---

## ⚙️ Automation with Cron

### Add this to crontab with `crontab -e`:

```
# Run daily at 1:00 AM
0 1 * * * /home/ubuntu/backup_project/daily_backup.sh

# Run weekly every Sunday at 2:00 AM
0 2 * * 0 /home/ubuntu/backup_project/weekly_backup.sh

# Run monthly on 1st at 3:00 AM
0 3 1 * * /home/ubuntu/backup_project/monthly_backup.sh
```

---

## 📌 Permissions

```bash
chmod +x daily_backup.sh weekly_backup.sh monthly_backup.sh restore_backup.sh check_quota.sh
chmod 600 ~/.msmtprc
```

---

## 🧪 Weekly Restore Testing

You can automate restore test by:

```bash
bash restore_backup.sh <<EOF
project-backups/weekly/MyProject_WEEKLY_<date>.zip
EOF
```

Or unzip manually to verify integrity.

---

## 📌 Setup Instructions (One-Time)

1. ✅ Install dependencies:
```bash
sudo apt update && sudo apt install zip unzip rclone msmtp mailutils jq -y
```

2. ✅ Configure `rclone` for Google Drive:
```bash
rclone config
# Choose 'n', then 'drive', follow browser auth
```

3. ✅ Create `~/.msmtprc` for Gmail:
```ini
defaults
auth on
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile ~/.msmtp.log

account gmail
host smtp.gmail.com
port 587
from your_email@gmail.com
user your_email@gmail.com
password your_app_password

account default : gmail
```

4. ✅ Test email:
```bash
echo "Test" | mail -s "Hello" your_email@gmail.com
```

 📎 Tools Used

- `rclone` – upload/download to Google Drive
- `cron` – schedule automation
- `zip` / `unzip` – compress and restore
- `msmtp` + `mail` – email reports
```
