## lamp server
Corp Industries is planning to host a WordPress website on their infra in South Datacenter. They have already done infrastructure configuration—for example, on the storage server they already have a shared directory /vaw/www/html that is mounted on each app host under /var/www/html directory. Please perform the following steps to accomplish the task:
a. Install httpd, php and its dependencies on all app hosts.

b. Apache should serve on port 3000 within the apps.

c. Install/Configure MariaDB server on DB Server.

d. Create a database named kodekloud_db1 and create a database user named kodekloud_roy identified as password fdfdfdsfdsf. Further make sure this newly created user is able to perform all operation on the database you created.

e. Finally you should be able to access the website on LBR link, by clicking on the App button on the top bar. You should see a message like App is able to connect to the database using user kodekloud_roy

---
Set up the WordPress infrastructure step by step.

## **Part A & B: Install and configure Apache + PHP on all App Servers**

**Do this on ALL THREE app servers (stapp01, stapp02, stapp03):**

**Step 1: SSH to each app server**

```bash
ssh user@stapp01
# Repeat for steve@stapp02 and banner@stapp03
```

**Step 2: Install httpd, PHP and dependencies**

```bash
# Install Apache, PHP and required modules
sudo yum install -y httpd php php-mysqlnd php-fpm php-opcache php-gd php-xml php-mbstring

# Verify installation
php -v
httpd -v
```

**Step 3: Configure Apache to run on port 3000**

```bash
# Edit Apache configuration
sudo sed -i 's/^Listen 80/Listen 3000/' /etc/httpd/conf/httpd.conf

# Verify the change
sudo grep "^Listen" /etc/httpd/conf/httpd.conf
# Should show: Listen 3000
```

**Step 4: Start and enable Apache**

```bash
# Start httpd
sudo systemctl start httpd

# Enable on boot
sudo systemctl enable httpd

# Check status
sudo systemctl status httpd

# Verify it's listening on port 3000
sudo ss -tulpn | grep 3000
```

**Step 5: Test locally**

```bash
curl http://localhost:3000
```

**Repeat Steps 1-5 on stapp02 and stapp03**

---

## **Part C & D: Install and configure MariaDB on DB Server**

**Step 6: SSH to DB Server**

```bash
ssh user@stdb01
```

**Step 7: Install MariaDB**

```bash
# Install MariaDB server
sudo yum install -y mariadb-server

# Start MariaDB
sudo systemctl start mariadb

# Enable on boot
sudo systemctl enable mariadb

# Check status
sudo systemctl status mariadb
```

**Step 8: Secure MariaDB installation (optional but recommended)**

```bash
sudo mysql_secure_installation
# Press ENTER for no root password
# Set root password if desired
# Answer Y to other security questions
```

**Step 9: Create database and user**

```bash
# Login to MariaDB
sudo mysql
# or
sudo mysql -u root -p
```

**In MariaDB prompt:**

```sql
-- Create database
CREATE DATABASE kodekloud_db1;

-- Create user with password
CREATE USER 'kodekloud_roy'@'%' IDENTIFIED BY 'dasdsaffasfdfd';

-- Grant all privileges
GRANT ALL PRIVILEGES ON kodekloud_db1.* TO 'kodekloud_roy'@'%';

-- Flush privileges
FLUSH PRIVILEGES;

-- Verify
SHOW DATABASES;
SELECT User, Host FROM mysql.user WHERE User='kodekloud_roy';

-- Exit
EXIT;
```

**Step 10: Configure MariaDB to accept remote connections**

```bash
# Edit MariaDB config
sudo vi /etc/my.cnf
```

Add or modify under `[mysqld]` section:

```ini
[mysqld]
bind-address = 0.0.0.0
```

**Quick way with sed:**

```bash
# Add bind-address if not present
sudo sed -i '/\[mysqld\]/a bind-address = 0.0.0.0' /etc/my.cnf

# Or edit the file to ensure it's under [mysqld]
sudo vi /etc/my.cnf
```

**Step 11: Restart MariaDB**

```bash
sudo systemctl restart mariadb
sudo systemctl status mariadb
```

---

## **Part E: Deploy WordPress application**

**Step 12: Create test PHP file on shared storage**

On the **storage server** (or any app server since `/var/www/html` is shared):

```bash
ssh user@ststor01
# or from any app server
```

**Create a test database connection file:**
might not be needed

**Set proper permissions:**

```bash
sudo chown apache:apache /var/www/html/index.php err-not needed
sudo chmod 644 /var/www/html/index.php
```

---

## **Step 13: Configure Load Balancer (if not already done)**

On **LBR server (stlb01)**:

```bash
ssh user@stlb01
```

**Edit nginx config:**

```bash
sudo vi /etc/nginx/nginx.conf
```

**Update upstream to use port 3000:**

```nginx
upstream backend {
    server stapp01:3000;
    server stapp02:3000;
    server stapp03:3000;
}

server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://backend;
    }
}
```

**Restart nginx:**

```bash
sudo nginx -t
sudo systemctl restart nginx
```

---

## **Step 14: Final Testing**

**From jump host or browser:**

```bash
# Test via LBR
curl http://stlb01

# Should display:
# App is able to connect to the database using user kodekloud_roy
```

**Or click the "App" button in the top bar of your lab interface.**

---

## **Checklist:**

- ✓ httpd + PHP installed on all 3 app servers
- ✓ Apache running on port 3000 on all app servers
- ✓ MariaDB installed and running on DB server
- ✓ Database `kodekloud_db1` created
- ✓ User `kodekloud_roy` created with password
- ✓ User has all privileges on database
- ✓ PHP test file deployed on shared storage
- ✓ Website accessible via LBR showing success message

$ php -v
PHP 8.0.30 (cli) (built: Oct  3 2025 08:25:46) ( NTS gcc x86_64 )
Copyright (c) The PHP Group
Zend Engine v4.0.30, Copyright (c) Zend Technologies
    with Zend OPcache v8.0.30, Copyright (c), by Zend Technologies
$ httpd -v
Server version: Apache/2.4.62 (CentOS Stream)
Server built:   Nov  6 2025 00:00:00