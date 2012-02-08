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
	sudo apt-get install --force-yes -y build-essential checkinstall cdbs devscripts dh-make fakeroot libxml-parser-perl check avahi-daemon vlc mplayer libxine1-ffmpeg gxine mencoder mpeg2dec vorbis-tools id3v2 mpg321 mpg123 libflac++6 ffmpeg totem-mozilla icedax tagtool easytag id3tool lame nautilus-script-audio-convert libmad0 libjpeg-progs flac faac faad sox ffmpeg2theora libmpeg2-4 uudeview flac libmpeg3-1 mpeg3-utils mpegdemux liba52-0.7.4-dev gstreamer0.10-ffmpeg gstreamer0.10-fluendo-mp3 gstreamer0.10-gnonlin gstreamer0.10-sdl gstreamer0.10-plugins-bad-multiverse gstreamer0.10-plugins-bad gstreamer0.10-plugins-ugly totem-plugins-extra gstreamer-dbus-media-service gstreamer-tools ubuntu-restricted-extras wine playonlinux unace rar unrar zip unzip p7zip-full p7zip-rar sharutils uudeview mpack lha arj cabextract file-roller multiget  empathy telepathy-mission-control-5 telepathy-gabble telepathy-butterfly telepathy-haze telepathy-idle telepathy-salut telepathy-sofiasip libtelepathy-farsight0 python-tpfarsight galago-eds-feed python-galago python-galago-gtk msn-pecan skype banshee banshee-extension-ubuntuonemusicstore banshee-extension-appindicator banshee-extension-lyrics banshee-extension-mirage gimp gimp-data gimp-plugin-registry gimp-data-extras gedit gedit-plugins gedit-developer-plugins libreoffice libreoffice-pdfimport libreoffice-math libreoffice-wiki-publisher libreoffice-report-builder libreoffice-gnome deluge-torrent amule gsfonts gsfonts-x11 flashplugin-installer ssh subversion subversion-tools pptp-linux ppp pptpd network-manager-pptp denyhosts nmap psad chkrootkit logwatch
	sudo sed -i 's:(tmpfs).*::g' /etc/fstab
	sudo sh -c "echo '\n#Secure shared memory \ntmpfs     /dev/shm     tmpfs     defaults,noexec,nosuid     0     0\n' >> /etc/fstab"
	sudo sed -i 's_(PermitRootLogin).*_PermitRootLogin no_g' /etc/ssh/sshd_config
	sudo usermod -a -G admin salimane && sudo dpkg-statoverride --update --add root admin 4750 /bin/su
	sudo sysctl -w net.ipv4.conf.all.accept_source_route=0
	sudo sysctl -w net.ipv4.conf.default.accept_source_route=0
	nmap -v -sT localhost
	sudo psad -S
	sudo chkrootkit


devbuild:
	sudo apt-add-repository 'deb http://toolbelt.herokuapp.com/ubuntu ./'
	sudo apt-get update; \
	sudo apt-get install --force-yes -y mysql-server mysql-client libmysqlclient15-dev libc6 libpcre3 libpcre3-dev libpcrecpp0 libssl0.9.8 libssl-dev zlib1g zlib1g-dev lsb-base nginx php5-common php5-dev libmagick9-dev php5-cli php5-mysql php5-curl php5-gd php5-idn php-pear php5-imagick php5-imap php5-mcrypt php5-memcache php5-mhash php5-ming php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc php5-xsl php5-xdebug php5-json php5-geoip php5-memcached php5-fpm php5-cgi python python-setuptools python-dev python-software-properties python-pip redis-server libpcre3-dev heroku-toolbelt graphviz ruby1.9.1 ruby1.9.1-dev libreadline-dev libruby1.9.1 sqlite3-pcre libsqlite3-dev sqlite3 libsqlite3-ruby1.9.1  libbz2-dev zlib1g-dev tokyotyrant tokyotyrant-utils libxml2-dev psmisc libxml2 
	mysql_secure_installation
	if test ! -d ~/htdocs/redis; then cd ~/htdocs && git clone https://github.com/antirez/redis.git; fi
	if test ! -f /usr/bin/redis-server; then cd ~/htdocs/redis && git checkout 2.4 && \
	make && \
	make test && \
	sudo make PREFIX=/usr install; fi
	sudo sh -c "echo 1 > /proc/sys/vm/overcommit_memory"
	if test ! -d ~/htdocs/phpredis; then cd ~/htdocs && git clone https://github.com/nicolasff/phpredis.git; fi
	if test ! -f /etc/php5/conf.d/redis.ini; then cd ~/htdocs/phpredis && \
	phpize && \
	./configure && \
	make && \
	make test && \
	sudo make install && \
	sudo sh -c "echo 'extension=redis.so' > /etc/php5/conf.d/redis.ini"; fi
	sudo sed -i 's/;pm.start_servers/pm.start_servers/g' /etc/php5/fpm/pool.d/www.conf
	sudo sed -i 's_(;listen = 1|listen = 1).*_listen = /tmp/php-fpm.sock_g' /etc/php5/fpm/pool.d/www.conf
	sudo sed -i 's_(;date.timezone =|date.timezone =).*_date.timezone = "Asia/Shanghai"_g' /etc/php5/fpm/php.ini
	sudo sed -i 's/(;cgi.fix_pathinfo|^cgi.fix_pathinfo).*/cgi.fix_pathinfo = 0/g' /etc/php5/fpm/php.ini
	sudo sed -i 's:(^zend.enable_gc).*::g' /etc/php5/fpm/php.ini
	sudo sh -c "echo '\nzend.enable_gc=Off\n' >> /etc/php5/fpm/php.ini"
	mkdir -p /tmp/pear/cache
	if test ! -f /etc/php5/conf.d/imagick.ini; then sudo pecl install imagick; fi
	if test ! -f /etc/php5/conf.d/memcache.ini; then sudo pecl install memcache; fi
	#if test ! -f /etc/php5/conf.d/apc.ini; then sudo pecl install -f APC; fi
	#if test ! -f /etc/php5/conf.d/apc.ini; then sudo sh -c "echo '\nextension=apc.so\napc.enabled = 1\napc.shm_size = 128M\napc.shm_segments = 1\napc.ttl = 7200\napc.user_ttl = 7200\napc.gc_ttl = 21600' > /etc/php5/conf.d/apc.ini"; fi
	sudo sed -i 's/#/;/g' /etc/php5/conf.d/ming.ini
	sudo sed -i 's/extension/;extension/g' /etc/php5/conf.d/sqlite.ini
	sudo sed -i 's_(#SERVERHOST=1).*_SERVERHOST=127.0.0.1_g' /etc/default/tokyotyrant
	sudo sed -i 's_(#SERVERPORT=1).*_SERVERPORT=1978_g' /etc/default/tokyotyrant
	sudo rm -rf /var/run/tokyotyrant/tokyotyrant.pid
	sudo  /etc/init.d/tokyotyrant restart
	if test ! -f /etc/php5/conf.d/tokyo_tyrant.ini; then sudo pecl install -f tokyo_tyrant-beta; fi
	if test ! -f /etc/php5/conf.d/tokyo_tyrant.ini; then sudo sh -c "echo 'extension=tokyo_tyrant.so' > /etc/php5/conf.d/tokyo_tyrant.ini"; fi
	if test ! -d ~/htdocs/xhprof; then cd ~/htdocs && git clone git@github.com:salimane/xhprof.git; fi
	if test ! -f /etc/php5/conf.d/xhprof.ini; then cd ~/htdocs/xhprof/extension && \
	phpize && \
	./configure && \
	make && \
	make test && \
	sudo make install && \
	sudo sh -c "echo 'extension=xhprof.so\nxhprof.output_dir=/tmp/' > /etc/php5/conf.d/xhprof.ini"; fi
	sudo sed -i 's:(;auto_prepend_file|auto_prepend_file).*:auto_prepend_file = /home/salimane/htdocs/xhprof/xhprof_html/header.php:g' /etc/php5/fpm/php.ini
	sudo sed -i 's:(;auto_append_file|auto_append_file).*:auto_append_file = /home/salimane/htdocs/xhprof/xhprof_html/footer.php:g' /etc/php5/fpm/php.ini
	if test ! -f /etc/nginx/sites-available/xhprof.local; then sudo /bin/sh -c 'echo "server {\n  client_max_body_size 4M;\n  listen   80;\n  server_name xhprof.local;\n  root /home/salimane/htdocs/xhprof/xhprof_html;\n  index index.php;\n  access_log  /var/log/nginx/xhprof.access.log;\n  error_log  /var/log/nginx/xhprof.error.log;\n  location ~* ^.+\.(jpg|jpeg|gif|css|png|js|ico)$ {\n  access_log off;\n  expires 1m;\n  }\n  if (!-e $request_filename) {\n    rewrite ^(^\/*)/(.*)$ $1/index.php last;\n  }\n  location ~ ^(.+\.php)(.*)$ {\n    fastcgi_pass php_backend;\n    fastcgi_index index.php;\n    include fastcgi_params;\n  }\n  location ~ /\.ht {\n    deny all;\n  }\n}" > /etc/nginx/sites-available/xhprof.local' && \
	sudo ln -s /etc/nginx/sites-available/xhprof.local /etc/nginx/sites-enabled/xhprof.local; fi
	sudo /etc/init.d/php5-fpm restart
	sudo cp ~/htdocs/osbuild/nginx/default /etc/nginx/sites-available/default
	sudo cp ~/htdocs/osbuild/nginx/fastcgi_params /etc/nginx/fastcgi_params
	sudo /etc/init.d/nginx restart
	if test ! -f /usr/local/bin/uwsgi; then wget http://projects.unbit.it/downloads/uwsgi-latest.tar.gz && \
	tar -zxvf uwsgi-latest.tar.gz && \
	rm -rf uwsgi-latest.tar.gz uwsgi && \
	mv uwsgi-* uwsgi && \
	cd uwsgi && \
	sudo python setup.py install && \
	sudo adduser --system --no-create-home --disabled-login --disabled-password --group uwsgi && \
	sudo mkdir -p /var/log/uwsgi && \
	sudo chown -R uwsgi:uwsgi /var/log/uwsgi && \
	sudo touch /var/log/uwsgi/uwsgi.log && \
	sudo chown uwsgi /var/log/uwsgi/uwsgi.log; fi
	if test ! -f /etc/init/uwsgi.conf; then sudo /bin/sh -c 'echo "description \"uWSGI server\"\nstart on runlevel [2345]\nstop on runlevel [!2345]\nrespawn\nexec /usr/local/bin/uwsgi \\ \n--uid uwsgi \\ \n--gid uwsgi \\ \n--logdate \\ \n--master \\ \n--no-orphans \\ \n--chmod-socket 666 \\ \n--sharedarea 4 \\ \n--processes 1 \\ \n--harakiri 30 \\ \n--no-site \\ \n--vhost \\ \n--logto /var/log/uwsgi/uwsgi.log \\ \n--socket /tmp/uwsgi.sock" > /etc/init/uwsgi.conf'; fi
	sudo service uwsgi restart
	if test ! -f /usr/bin/php-shell.sh; then sudo pear install PHP_Shell-0.3.1; fi
	if test ! -f /usr/bin/gem; then cd ~/ && wget http://files.rubyforge.vm.bytemark.co.uk/rubygems/rubygems-1.8.15.tgz && \
	tar xzvf rubygems-1.8.15.tgz && \
	cd rubygems-1.8.15 && \
	sudo ruby setup.rb; fi 
	if test ! -f /usr/bin/gem; then sudo ln -s /usr/bin/gem1.9.1 /usr/bin/gem; fi
	sudo easy_install -U bpython redis hiredis pyres virtualenv hyde argparse commando jinja2 markdown pyyaml pygments smartypants repoze.profile
	sudo easy_install "http://github.com/hyde/typogrify/tarball/master"
	heroku login
	heroku keys
	heroku keys:add

	
	
	
	
	
	
	
	
	
	
	
	
	

