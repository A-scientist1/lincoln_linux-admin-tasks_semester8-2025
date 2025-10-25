Task 3 Doumentation:
Task instruction:
**Apache Virtual Hosts Setup**
Configure Apache to host two websites (`site1.local`, `site2.local`) with separate documentroots and logs.
**Steps:**
```bash
:'
# 1. Allow your remote ubuntu server instance to recieve http request traffic through a port (usually port 80) apart from ssh traffic. 
# By default, new EC2 instances often allow only SSH (port 22), to communicate with your remote system through HTTP 
# (the protocol controlling web communication) you need to allow HTTP (port 80) 
# - Allow HTTP from AWS security group:
# i. Go to your EC2 Dashboard → Instances.
# ii. Select your instance (the one with public IP 13.51.198.200).
# iii. Scroll down to Security groups → click the group linked to your instance.
# iv. Go to the Inbound rules tab.
# v. Add a rule:
#	a. Type: HTTP
#	b. Port range: 80
#	c. Source: Anywhere (0.0.0.0/0, ::/0) for testing.
# vi. Save it.

# 2. Check if Apache is installed:
apache2 -v

# 3. Verify Apache is running
# i. a. 
sudo systemctl status apache2
# or
# b. 
sudo systemctl is-active apache2
# ii. Open a browser and visit: http://<yourServersPublicAddress> to see the Apache2 default page.
# To get your public address:
curl ifconfig.me
# Client for URL (CURL) -> is a command-line tool used to transfer data to or from a server using varieties of protocols: HTTP, HTTPS, FTP, and SCP.

# 4. Create your website's root folder in the location that apache looks for the root of 
# documents by default - it's "document root" (the /var/www directory):
sudo mkdir -p /var/www/localSite1Root
sudo mkdir -p /var/www/localSite2Root

# 5. Change the ownership of your sites' document root from "root" to your user account - 
# in this case ubuntu, to avoid permission denied errors, when you (ubuntu) want to create, 
# edit, or delete files within those directories since they have this permissions by default: 
# drwxr-xr-x
sudo chown -R $USER:$USER /var/www/localSite1Root
sudo chown -R $USER:$USER /var/www/localSite2Root
# $USER environment variable that stores the currently logged-in username, was utilized

# 6. Create a sample index page:
echo "<h1>Welcome to Site 1</h1>" | sudo tee /var/www/localSite1Root/index.html
echo "<h1>Welcome to Site 2</h1>" | sudo tee /var/www/localSite2Root/index.html
# the "tee" command reads standard input and writes it to both standard out and one or 
# more specified files.

# 7. Create separate log directories for each site
# Apache keeps logs of:
# Access logs → records every request (who visited, what page, etc.)
# Error logs → records any errors (broken configs, missing files, etc.)
# By default, all sites share Apache’s main logs (/var/log/apache2/).
# But here, we'll separate logs for each site within a dedicated folder (so that logs gets 
# organized cleanly by site) e.g:

sudo mkdir -p /var/log/apache2/localSite1
sudo mkdir -p /var/log/apache2/localSite2
# OR
sudo mkdir -p /var/log/apache2/{localSite1,localSite2}

# Then give Apache permission to write into those folders:
# The folders have a "drwxr-xr-x" permission by default

sudo chown -R www-data:www-data /var/log/apache2/localSite1
sudo chown -R www-data:www-data /var/log/apache2/localSite2

# For Apache, you don't typically have to manually create the log files. 
# You get to create them through your virtual host defination by specifying your log files' 
# paths and assinging them to your ErrorLog (for error logging) and CustomLog (for access 
# logging) directives:
# for localSite1
# Access log: /var/log/apche2/localSite1/localSite1_access.log
# Error log: /var/log/apache2/localSite1/localSite1_error.log
```
```apache
<VirtualHost *:80>
    ...................................
    ...........................................
    ...............................................................

    ErrorLog ${APACHE_LOG_DIR}/localSite1/localSite1_error.log
    CustomLog ${APACHE_LOG_DIR/localSite1/localSite1_access.log combined
</VirtualHost>
```
```bash
# for localSite2
# Access log: /var/log/apche2/localSite2/localSite2_access.log
# Error log: /var/log/apache2/localSite2/localSite2_error.log
```
```apache
<VirtualHost *:80>
    ...................................
    ...........................................
    ...............................................................

    ErrorLog ${APACHE_LOG_DIR}/localSite2/localSite2_error.log
    CustomLog ${APACHE_LOG_DIR/localSite2/localSite2_access.log combined
</VirtualHost>
```
```bash
# That way, if something goes wrong with localSite2, it won’t clutter the logs of localSite1.
```
APACHE_LOG_DIR=/var/log/apache2/
The log format name (or log format nickname), **"combined"**, at the end of the acces log, tells Apache to use a predefined log format called "combined" when 
writing to the access log. This sort of formats determines the information details that the access log would contain. 
For the combined format:
- Client IP address
- Identity (usually -)
- Username (for authenticated requests)
- Timestamp
- HTTP request line (method, path, protocol - the version of HTTP used by the client to - communicate with the server)
- Status code (200, 404, etc.)
- Response size in bytes
- Referer (which page did the user just come from to get to this new page?)
- User-Agent (browser/client information)
Other formats include, common - **Basic format** (no Referer or User-Agent), **vhost_combined** - Includes virtual host name, and **Custom formats** - Your 
own format defination within /etc/apache2/apache2.conf. 
**"combined"** format defination looks like this:
`LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined`
```bash

# 8. Create a virtual-host file for each site:
# Apache supports Virtual Hosts, website definitions written within user-created 
# configuration files  (a .conf file) at /etc/apache2/sites-available directory. They tell Apache 
# the correct site to serve depending on the domain (or IP) requested for, and the file to log 
# all erros and site access for each site (They are like routers inside Apache that tells it: 
# “for this domain, serve files from here and log them there”).
# Creating of Virtual hosts or virtual hosting, is what enables shared hosting - the running of 
# more than one websites on a web server like apache).
 mkdir -p /etc/apache2/sites-available/{localSite1.conf, localSite2.conf}  
# Creates /etc/apache2/sites-available/localSite1.conf and /etc/apache2/sites-available/localSite2.conf

# 9. Write the virtual-host defination within the virtual-host file:
nano etc/apache2/sites-available/localSite1.conf 
```
```apache
<VirtualHost *:80>
    ServerName site1.local
    ServerAlias www.site1.local
    DocumentRoot /var/www/localSite1Root

        ErrorLog ${APACHE_LOG_DIR}/localSite1/localSite1_error.log
    CustomLog ${APACHE_LOG_DIR/localSite1/localSite1_access.log combined
</VirtualHost>
```
```bash
nano etc/apache2/sites-available/localSite2.conf 
```
```apache
<VirtualHost *:80>
    ServerName site2.local
    ServerAlias www.site2.local
    DocumentRoot /var/www/localSite2Root

    ErrorLog ${APACHE_LOG_DIR}/localSite2/localSite2_error.log
    CustomLog ${APACHE_LOG_DIR/localSite2/localSite2_access.log combined
</VirtualHost>
```
```bash

# 10. Enable the Virtual Hosts
# Activate both configs and disable the default one:
sudo a2ensite site1.local.conf
sudo a2ensite site2.local.conf
sudo a2dissite 000-default.conf
# `a2ensite` stands for "apache2 enable site", and `a2dissite` stands for "apache2 disable
# site". This commmands allow or disallow configuration files to be loaded by the web 
# server. The achieve this by creating (`a2ensite`), or deleting (`a2dissite`) symbolic 
# links/symlink/soft links of virtual host's configuration files within the `/etc/apache2/sites-
# enabled/` directory

# 11. Reload Apache:
sudo systemctl reload apache2

# 12. Edit your `/etc/hosts` file:
# The /etc/hosts file acts as a local DNS override, because our local computer won't be able 
# to find site1.local and site2.local as these domains are served by a local web server - the 
# Apache in our remote computer. By default, when you type site1.local in your browser, 
# your system would try to look it up via DNS (Domain Name System), but won't find it 
# because it's a custom local domains you just created—they don't exist on the internet. So 
# with the help of the "hosts" config. file that contain entries like:
```
```lua
127.0.0.1    site1.local
127.0.0.1    site2.local
```
```bash
# Apache would tell the computer: " when site1.local or site2.local is asked for, point to 
# 127.0.0.1 localhost/your own remote machines public IP, instead of trying to look it up on 
# the internet."
sudo nano /etc/hosts
# Type in 
```
```lua
13.51.198.200 site1.local
13.51.198.200 site2.local
```
