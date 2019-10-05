vagrant plugin install vagrant-vbguest
vagrant up
vagrant ssh master --command 'sh install-k3s-server.sh'
