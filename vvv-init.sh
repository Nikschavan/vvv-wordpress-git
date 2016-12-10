echo "Creating database (if it's not already there)"
mysql -u root --password=root -e "CREATE DATABASE IF NOT EXISTS wordpress_contribute;"
mysql -u root --password=root -e "GRANT ALL PRIVILEGES ON wordpress_contribute.* TO wp@localhost IDENTIFIED BY 'wp';"

if [ ! -d "htdocs/src/wp-admin" ]; then
	echo 'Installing WordPress Trunk (Git) in wordpress-contribute/htdocs...'
	if [ ! -d "./htdocs" ]; then
		mkdir ./htdocs
	fi
	git clone git://develop.git.wordpress.org/ htdocs
	cd ./htdocs/src
	wp core config --dbname="wordpress_contribute" --dbuser=wp --dbpass=wp --dbhost="localhost" --dbprefix=wp_ --locale=en_US --allow-root --extra-php <<PHP
if ( isset( \$_SERVER['HTTP_HOST'] ) && preg_match('/^(git.wordpress.)\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(.xip.io)\z/', \$_SERVER['HTTP_HOST'] ) ) {
define( 'WP_HOME', 'http://' . \$_SERVER['HTTP_HOST'] );
define( 'WP_SITEURL', 'http://' . \$_SERVER['HTTP_HOST'] );
}
PHP
	mv wp-config.php ../wp-config.php
	wp core install --url=git.wordpress.dev --title="wordpress-contribute" --admin_user=admin --admin_password=password --admin_email=admin@localhost.dev --allow-root

	npm install
	
	cd -

else

	cd htdocs
	git pull --all

fi

