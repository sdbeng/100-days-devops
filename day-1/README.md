# Day 1: Linux Interactive Shell with User Setup

## Overview
Welcome to Day 1 of the 100 Days DevOps Challenge! Today's focus is on understanding Linux user management and interactive shell scripting - fundamental skills for any DevOps engineer.

## Learning Objectives
By the end of this exercise, you will understand:
- How to create and manage Linux users
- Interactive vs non-interactive shell scripting
- User permissions and groups
- Sudo/root access management
- Best practices for user setup automation

## Prerequisites
- Basic Linux command-line knowledge
- Access to a Linux system (or Docker)
- Root/sudo privileges

## Contents

### 1. Interactive User Setup Script (`setup_user.sh`)
A comprehensive Bash script that demonstrates:
- User input validation
- Interactive prompts
- Password management
- Group assignments
- Sudo privilege configuration
- Both interactive and non-interactive modes

### 2. Dockerfile
A Docker environment demonstrating:
- User creation during image build
- Different user types (with/without home directory)
- Group management
- Permission setup

**Security Note**: This Dockerfile contains hard-coded passwords for **DEMO/LEARNING purposes ONLY**. Never use hard-coded passwords in production. For production environments, use secrets management, environment variables, or SSH key-based authentication.

## Quick Start

### Option 1: Run Locally (Linux/Mac with sudo)

```bash
# Make the script executable
chmod +x setup_user.sh

# Run in interactive mode (recommended - prompts for password securely)
sudo ./setup_user.sh

# Or use non-interactive mode without password (will need to set later)
sudo ./setup_user.sh -u newuser -f "New User" -s

# WARNING: Passing passwords via command line is insecure
# Only use for testing/learning - password visible in process list
sudo ./setup_user.sh -u testuser -f "Test User" -p "InsecurePassword123"
```

### Option 2: Use Docker

```bash
# Build the Docker image
docker build -t day1-user-setup .

# Run the container
docker run -it day1-user-setup

# Inside the container, you can explore:
id                    # View current user info
groups                # View user groups
cat /etc/passwd       # View all users
```

### Option 3: Run as Root User in Docker (for script testing)

```bash
# Run container as root to test the setup script
docker run -it --user root day1-user-setup /bin/bash

# Inside the container
setup_user.sh         # Run in interactive mode
```

## Script Usage

### Interactive Mode
Run the script without arguments for an interactive experience:

```bash
sudo ./setup_user.sh
```

You'll be prompted for:
1. Username
2. Full name
3. Home directory preference
4. Shell selection
5. Password
6. Additional groups
7. Sudo privileges

### Non-Interactive Mode
Pass arguments for automation:

```bash
# Basic user creation
sudo ./setup_user.sh -u john -f "John Doe"

# With password and sudo access
sudo ./setup_user.sh -u admin -f "Admin User" -p "securepass" -s

# With custom groups
sudo ./setup_user.sh -u developer -f "Dev User" -g "docker,developers,www-data"

# Complete setup
sudo ./setup_user.sh -u devops -f "DevOps Engineer" -p "pass123" -g "docker,sudo" -s
```

### Command Options
```
-u USERNAME    Username to create (required in non-interactive mode)
-f FULLNAME    Full name of the user
-p PASSWORD    Password for the user
-g GROUPS      Comma-separated list of groups
-s             Grant sudo privileges
-h             Show help message
```

## Key Concepts Explained

### 1. User Management
Linux users are defined in `/etc/passwd` with attributes like:
- Username
- User ID (UID)
- Group ID (GID)
- Home directory
- Default shell

```bash
# View user information
id username
getent passwd username
cat /etc/passwd | grep username
```

### 2. Groups
Users can belong to multiple groups for access control:
- Primary group: User's main group
- Supplementary groups: Additional groups for permissions

```bash
# View groups
groups username
id username

# View all groups
cat /etc/group
```

### 3. Home Directory
- Typically located at `/home/username`
- Contains user's personal files and configurations
- Can be created with `-m` flag in `useradd`

### 4. Shell
The command interpreter for the user:
- `/bin/bash` - Most common (Bourne Again Shell)
- `/bin/sh` - POSIX shell
- `/bin/zsh` - Z Shell (feature-rich)
- `/usr/bin/fish` - Friendly Interactive Shell

### 5. Sudo Access
Allows users to execute commands as root:
- Add user to `sudo` group (Debian/Ubuntu)
- Add user to `wheel` group (RHEL/CentOS)

```bash
# Grant sudo access
usermod -aG sudo username

# Test sudo access
sudo -l -U username
```

## Important Commands

### User Creation
```bash
# Create user with home directory
useradd -m -s /bin/bash username

# Create user without home directory
useradd -M username

# Create user with custom UID
useradd -u 1500 username
```

### User Modification
```bash
# Add user to group
usermod -aG groupname username

# Change user shell
usermod -s /bin/zsh username

# Change user home directory
usermod -d /new/home username
```

### Password Management
```bash
# Set password interactively
passwd username

# Set password non-interactively
echo "username:password" | chpasswd

# Force password change on next login
passwd -e username
```

### User Deletion
```bash
# Delete user
userdel username

# Delete user and home directory
userdel -r username
```

### Information Commands
```bash
# Current user
whoami

# User ID and groups
id

# List all users
cat /etc/passwd

# List logged-in users
who
w

# Last login information
last
lastlog
```

## Security Best Practices

### Critical Security Notes for This Exercise

**⚠️ IMPORTANT**: This exercise uses simplified security practices for **LEARNING PURPOSES ONLY**. Never use these practices in production:

1. **Hard-coded Passwords**: The Dockerfile contains hard-coded passwords - NEVER do this in production
2. **Command-line Passwords**: The `-p` flag exposes passwords in process lists - use interactive mode instead
3. **Demo Environment**: These scripts are designed for local learning, not production systems

### Production-Ready Security Practices

1. **Strong Passwords**: Always use strong, unique passwords (minimum 12 characters, mix of types)
2. **Principle of Least Privilege**: Only grant necessary permissions
3. **Password Management**: 
   - Never pass passwords via command line
   - Use secure password managers
   - Implement proper secrets management (HashiCorp Vault, AWS Secrets Manager, etc.)
4. **SSH Key Authentication**: Prefer SSH keys over passwords for remote access
5. **Regular Audits**: Review user accounts regularly
6. **Disable Unused Accounts**: Lock or remove accounts that aren't needed
7. **Sudo Over Root**: Use sudo for elevated privileges instead of direct root login
8. **Password Policies**: Implement password aging and complexity requirements
9. **Multi-Factor Authentication**: Use MFA whenever possible
10. **Audit Logging**: Enable and monitor authentication logs

```bash
# Lock user account
passwd -l username

# Unlock user account
passwd -u username

# Set password expiry
chage -M 90 username

# View password status
passwd -S username
```

## Troubleshooting

### Permission Denied
- Ensure you're running with sudo/root privileges
- Check file permissions: `ls -l`

### User Already Exists
- Check existing users: `cat /etc/passwd | grep username`
- Choose a different username or modify existing user

### Group Doesn't Exist
- List available groups: `cat /etc/group`
- Create group first: `groupadd groupname`

### Shell Not Available
- Check available shells: `cat /etc/shells`
- Install required shell package

## Exercise Challenges

1. **Basic**: Create 3 different users with different shells
2. **Intermediate**: Create a user with custom UID, multiple groups, and sudo access
3. **Advanced**: Write a script to create 10 users with sequential names (user01-user10)
4. **Expert**: Implement user creation with SSH key setup and password-less sudo

## Additional Resources

- [Linux User Management Guide](https://www.linux.com/training-tutorials/how-manage-users-groups-linux/)
- [Bash Scripting Tutorial](https://www.shellscript.sh/)
- [sudo Configuration](https://www.sudo.ws/man/sudoers.man.html)

## Next Steps

After mastering Day 1, you'll be ready for:
- Day 2: SSH Configuration and Key Management
- Day 3: File Permissions and ACLs
- Day 4: Process Management and Systemd

## Contributing

Feel free to enhance this exercise by:
- Adding more features to the script
- Creating additional examples
- Improving documentation
- Reporting issues

---

**Happy Learning! 🚀**

*Part of the 100 Days DevOps Challenge*
