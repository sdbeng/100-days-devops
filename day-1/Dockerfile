# Day-1: Linux Interactive Shell with User Setup
# Dockerfile demonstrating user creation and management

FROM ubuntu:22.04

# Avoid interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    sudo \
    passwd \
    vim \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create a sample user with home directory
RUN useradd -m -s /bin/bash devops && \
    echo "devops:devops123" | chpasswd && \
    usermod -aG sudo devops

# Create another user without home directory
RUN useradd -M -s /bin/bash service_account

# Create a custom group and add user to it
RUN groupadd developers && \
    usermod -aG developers devops

# Copy the setup script
COPY setup_user.sh /usr/local/bin/setup_user.sh
RUN chmod +x /usr/local/bin/setup_user.sh

# Create a welcome message
RUN echo 'echo "Welcome to Day-1: Linux Interactive Shell with User Setup"' >> /etc/bash.bashrc && \
    echo 'echo "Current user: $(whoami)"' >> /etc/bash.bashrc && \
    echo 'echo "Home directory: $HOME"' >> /etc/bash.bashrc && \
    echo 'echo ""' >> /etc/bash.bashrc && \
    echo 'echo "Try these commands:"' >> /etc/bash.bashrc && \
    echo 'echo "  id - Show user and group information"' >> /etc/bash.bashrc && \
    echo 'echo "  whoami - Display current username"' >> /etc/bash.bashrc && \
    echo 'echo "  groups - Show groups the current user belongs to"' >> /etc/bash.bashrc && \
    echo 'echo "  cat /etc/passwd - View all users"' >> /etc/bash.bashrc && \
    echo 'echo "  sudo setup_user.sh - Run interactive user setup (requires root)"' >> /etc/bash.bashrc && \
    echo 'echo ""' >> /etc/bash.bashrc

# Set working directory
WORKDIR /home/devops

# Default user
USER devops

# Keep container running
CMD ["/bin/bash"]
