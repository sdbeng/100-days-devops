#!/bin/bash

# Day-1: Example Demonstration Script
# This script demonstrates basic Linux user and shell concepts

echo "=========================================="
echo "Day-1: Linux User and Shell Basics"
echo "=========================================="
echo ""

# 1. Current User Information
echo "1. Current User Information:"
echo "   Username: $(whoami)"
echo "   User ID: $(id -u)"
echo "   Group ID: $(id -g)"
echo "   Home Directory: $HOME"
echo "   Current Shell: $SHELL"
echo ""

# 2. Display all groups the user belongs to
echo "2. User Groups:"
groups
echo ""

# 3. Full user identification
echo "3. Detailed User Info:"
id
echo ""

# 4. Environment Variables
echo "4. Key Environment Variables:"
echo "   USER: $USER"
echo "   HOME: $HOME"
echo "   SHELL: $SHELL"
echo "   PATH: $PATH"
echo ""

# 5. List of users on the system
echo "5. System Users (first 10):"
echo "   Username:UserID:HomeDir:Shell"
head -10 /etc/passwd | while IFS=: read -r username password uid gid gecos home shell; do
    echo "   $username:$uid:$home:$shell"
done
echo ""

# 6. Available shells
echo "6. Available Shells on System:"
cat /etc/shells 2>/dev/null || echo "   /etc/shells not found"
echo ""

# 7. Check sudo access
echo "7. Sudo Access Check:"
if groups | grep -qE '\b(sudo|wheel)\b'; then
    echo "   ✓ User has potential sudo access (member of sudo/wheel group)"
else
    echo "   ✗ User is not in sudo/wheel group"
fi
echo ""

# 8. Interactive demo
echo "8. Interactive Shell Demo:"
read -p "   Enter your name: " name
echo "   Hello, $name! Welcome to Day-1 of DevOps learning!"
echo ""

# 9. Command execution demo
echo "9. Current Date and Time:"
date
echo ""

# 10. System information
echo "10. Basic System Information:"
echo "   Hostname: $(hostname)"
echo "   Kernel: $(uname -r)"
echo "   OS: $(uname -o)"
echo ""

echo "=========================================="
echo "Day-1 demonstration completed!"
echo "=========================================="
