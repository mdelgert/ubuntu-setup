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