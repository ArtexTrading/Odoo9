#!/bin/bash

################################################################################
# Script for Uninstall: ODOO server on Ubuntu
# Author: Jose A Cuello, ARTEX TRADING 2016
#-------------------------------------------------------------------------------
# Description:       Script for automatic uninstallation of ODOO 9
#
#-------------------------------------------------------------------------------
# USAGE:
#
# sudo odoo-uninstall <install directory>
#
# EXAMPLE:
# sudo ./odoo-uninstall /opt/odoo9
#
################################################################################

### Working values
OD_DIR="$1"
if [ -z $OD_DIR ]; then
  OD_DIR="/opt/odoo9"
fi

if [ -d $OD_DIR ]; then
  read -p "Do you want remove Odoo (y/n)?" yn
  case $yn in
    [Yy]* )
      sudo service odoo-server stop
      sudo update-rc.d odoo-server remove
      sudo rm -R $OD_DIR
      sudo rm /etc/odoo-server.conf
      sudo rm /usr/bin/odoo.py
      sudo rm -R /var/log/odoo
      sudo rm /etc/init.d/odoo-server
      exit 0
      ;;
  * )
  esac
else
  echo "ERROR: Don't exits directory $OD_DIR"
  exit 1
fi
exit 1