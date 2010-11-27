# http://blog.ninjahideout.com/posts/a-guide-to-a-nginx-passenger-and-rvm-server

echo "What default version of Ruby will you be using? "
read ruby_default_version
echo ""

aptitude update
aptitude upgrade
aptitude install curl git-core libxslt-dev
aptitude install build-essential bison openssl libreadline5 libreadline-dev
curl git-core zlib1g zlib1g-dev libssl-dev vim libsqlite3-0 libsqlite3-dev
sqlite3 libreadline-dev libxml2-dev git-core subversion autoconf

bash < <( curl http://github.com/wayneeseguin/rvm/raw/master/contrib/install-system-wide )

sed -i 's/[ -z "$PS1" ]/if [[ -n "$PS1" ]]; then/g' /root/.bashrc
sed -i 's/[ -z "$PS1" ]/if [[ -n "$PS1" ]]; then/g' /etc/skel/.bashrc

echo << ROOTBASHRC >> /root/.bashrc
fi
if groups | grep -q rvm ; then
  source "/usr/local/lib/rvm"
fi
ROOTBASHRC

echo << SKELBASHRC >> /etc/skel/.bashrc
fi
if groups | grep -q rvm ; then
  source "/usr/local/lib/rvm"
fi
SKELBASHRC

adduser deploy
adduser deploy rvm

source ~/.rvm/scripts/rvm

rvm notes | cat > ~/.rvm_notes
bash < ~/.rvm_notes

rvm install $ruby_default_version

rvm $ruby_default_version --default

rvm default

gem install passenger

passenger-install-nginx-module

curl -L http://bit.ly/nginx-ubuntu-init-file > /etc/init.d/nginx
chmod +x /etc/init.d/nginx
update-rc.d nginx defaults
/etc/init.d/nginx start

