#!/bin/bash

################################################################################
# Script for Installation: ODOO server on Ubuntu
# Author: Jose A Cuello, ARTEX TRADING 2016
#-------------------------------------------------------------------------------
# Description:       Script for automatic instalation of ODOO 9
# Required   :       Server need have install Git, Apache2, PHP, Python 2.7
#                                and have been create postgres user
#
#-------------------------------------------------------------------------------
# USAGE:
#
# sudo odoo-install <install directory> <version> <locale> <superadminpassword>
#
# EXAMPLE:
# sudo ./odoo-install /opt/odoo9 9.0 es_ES.UTF8 myPassword
#
################################################################################

### Working values
OD_USER="odoo"
OD_CONFIG="$OD_USER-server"

OD_DIR="$1"
if [ -z $OD_DIR ]; then
  OD_DIR="/opt/odoo9"
fi

OD_DIR_EXT="$OD_DIR/$OD_USER-server"

OD_VERSION="$2"
if [ -z $OD_VERSION ]; then
  OD_VERSION="9.0"
fi

OD_LOCALE="$3"
if [ -z $OD_LOCALE ]; then
  OD_LOCALE="es_ES.UTF-8"
fi

OD_ADMINPASSWORD="$4"
if [ -z $OD_ADMINPASSWORD ]; then
  OD_ADMINPASSWORD="admin"
fi


#--------------------------------------------------
# Update Instalation Computer
#--------------------------------------------------
echo "*** Updating Server ***"
sudo apt-get update

read -p "Do you want install or configure locales (y/n)?" yn
case $yn in
  [Yy]* ) 
    sudo apt-get install -y locales
    export LANGUAGE=$OD_LOCALE
    export LANG=$OD_LOCALE
    export LC_ALL=$OD_LOCALE
    sudo locale-gen $OD_LOCALE
    sudo dpkg-reconfigure locales
    ;;
* )
esac

#--------------------------------------------------
# Install PostgreSQL Server
#--------------------------------------------------
read -p "Do you want install POSTGRESQL (y/n)?" yn
case $yn in
  [Yy]* ) 
    echo "--------------------------------------------------"
    echo "*** Install PostgreSQL Server ***";
    echo "--------------------------------------------------"
    sudo apt-get -y install postgresql ;
    
    echo "--------------------------------------------------"
    echo "*** PostgreSQL $PG_VERSION Settings ***";
    echo "--------------------------------------------------"
    PG_VERSION=$(ls /etc/postgresql)
    sudo sed -i s/"#listen_addresses = 'localhost'"/"listen_addresses = '*'"/g /etc/postgresql/$PG_VERSION/main/postgresql.conf ;
    service postgresql restart

    echo "--------------------------------------------------"
    echo "*** Creating the ODOO PostgreSQL User ***"
    echo "--------------------------------------------------"
    echo "create role $OD_USER with password '$OD_ADMINPASSWORD' LOGIN SUPERUSER CREATEDB;" > /tmp/.odoo-user
    sudo su - postgres -c 'psql template1 < /tmp/.odoo-user' || true
    rm /tmp/.odoo-user
    ;;
* )
esac

#--------------------------------------------------
# Install Tools
#--------------------------------------------------
read -p "Do you want install required tools (y/n)?" yn
case $yn in
  [Yy]* ) 
    echo "--------------------------------------------------"
    echo "*** Install tools required ***"
    echo "--------------------------------------------------"
    sudo apt-get -y install wget subversion git bzr bzrtools python2.7 python2.7-dev

    echo "--------------------------------------------------"
    echo "*** Install db & import libraries tools packages ***"
    echo "--------------------------------------------------"
    sudo apt-get install -y libxml2-dev libxslt1-dev libldap2-dev libsasl2-dev libpq-dev libjpeg-dev
    sudo apt-get install -y poppler-utils antiword xfonts-75dpi node-less

    if [ ! -f /tmp/wkhtmltox-0.12.2_linux-trusty-amd64.deb ]; then
      wget http://download.gna.org/wkhtmltopdf/0.12/0.12.2/wkhtmltox-0.12.2_linux-trusty-amd64.deb -P /tmp/
    fi
    sudo dpkg -i /tmp/wkhtmltox-0.12.2_linux-trusty-amd64.deb
    sudo ln -s /usr/local/bin/wkhtmltoimage /usr/bin/wkhtmltoimage
    sudo ln -s /usr/local/bin/wkhtmltopdf /usr/bin/wkhtmltopdf

    echo "--------------------------------------------------"
    echo "*** Install python packages ***"
    echo "--------------------------------------------------"
    sudo apt-get install -y python-dateutil python-feedparser python-ldap python-libxslt1 python-lxml python-mako python-openid
    sudo apt-get install -y python-psycopg2 python-pybabel python-pychart python-pydot python-pyparsing python-reportlab python-simplejson
    sudo apt-get install -y python-tz python-vatnumber python-vobject python-webdav python-werkzeug python-xlwt python-yaml python-zsi
    sudo apt-get install -y python-docutils python-psutil python-mock python-unittest2 python-jinja2 python-pypdf python-decorator
    sudo apt-get install -y python-requests python-passlib python-pil python-pdftools python-setuptools python-imaging python-gdata

    echo "--------------------------------------------------"
    echo "*** Install python libraries ***"
    echo "--------------------------------------------------"
    sudo apt-get install python-pip
    pip install --upgrade pip
    pip install --upgrade virtualenv
    pip install --upgrade requests

    pip install --upgrade gdata
    pip install --upgrade unicodecsv
    pip install --upgrade unidecode
    pip install --upgrade lxml
    pip install --upgrade simplejson
    pip install --upgrade babel
    pip install --upgrade werkzeug
    pip install --upgrade unittest2
    pip install --upgrade setuptools
    pip install --upgrade pillow
    pip install --upgrade reportlab
    ;;
* )
esac

#--------------------------------------------------
# Install ODOO
#--------------------------------------------------
# remove old installation
if [ -d $OD_DIR ]; then
  read -p "Found Odoo installation. Do you want to delete and perform a complete installation? (y/n)?" yn
  case $yn in
    [Yy]* )
      echo "--------------------------------------------------"
      echo "*** Removing old installation ***"
      echo "--------------------------------------------------"
      sudo rm -R $OD_DIR
      sudo deluser $OD_USER
    ;;
  * )
  esac
fi

if [ ! -d $OD_DIR ]; then
  echo "--------------------------------------------------"
  echo "*** Create ODOO system user ***"
  sudo adduser --system --quiet --shell=/bin/bash --home=$OD_DIR/ --gecos 'ODOO' --group $OD_USER
  echo "--------------------------------------------------"

  echo "--------------------------------------------------"
  echo "*** Installing ODOO Server ***"
  echo "--------------------------------------------------"
  sudo mkdir $OD_DIR
  sudo mkdir $OD_DIR_EXT
  sudo mkdir $OD_DIR/addons
  
  if [ "$OD_VERSION" == "9.0" ]; then
    sudo git clone -b $OD_VERSION --depth 1 https://github.com/odoo/odoo.git $OD_DIR_EXT
  fi

  if [ "$OD_VERSION" == "8.0" ]; then
    sudo git clone -b $OD_VERSION --depth 1 https://github.com/OCA/OCB.git $OD_DIR_EXT

    sudo git clone -b $OD_VERSION --depth 1 https://github.com/OCA/l10n-spain.git $OD_DIR/addons/l10n-spain
    sudo git clone -b $OD_VERSION --depth 1 https://github.com/OCA/partner-contact.git $OD_DIR/addons/partner-contact
    sudo git clone -b $OD_VERSION --depth 1 https://github.com/OCA/account-financial-tools.git $OD_DIR/addons/account-financial-tools
    sudo git clone -b $OD_VERSION --depth 1 https://github.com/OCA/reporting-engine.git $OD_DIR/addons/reporting-engine
    sudo git clone -b $OD_VERSION --depth 1 https://github.com/OCA/bank-statement-import.git $OD_DIR/addons/bank-statement-import
    sudo git clone -b $OD_VERSION --depth 1 https://github.com/OCA/bank-payment.git $OD_DIR/addons/bank-payment
    sudo git clone -b $OD_VERSION --depth 1 https://github.com/OCA/pos.git $OD_DIR/addons/pos
  fi
fi

echo "--------------------------------------------------"
echo "*** Check requirements ***"
echo "--------------------------------------------------"
sudo pip install --upgrade -r $OD_DIR_EXT/requirements.txt
sudo pip install --upgrade -r $OD_DIR_EXT/doc/requirements.txt

echo "--------------------------------------------------"
echo "*** Create LOG structure ***"
echo "--------------------------------------------------"
if [ ! -d /var/log/$OD_USER ]; then
  if ! sudo mkdir /var/log/$OD_USER; then
    echo "ERROR: Can't create target directory: /var/log/$OD_USER"
    exit 1;
  fi
fi
sudo chown $OD_USER:$OD_USER /var/log/$OD_USER  

echo "--------------------------------------------------"
echo "*** Setting permissions on instalation folder ***"
echo "--------------------------------------------------"
sudo chown -R $OD_USER:$OD_USER $OD_DIR

echo "--------------------------------------------------"
echo "*** Create server config file ***"
echo "--------------------------------------------------"
OD_DIR2=${OD_DIR//'/'/'\/'}
OD_DIR_EXT2="$OD_DIR2\/$OD_USER-server"

if [ "$OD_VERSION" == "9.0" ]; then
  OD_ADDONS="$OD_DIR2\/addons,$OD_DIR_EXT2\/addons,\/usr\/lib\/python2.7\/dist-packages"
fi

if [ "$OD_VERSION" == "8.0" ]; then
  OD_ADDONS="$OD_DIR2\/addons,$OD_DIR2\/addons\/l10n-spain,$OD_DIR2\/addons\/partner-contact,$OD_DIR2\/addons\/account-financial-tools,$OD_DIR2\/addons\/reporting-engine,$OD_DIR2\/addons\/bank-statement-import,$OD_DIR2\/addons\/bank-payment,$OD_DIR2\/addons\/pos,$OD_DIR_EXT2\/addons,\/usr\/lib\/python2.7\/dist-packages"
fi

sudo cp $OD_DIR_EXT/debian/openerp-server.conf /etc/$OD_CONFIG.conf
sudo sed -i s/"db_user = .*"/"db_user = $OD_USER"/g /etc/$OD_CONFIG.conf
sudo sed -i s/"; admin_passwd.*"/"admin_passwd = $OD_ADMINPASSWORD"/g /etc/$OD_CONFIG.conf
sudo sed -i s/"addons_path = .*"/"addons_path = $OD_ADDONS"/g /etc/$OD_CONFIG.conf
sudo su root -c "echo 'logfile = /var/log/$OD_USER/$OD_CONFIG.log' >> /etc/$OD_CONFIG.conf"
sudo chown $OD_USER:$OD_USER /etc/$OD_CONFIG.conf
sudo chmod 640 /etc/$OD_CONFIG.conf

echo "--------------------------------------------------"
echo "*** Create startup file ***"
echo "--------------------------------------------------"
sudo su root -c "echo '#!/bin/sh' >> $OD_DIR_EXT/start.sh"
sudo su root -c "echo 'sudo -u $OD_USER $OD_DIR_EXT/openerp-server --config=/etc/$OD_CONFIG.conf' >> $OD_DIR_EXT/start.sh"
sudo chmod 755 $OD_DIR_EXT/start.sh

#--------------------------------------------------
# Installing ODOO as a deamon
#--------------------------------------------------

echo "--------------------------------------------------"
echo "*** Create init file ***"
echo "--------------------------------------------------"
echo '#!/bin/bash' >> ~/$OD_CONFIG
echo '### BEGIN INIT INFO' >> ~/$OD_CONFIG
echo '# Provides: $OD_CONFIG' >> ~/$OD_CONFIG
echo '# Required-Start: $remote_fs $syslog' >> ~/$OD_CONFIG
echo '# Required-Stop: $remote_fs $syslog' >> ~/$OD_CONFIG
echo '# Should-Start: $network' >> ~/$OD_CONFIG
echo '# Should-Stop: $network' >> ~/$OD_CONFIG
echo '# Default-Start: 2 3 4 5' >> ~/$OD_CONFIG
echo '# Default-Stop: 0 1 6' >> ~/$OD_CONFIG
echo '# Short-Description: Enterprise Business Applications' >> ~/$OD_CONFIG
echo '# Description: ODOO Business Applications' >> ~/$OD_CONFIG
echo '### END INIT INFO' >> ~/$OD_CONFIG
echo 'PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin' >> ~/$OD_CONFIG
echo 'DAEMON=/usr/bin/openerp-server' >> ~/$OD_CONFIG
echo "NAME=$OD_CONFIG" >> ~/$OD_CONFIG
echo "DESC=$OD_CONFIG" >> ~/$OD_CONFIG
echo '' >> ~/$OD_CONFIG
#
echo '# configuration' >> ~/$OD_CONFIG
echo "USER=$OD_USER" >> ~/$OD_CONFIG
echo "LOGFILE=/var/log/$OD_USER/$OD_CONFIG.log" >> ~/$OD_CONFIG
echo "CONFIGFILE=/etc/$OD_CONFIG.conf" >> ~/$OD_CONFIG
echo 'PIDFILE=/var/run/$NAME.pid' >> ~/$OD_CONFIG
echo '' >> ~/$OD_CONFIG
#
echo '# additional tasks & validations' >> ~/$OD_CONFIG
echo 'export LOGNAME=$USER' >> ~/$OD_CONFIG
echo 'test -x $DAEMON || exit 0' >> ~/$OD_CONFIG
echo 'set -e' >> ~/$OD_CONFIG
echo '' >> ~/$OD_CONFIG
#
echo '# operations functions' >> ~/$OD_CONFIG
echo '_start(){' >> ~/$OD_CONFIG
echo '  start-stop-daemon --start --quiet --pidfile $PIDFILE --chuid $USER --background --make-pidfile --exec $DAEMON -- --config $CONFIGFILE --logfile $LOGFILE' >> ~/$OD_CONFIG
echo '}' >> ~/$OD_CONFIG
echo '' >> ~/$OD_CONFIG
echo '_stop(){' >> ~/$OD_CONFIG
echo '  start-stop-daemon --stop --quiet --pidfile $PIDFILE --oknodo --retry 3' >> ~/$OD_CONFIG
echo '  rm -f $PIDFILE' >> ~/$OD_CONFIG
echo '}' >> ~/$OD_CONFIG
echo '' >> ~/$OD_CONFIG
echo '_status(){' >> ~/$OD_CONFIG
echo '  start-stop-daemon --status --quiet --pidfile $PIDFILE' >> ~/$OD_CONFIG
echo '  return $?' >> ~/$OD_CONFIG
echo '}' >> ~/$OD_CONFIG
echo '' >> ~/$OD_CONFIG
#
echo 'case "$1" in' >> ~/$OD_CONFIG
echo '  start)' >> ~/$OD_CONFIG
echo '    echo -n "Starting $DESC: "' >> ~/$OD_CONFIG
echo '    _start' >> ~/$OD_CONFIG
echo '    echo "ok"' >> ~/$OD_CONFIG
echo '  ;;' >> ~/$OD_CONFIG
echo '  stop)' >> ~/$OD_CONFIG
echo '    echo -n "Stopping $DESC: "' >> ~/$OD_CONFIG
echo '    _stop' >> ~/$OD_CONFIG
echo '    echo "ok"' >> ~/$OD_CONFIG
echo '  ;;' >> ~/$OD_CONFIG
echo '  restart|force-reload)' >> ~/$OD_CONFIG
echo '    echo -n "Restarting $DESC: "' >> ~/$OD_CONFIG
echo '    _stop' >> ~/$OD_CONFIG
echo '    sleep 2' >> ~/$OD_CONFIG
echo '    _start' >> ~/$OD_CONFIG
echo '    echo "ok"' >> ~/$OD_CONFIG
echo '  ;;' >> ~/$OD_CONFIG
echo '  status)' >> ~/$OD_CONFIG
echo '    echo -n "Status of $DESC: "' >> ~/$OD_CONFIG
echo '    _status && echo "running" || echo "stopped"' >> ~/$OD_CONFIG
echo '  ;;' >> ~/$OD_CONFIG
echo '  *)' >> ~/$OD_CONFIG
echo '    N=/etc/init.d/$NAME' >> ~/$OD_CONFIG
echo '    echo "Usage: $N {start|stop|restart|force-reload|status}" >&2' >> ~/$OD_CONFIG
echo '    exit 1' >> ~/$OD_CONFIG
echo '  ;;' >> ~/$OD_CONFIG
echo 'esac' >> ~/$OD_CONFIG
echo 'exit 0' >> ~/$OD_CONFIG

echo "--------------------------------------------------"
echo "*** Init File system ***"
echo "--------------------------------------------------"
sudo rm /etc/init.d/$OD_CONFIG
sudo mv ~/$OD_CONFIG /etc/init.d/$OD_CONFIG
sudo chmod 755 /etc/init.d/$OD_CONFIG
sudo chown root: /etc/init.d/$OD_CONFIG

sudo ln -s $OD_DIR_EXT/openerp-server /usr/bin/openerp-server
sudo ln -s $OD_DIR_EXT/odoo.py /usr/bin/odoo.py
sudo chown $OD_USER:$OD_USER /usr/bin/openerp-server
sudo chown $OD_USER:$OD_USER /usr/bin/odoo.py

echo "--------------------------------------------------"
echo "*** Start ODOO on Startup ***"
echo "--------------------------------------------------"
sudo update-rc.d $OD_CONFIG defaults
 
echo "--------------------------------------------------"
echo "--------------------------------------------------"
echo "--------------------------------------------------"
echo "All Done! To controle service type: service start|stop|status"
echo "Example: service $OD_CONFIG start"
echo "Have a nice day!"
