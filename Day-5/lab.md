# grant executable permissions to xfusioncopr.sh script for all users on App Server 2

Step 1: SSH to App Server 2
```bash
ssh user@stapp02
```
Step 2: Add executable permissions for all users
```bash
sudo chmod +x /tmp/xfusioncorp.sh
```
OR, to be more explicit (same result):
```bash
sudo chmod a+x /tmp/xfusioncorp.sh
```
Breaking it down:

chmod - change file mode/permissions
+x - add executable permission
a+x - add executable for all users (owner, group, others)
/tmp/xfusioncorp.sh - the file path

Verification:
```
ls -l /tmp/xfusioncorp.sh
```
Test that it's executable:
Try to execute it (just to verify permissions work)
```
/tmp/xfusioncorp.sh
```
The key is seeing x permissions in all three permission groups (owner/group/others).

## oh i got an error!
Permission denied even with execute bits set. Let's troubleshoot this.