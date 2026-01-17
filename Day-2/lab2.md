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