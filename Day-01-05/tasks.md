# Assignments
# Day 1: Linux User Setup with Non-Interactive Shell

## Requirements
The system administration team required the creation of a user account for a backup agent tool with a non-interactive shell on App Server 2.  
Create a user named `silvi` with a non-interactive shell on App Server 2.

**Requirement details:**
- Username: `silvi`
- Server: App Server 2
- Shell: Non-interactive (`/sbin/nologin`)

---

## Steps Performed
- Logged into App Server 2 from the jump server using SSH
- Created a user named `silvi` with a non-interactive shell
- Verified that the user was created successfully with the correct shell assigned

---

## Commands Used
```bash
# Login to App Server 2
ssh username@appserver02

# Create non-interactive user
sudo useradd -s /sbin/nologin silvi

# Check if user exists and view shell assignment
grep silvi /etc/passwd

# You should see output like:
# silvi:x:1001:1001::/home/silvi:/sbin/nologin
```

---

## Key Learnings
- System users should use non-interactive shells to block direct login access
- `/sbin/nologin` is the standard shell for service accounts
- Always validate user configuration after creation

## Note
What is a non-interactive shell?
`/sbin/nologin` prevents the user from logging in interactively (no SSH or terminal access), but the account can still be used for running services or processes. This is common for service accounts.

---