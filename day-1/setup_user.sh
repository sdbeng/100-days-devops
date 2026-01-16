#!/bin/bash

# Day-1: Linux Interactive Shell with User Setup
# This script demonstrates interactive user creation and setup in Linux

set -e

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if script is run as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Function to validate username
validate_username() {
    local username=$1
    if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]{0,31}$ ]]; then
        return 1
    fi
    return 0
}

# Function to check if user exists
user_exists() {
    local username=$1
    if id "$username" &>/dev/null; then
        return 0
    fi
    return 1
}

# Function to create user
create_user() {
    local username=$1
    local fullname=$2
    local create_home=$3
    local shell=$4
    
    print_info "Creating user: $username"
    
    if [ "$create_home" = "yes" ]; then
        useradd -m -c "$fullname" -s "$shell" "$username"
        print_info "User created with home directory: /home/$username"
    else
        useradd -M -c "$fullname" -s "$shell" "$username"
        print_info "User created without home directory"
    fi
}

# Function to set user password
set_password() {
    local username=$1
    local password=$2
    
    if [ -n "$password" ]; then
        # Note: Passing passwords via command line is insecure in production.
        # For production use, consider: passwd, chpasswd with stdin, or PAM modules.
        echo "$username:$password" | chpasswd
        print_info "Password set for user: $username"
        print_warning "Password was passed via command line (visible in process list)"
    else
        passwd "$username"
    fi
}

# Function to add user to groups
add_to_groups() {
    local username=$1
    shift
    local groups=("$@")
    
    if [ ${#groups[@]} -gt 0 ]; then
        for group in "${groups[@]}"; do
            if getent group "$group" > /dev/null 2>&1; then
                usermod -aG "$group" "$username"
                print_info "Added user to group: $group"
            else
                print_warning "Group '$group' does not exist, skipping"
            fi
        done
    fi
}

# Function to setup sudo access
setup_sudo() {
    local username=$1
    local sudo_access=$2
    
    if [ "$sudo_access" = "yes" ]; then
        # Check which sudo group exists and add user to it
        if getent group sudo > /dev/null 2>&1; then
            usermod -aG sudo "$username"
            print_info "Sudo access granted to user: $username (added to sudo group)"
        elif getent group wheel > /dev/null 2>&1; then
            usermod -aG wheel "$username"
            print_info "Sudo access granted to user: $username (added to wheel group)"
        else
            print_warning "Could not add to sudo/wheel group - neither group exists"
        fi
    fi
}

# Function to display user info
display_user_info() {
    local username=$1
    
    print_info "User Information:"
    echo "----------------------------------------"
    id "$username"
    echo "----------------------------------------"
    echo "Home directory: $(getent passwd "$username" | cut -d: -f6)"
    echo "Shell: $(getent passwd "$username" | cut -d: -f7)"
    echo "Groups: $(groups "$username")"
    echo "----------------------------------------"
}

# Main interactive function
interactive_setup() {
    echo "========================================"
    echo "  Linux User Setup - Interactive Mode  "
    echo "========================================"
    echo ""
    
    # Get username
    while true; do
        read -p "Enter username: " username
        
        if [ -z "$username" ]; then
            print_error "Username cannot be empty"
            continue
        fi
        
        if ! validate_username "$username"; then
            print_error "Invalid username. Use only lowercase letters, numbers, underscore, and hyphen"
            continue
        fi
        
        if user_exists "$username"; then
            print_error "User '$username' already exists"
            read -p "Do you want to modify this user? (yes/no): " modify
            if [ "$modify" = "yes" ]; then
                display_user_info "$username"
                return
            else
                continue
            fi
        fi
        
        break
    done
    
    # Get full name
    read -p "Enter full name (optional): " fullname
    if [ -z "$fullname" ]; then
        fullname="$username"
    fi
    
    # Ask about home directory
    read -p "Create home directory? (yes/no) [yes]: " create_home
    create_home=${create_home:-yes}
    
    # Choose shell
    echo "Available shells:"
    echo "1) /bin/bash (default)"
    echo "2) /bin/sh"
    echo "3) /bin/zsh"
    echo "4) /usr/bin/fish"
    read -p "Choose shell (1-4) [1]: " shell_choice
    shell_choice=${shell_choice:-1}
    
    case $shell_choice in
        1) shell="/bin/bash" ;;
        2) shell="/bin/sh" ;;
        3) shell="/bin/zsh" ;;
        4) shell="/usr/bin/fish" ;;
        *) shell="/bin/bash" ;;
    esac
    
    # Create the user
    create_user "$username" "$fullname" "$create_home" "$shell"
    
    # Set password
    read -p "Set password now? (yes/no) [yes]: " set_pwd
    set_pwd=${set_pwd:-yes}
    
    if [ "$set_pwd" = "yes" ]; then
        read -s -p "Enter password: " password
        echo ""
        read -s -p "Confirm password: " password_confirm
        echo ""
        
        if [ "$password" = "$password_confirm" ]; then
            set_password "$username" "$password"
        else
            print_error "Passwords do not match. User created without password."
            print_warning "Set password later using: passwd $username"
        fi
    fi
    
    # Add to groups
    read -p "Add user to additional groups? (comma-separated, e.g., docker,developers) [skip]: " groups_input
    if [ -n "$groups_input" ]; then
        IFS=',' read -ra groups <<< "$groups_input"
        add_to_groups "$username" "${groups[@]}"
    fi
    
    # Sudo access
    read -p "Grant sudo privileges? (yes/no) [no]: " sudo_access
    sudo_access=${sudo_access:-no}
    setup_sudo "$username" "$sudo_access"
    
    # Display final information
    echo ""
    print_info "User setup completed successfully!"
    echo ""
    display_user_info "$username"
}

# Non-interactive mode with command-line arguments
non_interactive_setup() {
    local username=$1
    local fullname=$2
    local password=$3
    local groups=$4
    local sudo_access=$5
    
    if [ -z "$username" ]; then
        print_error "Username is required"
        exit 1
    fi
    
    if ! validate_username "$username"; then
        print_error "Invalid username"
        exit 1
    fi
    
    if user_exists "$username"; then
        print_error "User '$username' already exists"
        exit 1
    fi
    
    create_user "$username" "${fullname:-$username}" "yes" "/bin/bash"
    
    if [ -n "$password" ]; then
        set_password "$username" "$password"
    fi
    
    if [ -n "$groups" ]; then
        IFS=',' read -ra group_array <<< "$groups"
        add_to_groups "$username" "${group_array[@]}"
    fi
    
    if [ "$sudo_access" = "yes" ]; then
        setup_sudo "$username" "$sudo_access"
    fi
    
    display_user_info "$username"
}

# Show usage
show_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Interactive mode (no arguments):"
    echo "  $0"
    echo ""
    echo "Non-interactive mode:"
    echo "  $0 -u USERNAME [-f FULLNAME] [-p PASSWORD] [-g GROUPS] [-s]"
    echo ""
    echo "Options:"
    echo "  -u USERNAME    Username to create (required in non-interactive mode)"
    echo "  -f FULLNAME    Full name of the user"
    echo "  -p PASSWORD    Password for the user"
    echo "  -g GROUPS      Comma-separated list of groups"
    echo "  -s             Grant sudo privileges"
    echo "  -h             Show this help message"
    echo ""
    echo "Examples:"
    echo "  # Interactive mode (recommended for password entry)"
    echo "  sudo $0"
    echo ""
    echo "  # Create user with sudo access"
    echo "  sudo $0 -u john -f 'John Doe' -s"
    echo ""
    echo "  # Create user with groups (password will be prompted)"
    echo "  sudo $0 -u jane -f 'Jane Smith' -g 'docker,developers'"
    echo ""
    echo "  # Non-interactive with password (INSECURE - visible in process list)"
    echo "  sudo $0 -u testuser -f 'Test User' -p 'YourSecurePassword123'"
}

# Main script
main() {
    check_root
    
    # Parse command line arguments
    if [ $# -eq 0 ]; then
        # Interactive mode
        interactive_setup
    else
        # Parse options
        local username=""
        local fullname=""
        local password=""
        local groups=""
        local sudo_access="no"
        
        while getopts "u:f:p:g:sh" opt; do
            case $opt in
                u) username="$OPTARG" ;;
                f) fullname="$OPTARG" ;;
                p) password="$OPTARG" ;;
                g) groups="$OPTARG" ;;
                s) sudo_access="yes" ;;
                h) show_usage; exit 0 ;;
                *) show_usage; exit 1 ;;
            esac
        done
        
        non_interactive_setup "$username" "$fullname" "$password" "$groups" "$sudo_access"
    fi
}

main "$@"
