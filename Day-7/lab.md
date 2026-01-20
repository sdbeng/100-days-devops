## Corp Industries is planning to host two static websites on their infra in Stratos Datacenter. The development of these websites is still in-progress, but we want to get the servers ready. Please perform the following steps to accomplish the task
a. Install httpd package and dependencies on app server 3.
b. Apache should serve on port 6400.
c. There are two website's backups /home/thor/blog and /home/thor/games on jump_host. Set them up on Apache in a way that blog should work on the link http://localhost:6400/blog/ and games should work on link http://localhost:6400/games/ on the mentioned app server.
d. Once configured you should be able to access the website using curl command on the respective app server, i.e curl http://localhost:6400/blog/ and curl http://localhost:6400/games/

## start
set up Apache on App Server 3 to host two static websites.
Step 1: Copy website backups from Jump Host to App Server 3
On Jump Host:
# Verify the backups exist
ls -la /home/thor/blog
ls -la /home/thor/games

# Copy both directories to App Server 3
scp -r /home/thor/blog banner@stapp03:/tmp/
scp -r /home/thor/games banner@stapp03:/tmp/

Step 2: SSH to App Server 3
ssh user@stapp03

Step 3: Install httpd
# Install Apache
sudo yum install -y httpd

# Verify installation
httpd -v

Step 4: Configure Apache to run on port 6400
# Change Listen port to 6400
sudo sed -i 's/^Listen 80/Listen 6400/' /etc/httpd/conf/httpd.conf

# Verify the change
sudo grep "^Listen" /etc/httpd/conf/httpd.conf
# Should show: Listen 6400

Step 5: Move website directories to Apache document root
# Move the websites to /var/www/html/
sudo mv /tmp/blog /var/www/html/
sudo mv /tmp/games /var/www/html/

# Set proper ownership
sudo chown -R apache:apache /var/www/html/blog
sudo chown -R apache:apache /var/www/html/games

# Set proper permissions
sudo chmod -R 755 /var/www/html/blog
sudo chmod -R 755 /var/www/html/games

# Verify the structure
ls -la /var/www/html/

Step 6: Start Apache
# Start httpd
sudo systemctl start httpd

# Enable on boot
sudo systemctl enable httpd

# Check status
sudo systemctl status httpd

Step 7: Verify Apache is listening on port 6400
# Check if Apache is listening on port 6400
sudo ss -tulpn | grep 6400
# or
sudo netstat -tulpn | grep 6400

Step 8: Test the websites
# Test blog website
curl http://localhost:6400/blog/

# Test games website
curl http://localhost:6400/games/
Both should return HTML content from the respective websites.


## outcomes
$ curl http://localhost:6400/blog/
<!DOCTYPE html>
<html>
<body>
<h1>title</h1>
<p>This is a sample page for our blog website</p>
</body>
$ curl http://localhost:6400/games/
<!DOCTYPE html>
<html>
<body>
<h1>...</h1>
<p>This is a sample page for our games website</p>
</body>