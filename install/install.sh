# you can also run this as root, but using sudo is better
name=bitwarden_rs
fqdn=$(hostname -f)
DESTDIR=$PWD/bitwarden-pg
#export ~/.cargo/bin:$PATH

#getent passwd $name || sudo useradd -s /usr/sbin/nologin -b /var/lib $name
#sudo chown -R root:root $DESTDIR
#sudo chgrp $name $DESTDIR/etc/$name.env
#sudo chown -R $name $DESTDIR/var/lib/$name
#sudo chgrp -R $name $DESTDIR/var/lib/$name

#cd $DESTDIR
#tar czf ../$name-$(date '+%Y%m%d').tgz .
#cd -

echo -e "\e[0mPackaging complete, \e[33m$name-$(date '+%Y%m%d').tgz\e[0m"
echo
echo To install, use:
echo -e "	\e[34m*** \e[32mcd $DESTDIR\e[0m"
echo -e "	\e[34m*** \e[32msudo tar xzf $name-$(date '+%Y%m%d').tgz -C /\e[0m"
echo
echo -e "\e[0mTo enable \& start the service:"
echo -e "	\e[34m*** \e[32msudo systemctl enable $name.service\e[0m"
echo -e "	\e[34m*** \e[32msudo systemctl start $name.service\e[0m"
echo -e "\e[0m"
echo -e "\e[31m\e[1mRemember:\e[0m set the correct permissions of the \e[33mDATA_FOLDER\e[0m prior to starting the"
echo -e "service.  On start up, $name attempts to read (and if it does not exist,"
echo -e "create) \e[33mrsa_key.pem\e[0m in the \e[33mDATA_FOLDER.\e[0m  If this fails, then the program will"
echo -e "stop. If you forgot, do not worry, you can do this later.  The same steps"
echo -e "will be followed whenever there are no rsa_key files in the \e[33mDATA_FOLDER\e[0m."
