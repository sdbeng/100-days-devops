## Create a user named gio on App Server 1 in South Datacenter. Set the expiry date to 2024-02-17, ensuring the user is created in lowercase as per standard protocol.

Step 1: SSH to App Server 1
```bash
ssh user@stapp01

Step 2: Create the user with expiry date
```bash
sudo useradd -e 2024-02-17 gio
### Breaking down the command:
useradd - creates a new user
-e 2024-02-17 - sets account expiration date (format: YYYY-MM-DD)
gio - username (already lowercase ✓)

Step 3: Verification
```bash# Check if user exists
grep gio /etc/passwd

# Verify the expiry date
sudo chage -l gio

# Look for the line:
# Account expires: Feb 17, 2024
Alternative verification:
bash# Check expiry with a more compact command
sudo chage -l gio | grep "Account expires"
You should see the expiration date set to February 17, 2024.