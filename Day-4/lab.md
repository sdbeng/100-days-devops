## Disable direct SSH root login on all app servers within the XYX datacenter

Let's disable direct SSH root login on all app servers. This is a common security best practice.
### The configuration:
You need to edit the SSH daemon configuration file: /etc/ssh/sshd_config
Steps to perform on EACH app server (stapp01, stapp02, stapp03):

- Step 1: SSH into each app server
```bash# Do this for App Server 1, 2, and 3
ssh user@stapp01
- Step 2: Edit the SSH config file
bashsudo vi /etc/ssh/sshd_config
 or use nano if you prefer
sudo nano /etc/ssh/sshd_config
```

- Step 3: Find and modify the PermitRootLogin setting**

Look for the line:
```
#PermitRootLogin yes
```

Change it to:
```
PermitRootLogin no
Make sure to:

Remove the # (uncomment it)
Change yes to no

- Step 4: Restart the SSH service
bashsudo systemctl restart sshd
- Step 5: Verify the change
bash# Check the configuration
sudo grep "^PermitRootLogin" /etc/ssh/sshd_config

# Should output: PermitRootLogin no

# Verify SSH service is running
sudo systemctl status sshd
Repeat for all three app servers!
Quick tip - Using sed for faster editing:
bash# Backup the config first
sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak

# Make the change with sed
sudo sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
# OR if it's already uncommented:
sudo sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Restart SSH
sudo systemctl restart sshd