# Don't run this as root, run this with your own account.
name=bitwarden_rs
fqdn=$(hostname -f)
DESTDIR=$PWD/bitwarden-pg
echo
echo -e "\e[1mBuild \e[33m$name \e[0m with PostgreSQL support.  \e[0mFor MySQL or sqlite"
echo -e "you will need to modify this script and install the relevant library"
echo -e "dependancies, as required."
echo
echo -e "This script will create a directory structure for \e[33m$name\e[0m, check out the"
echo -e "source from the github repository, build the binaries and also copy these files"
echo -e "from \e[33m$PWD\e[0m into the destination folder:"
echo -e "\e[34m *** \e[33m./bitwarden_rs.service \e[36m->\e[35m $name.service\e[0m"
echo -e "\e[34m *** \e[33m./bitwarden_rs.env \e[36m->\e[35m $name.env\e[0m"
echo -e "\e[34m *** \e[33m./nginx_config \e[36m->\e[35m $name.$fqdn\e[0m"
echo
while true;
do
  read -p "Have you edited these three files to suit your needs? [yN] " yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) echo -e "\e[0mEdit them, and re-run this script"; exit;;
    * ) echo "\e[0mPlease answer yes or no.";;
  esac
done

echo
echo -e "The following dependancies need to be installed for $name to be built:"
echo -e "\e[34m *** \e[31m\e[1mRust \e[0mInstall via \e[33mhttps://www.rust-lang.org/tools/install\e[0m"
echo -e "\e[34m *** \e[31m\e[1mnginx\e[0m for reverse proxy https SSL connections"
echo -e "\e[34m *** \e[31m\e[1mpkg-config\e[0m"
echo -e "\e[34m *** \e[31m\e[1mlibssl-dev\e[0m"
echo -e "\e[34m *** \e[31m\e[1mlibpq-dev \e[0m(for postgresql support)"
echo
echo -e "Install Rust via the above url, and then run the following:"
echo -e "   \e[33msudo apt install nginx pkg-config libssl-dev libpq-dev\e[0m"
echo
while true;
do
  read -p "Have you installed the dependancies? [yN] " yn
  case $yn in
    [Yy]* ) break;;
    [Nn]* ) echo -e "\e[0mInstall the dependancies, then re-run this script"; exit;;
    * ) echo "\e[0mPlease answer yes or no.";;
  esac
done

export ~/.cargo/bin:$PATH

install -d -m 0770 $DESTDIR/var/lib/$name
install -d -m 0755 $DESTDIR/usr/share/$name/webvault
test -e bw_web_v2.12.0.tar.gz || wget https://github.com/dani-garcia/bw_web_builds/releases/download/v2.12.0/bw_web_v2.12.0.tar.gz
tar xzf bw_web_v2.12.0.tar.gz -C $DESTDIR/usr/share/$name/webvault
install -D -m 0644 $name.service   $DESTDIR/usr/lib/systemd/system/$name.service
install -D -m 0600 $name.env       $DESTDIR/etc/$name.env
install -D -m 0644 nginx_config /etc/nginx/sites-enabled/$name.$fqdn

git clone https://github.com/dani-garcia/bitwarden_rs.git
cd $name
cargo build --release --features postgresql
RESULT=$?

if [ $RESULT -eq 0 ]; then
  install -D -m 0755 target/release/$name $DESTDIR/usr/bin/$name
  echo
  echo -e "Build complete, now create the package file by executing \e[33minstall.sh\e[0m"
  echo
  echo -e "\e[31m\e[1mRemember: \e[0mIf did not edit prior to building, the following require attention:"
  echo -e "	\e[33m$DESTDIR/$name.service"
  echo -e "	\e[33m$DESTDIR/$name.env"
  echo -e "	\e[33m/etc/nginx/sites-enabled/$name.$fqdn\e[0m"
else
  echo -e "Build failed, exit code $RESULT - fix the errors and re-run the build."
fi
