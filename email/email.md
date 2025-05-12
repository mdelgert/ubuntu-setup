
```x-sh
#!/bin/bash

# Email configuration
RECIPIENT="recipient@example.com"
SUBJECT="Test Email from Bash Script"
BODY="This is a test email sent from a bash script on $(date)."
FROM="your_email@gmail.com"

# Send email using ssmtp
echo -e "To: $RECIPIENT\nFrom: $FROM\nSubject: $SUBJECT\n\n$BODY" | /usr/sbin/ssmtp $RECIPIENT

# Check if email was sent successfully
if [ $? -eq 0 ]; then
    echo "Email sent successfully to $RECIPIENT"
else
    echo "Failed to send email"
    exit 1
fi
```

### Setup Instructions for Email Notifications Using `ssmtp` on Ubuntu

1. **Install `ssmtp`**:
   Run the following command to install `ssmtp`:
   ```bash
   sudo apt update
   sudo apt install ssmtp
   ```

2. **Configure `ssmtp`**:
   Edit the `ssmtp` configuration file to set up your SMTP server (e.g., Gmail):
   ```bash
   sudo nano /etc/ssmtp/ssmtp.conf
   ```
   Add or modify the following lines (replace `your_email@gmail.com` and `your_app_password` with your Gmail address and app-specific password):
   ```
   mailhub=smtp.gmail.com:587
   AuthUser=your_email@gmail.com
   AuthPass=your_app_password
   UseSTARTTLS=YES
   FromLineOverride=YES
   ```

   **Note**: For Gmail, you need an **App Password** (not your regular password) if 2-factor authentication is enabled:
   - Go to your Google Account settings.
   - Navigate to **Security** > **2-Step Verification** >
   - Turn on 2-Step Verification
   - Go to https://myaccount.google.com/apppasswords
   - Generate a new app password for "Mail" and use it in the `AuthPass` field.

3. **Set Permissions**:
   Ensure the `ssmtp.conf` file is secure:
   ```bash
   sudo chmod 640 /etc/ssmtp/ssmtp.conf
   sudo chown root:mail /etc/ssmtp/ssmtp.conf
   ```

4. **Test the Script**:
   - Save the provided script as `email_notification.sh`.
   - Update the `RECIPIENT`, `FROM`, `SUBJECT`, and `BODY` variables in the script.
   - Make the script executable:
     ```bash
     chmod +x email_notification.sh
     ```
   - Run the script:
     ```bash
     ./email_notification.sh
     ```

5. **Troubleshooting**:
   - If the email fails, check the `ssmtp` logs:
     ```bash
     sudo tail -f /var/log/mail.log
     ```
   - Ensure your Gmail account allows less secure apps or use an App Password.
   - Verify your ISP allows outbound connections on port 587 (most do for Gmail’s SMTP).

### Why `ssmtp`?
- **Simple**: Minimal configuration compared to full mail servers like Postfix.
- **Reliable**: Uses established SMTP servers (e.g., Gmail), avoiding ISP blocks on port 25.
- **Lightweight**: Ideal for scripts on Ubuntu systems.

### Notes
- Replace `your_email@gmail.com` with your actual email and `recipient@example.com` with the recipient’s email.
- If you use another email provider, adjust the `mailhub` and port (e.g., `smtp-mail.outlook.com:587` for Outlook).
- Test the script in a safe environment first to avoid spamming or account issues.