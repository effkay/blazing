target :staging, 'user@server:/var/www/someproject.com',
       rails_env: 'production'

env_script '/etc/profile.d/rbenv.sh'

rake :post_deploy
