#!/bin/bash

# The MIT License (MIT)
#
# Copyright (c) 2015 Microsoft Azure
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

apt-get update -y
echo "Apt update finished"
apt-get install apache2 mysql-client php php-fpm libapache2-mod-php graphviz aspell ghostscript clamav php-pspell php-curl php-gd php-intl php-mysql php-xml php-xmlrpc php-ldap php-zip php-soap php-mbstring -y
echo "Dependencies installed"
service apache2 restart
echo "Apache2 restarted"
cd /opt
git clone git://git.moodle.org/moodle.git
cd moodle
git branch --track MOODLE_36_STABLE origin/MOODLE_36_STABLE
git checkout MOODLE_36_STABLE
cp -a /opt/moodle/. /var/www/html/
chmod -R 0777 /var/www/html
echo "Moodle files copied"
mkdir /var/lmsdata
chown -R www-data /var/lmsdata
chmod -R 777 /var/lmsdata
mount 192.168.0.4:/home/lmsstorageadmin/lmsdata /var/lmsdata
echo "Moodledata mounted"
cronjob="*/1 * * * * /usr/bin/php  /var/www/html/admin/cli/cron.php >/dev/null"
(crontab -u www-data -l; echo "$cronjob" ) | crontab -u www-data -
echo "Ready to go"
rm /var/www/html/index.html