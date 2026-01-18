# install docker-ce and docker-compose packages on App server 2
Let's install Docker CE and Docker Compose.

## Step 1: Install required dependencies
```bash
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
```
## Step 2: Add Docker's official repository
```bash
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
```
## Step 3: Install Docker CE
```bash
sudo yum install -y docker-ce docker-ce-cli containerd.io
```
## Step 4: Start and enable Docker service
```bash
sudo systemctl start docker
sudo systemctl enable docker
```
## Step 5: Install Docker Compose
# Download the latest stable release
```bash
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
## Make it executable
```bash
sudo chmod +x /usr/local/bin/docker-compose
```
### Verification:
# Check Docker version
```bash
docker --version

# Check Docker Compose version
docker-compose --version

# Verify Docker is running
sudo systemctl status docker

### Note
If the GitHub download is timing out. Let's try alternative methods to install Docker Compose.
Option 1: Install via yum/dnf (easiest for labs) (works)

This often works in lab environments
```bash
sudo yum install -y docker-compose-plugin
```
Then verify with:
```bash
docker compose version  # Note: no hyphen, it's a plugin
```
Option 2: Use a specific version with shorter timeout
bash# Try a specific stable version (v2.24.0)
```
sudo curl -L --max-time 60 "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

Option 3: Install via pip (if Python is available)

```bash
sudo yum install -y python3-pip
sudo pip3 install docker-compose

Option 4: Use EPEL repository
```bashsudo yum install -y epel-release
sudo yum install -y docker-compose

Try Option 1 first - it's the most reliable in restricted lab environments. The plugin approach (docker compose without hyphen) is the modern way Docker Compose is distributed.