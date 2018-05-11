#!/bin/bash
mv /share/scripts /home/vagrant
chmod -R +x /home/vagrant/scripts
apt-get update
apt-get install -y git
apt-get install -y python-software-properties
su - vagrant -c "curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -"
apt-get install -y nodejs
npm i -g npm@latest
apt-get install -y build-essential

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install -y yarn

yarn global add @angular/cli@latest
yarn global add typescript@latest
yarn global add tslint@latest
yarn global add protractor@latest
yarn install
webdriver-manager update

su - vagrant -c "ng config -g cli.packageManager yarn"


#Install Mongodb
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo "deb [ arch=amd64,arm64 ] http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list
apt-get update
apt-get install -y mongodb-org
systemctl enable mongod
cat > /etc/motd <<- "EOF"
=======================================================
MongoDB log file: /var/log/mongodb/mongod.log
MongoDB Port: 27017

Angular serve command: ng serve --port 4400 --host 0.0.0.0 --watch true --poll 100
Angular URL: http://localhost:4400
=======================================================
EOF

su - vagrant -c "mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim"
cat >> /home/vagrant/.vimrc <<- 'EOF'
execute pathogen#infect()
syntax on
filetype plugin indent on
EOF

cat >> /home/vagrant/.bashrc <<- 'EOF'
alias ngs='ng serve --port $PORT --host 0.0.0.0 --watch true --poll 100'
export PATH=$PATH:~/scripts
EOF

chown vagrant /home/vagrant/.vimrc 
chgrp vagrant /home/vagrant/.vimrc 

su - vagrant -c "mkdir -p ~/.vim/bundle/node"
su - vagrant -c "git clone https://github.com/moll/vim-node.git ~/.vim/bundle/node"
su - vagrant -c "git clone https://github.com/jelera/vim-javascript-syntax.git ~/.vim/bundle/vim-javascript-syntax"
su - vagrant -c "git clone https://github.com/vim-scripts/JavaScript-Indent.git ~/.vim/bundle/vJavaScript-Indent"
su - vagrant -c "echo \"au BufNewFile,BufRead *.ejs set filetype=html\" >> ~/.vimrc "

echo "export PORT=4400" >>/etc/environment
cp /scripts/ngnew /usr/bin/ngnew
chmod +x /usr/bin/ngnew 
