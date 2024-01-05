################################################################################
# Nginx server block
################################################################################
unlink /etc/nginx/sites-enabled/www.signalregistry.net 
nginx -s reload
cat > /etc/nginx/sites-available/www.signalregistry.net <<- EOM
server {

  listen 80;
  listen [::]:80;

  root $PWD;

  index index.html;

  # https://docs.digitalocean.com/glossary/allow-origin/
  # add_header Access-Control-Allow-Origin "\$http_origin";
  # https://docs.digitalocean.com/glossary/allow-cred/
  # add_header Access-Control-Allow-Credentials 'true';

  server_name signalregistry.net www.signalregistry.net;
}
EOM
ln -s /etc/nginx/sites-available/www.signalregistry.net /etc/nginx/sites-enabled/www.signalregistry.net
nginx -t
nginx -s reload

sudo certbot --nginx -d signalregistry.net -d www.signalregistry.net
nginx -t
nginx -s reload

gpasswd -a www-data $USER
FOLDER=$PWD
while [[ $FOLDER != / ]]; do chmod g+x "$FOLDER"; FOLDER=$(dirname "$FOLDER"); done;
nginx -s reload
