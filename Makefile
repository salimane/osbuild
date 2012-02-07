install:
	if test ! -f /usr/bin/git; then sudo apt-get install git-all; fi
	git config --global user.name "Salimane Adjao Moustapha"
	git config --global user.email "me@salimane.com"
	git config --global github.user "salimane"
	if test ! -f ~/.ssh/id_rsa.pub ; then mkdir -p ~/.ssh && cd ~/.ssh && ssh-keygen -t rsa -C "me@salimane.com"; fi
	if test ! -d ~/htdocs/dotfiles ; then mkdir -p ~/htdocs && cd ~/htdocs && git clone git@github.com:salimane/dotfiles.git; fi
	cd ~/htdocs/dotfiles && make install
	if test ! -d ~/htdocs/osbuild ; then mkdir -p ~/htdocs && cd ~/htdocs && git clone git@github.com:salimane/osbuild.git; fi
	cd ~/htdocs/osbuild && make aptbuild && make devbuild


aptbuild:
	wget http://hacktolive.org/files/downloads/app-runner/app-runner-0.5.2.deb && sudo dpkg -i app-runner-0.5.2.deb
	sudo apt-get install --force-yes -y build-essential checkinstall cdbs devscripts dh-make fakeroot libxml-parser-perl check avahi-daemon vlc mplayer libxine1-ffmpeg gxine mencoder mpeg2dec vorbis-tools id3v2 mpg321 mpg123 libflac++6 ffmpeg totem-mozilla icedax tagtool easytag id3tool lame nautilus-script-audio-convert libmad0 libjpeg-progs flac faac faad sox ffmpeg2theora libmpeg2-4 uudeview flac libmpeg3-1 mpeg3-utils mpegdemux liba52-0.7.4-dev gstreamer0.10-ffmpeg gstreamer0.10-fluendo-mp3 gstreamer0.10-gnonlin gstreamer0.10-sdl gstreamer0.10-plugins-bad-multiverse gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly totem-plugins-extra gstreamer-dbus-media-service gstreamer-tools ubuntu-restricted-extras wine playonlinux unace rar unrar zip unzip p7zip-full p7zip-rar sharutils uudeview mpack lha arj cabextract file-roller multiget  empathy telepathy-mission-control-5 telepathy-gabble telepathy-butterfly telepathy-haze telepathy-idle telepathy-salut telepathy-sofiasip libtelepathy-farsight0 python-tpfarsight galago-eds-feed python-galago python-galago-gtk msn-pecan skype banshee banshee-extension-ubuntuonemusicstore banshee-extension-appindicator banshee-extension-lyrics banshee-extension-mirage gimp gimp-data gimp-plugin-registry gimp-data-extras gedit gedit-plugins gedit-developer-plugins libreoffice libreoffice-pdfimport libreoffice-math libreoffice-wiki-publisher libreoffice-report-builder libreoffice-gnome deluge-torrent amule gsfonts gsfonts-x11 flashplugin-installer ssh subversion subversion-tools pptp-linux ppp pptpd network-manager-pptp 


devbuild:
	sudo apt-get install --force-yes -y mysql-server mysql-client libmysqlclient15-dev libc6 libpcre3 libpcre3-dev libpcrecpp0 libssl0.9.8 libssl-dev zlib1g zlib1g-dev lsb-base nginx php5-common php5-dev libmagick9-dev php5-cli php5-mysql php5-curl php5-gd php5-idn php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-mhash php5-ming php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-xdebug php5-json php5-geoip php5-memcached php5-fpm php5-cgi python python-dev python-pip redis-server 
	mysql_secure_installation
	if test ! -d ~/htdocs/redis; then cd ~/htdocs && git clone https://github.com/antirez/redis.git; fi
	if test ! -f /usr/bin/redis-server; then cd ~/htdocs/redis && git checkout 2.4 && \
	make && \
	make test && \
	sudo make PREFIX=/usr install
	sudo sh -c "echo 1 > /proc/sys/vm/overcommit_memory"
	if test ! -d ~/htdocs/phpredis; then cd ~/htdocs && git clone https://github.com/nicolasff/phpredis.git; fi
	if test ! -f /etc/php5/conf.d/redis.ini; then cd ~/htdocs/phpredis && \
	phpize && \
	./configure && \
	make && \
	make test && \
	sudo make install && \
	sudo sh -c "echo 'extension=redis.so' > /etc/php5/conf.d/redis.ini"
	sudo sed -i 's/;pm.start_servers/pm.start_servers/g' /etc/php5/fpm/pool.d/www.conf
	sudo /etc/init.d/nginx restart 
	sudo /etc/init.d/php5-fpm restart
	
	
	
	
	
	
	
	
	
	
	
	
	

