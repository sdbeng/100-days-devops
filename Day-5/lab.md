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

### troublshooting
When you run these checks? The `mount | grep /tmp` output will be most telling.
I can see is owned by and eXecute by root user

There's the issue. The file is owned by root and only root has execute permissions, even though you added +x.
Check the exact permissions:
bashls -l /tmp/xfusioncorp.sh
```

You're probably seeing something like:
```
-rwx------ 1 root root ... /tmp/xfusioncorp.sh
This means only the owner (root) can execute it.
Fix it - Add execute permissions for ALL users:
bashsudo chmod 755 /tmp/xfusioncorp.sh
# or
sudo chmod a+rx /tmp/xfusioncorp.sh
Breaking it down:

755 = rwxr-xr-x (owner: rwx, group: r-x, others: r-x)
a+rx = add read and execute for all (owner, group, others)

Verification:
bashls -l /tmp/xfusioncorp.sh

# Should now show:
# -rwxr-xr-x 1 root root ... /tmp/xfusioncorp.sh
#  ^^^ ^ ^ ^
#  all three groups have execute (x)
Now try executing it:
bash/tmp/xfusioncorp.sh
# or
./tmp/xfusioncorp.sh
The key is making sure all three permission groups (owner/group/others) have the execute bit set. The 755 permissions are standard for scripts that everyone should be able to execute.