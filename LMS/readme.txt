#install services and plugins
 sudo apt install apache2 php mariadb-server graphviz aspell php-pspell php-curl php-gd php-intl php-mysqlnd php-xmlrpc php-ldap -y
#configure php
nano /etc/php/8.1/cli/php.ini
#change this lines to
memory_limit = 256M
max_execution_time = 300
post_max_size = 100M
upload_max_filesize = 100M
max_input_vars = 3000
date.timezone = "Your/Timezone"
#restart apache
sudo systemctl restart apache2.service 
#installation muddle
cd /var/www/html
sudo wget https://download.moodle.org/download.php/direct/stable403/moodle-latest-403.zip
sudo unzip moodle-latest-403.zip
sudo cd moodle
sudo cp -r * /var/www/html/
sudo chown -R www-data: /var/www/html 
sudo mkdir /var/www/moodledata 
sudo chown -R www-data: /var/www/moodledata
#creating database
sudo systemctl restart mariadb.service
sudo mysql_secure_installation
sudo mysql -u root -p
#mysql config
create database moodle;
grant all on moodle.* to moodle@'localhost' identified by 'password';
flush privileges;
quit;
