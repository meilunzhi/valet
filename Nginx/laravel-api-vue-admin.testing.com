# ISOLATED_PHP_VERSION=php@7.4
server {
    listen 127.0.0.1:80;
    server_name laravel-api-vue-admin.testing.com www.laravel-api-vue-admin.testing.com *.laravel-api-vue-admin.testing.com;
    #listen VALET_LOOPBACK:80; # valet loopback
    root /;
    charset utf-8;
    client_max_body_size 128M;

    location /41c270e4-5535-4daa-b23e-c269744c2f45/ {
        internal;
        alias /;
        try_files $uri $uri/;
    }

    location / {
        rewrite ^ "/Users/Meilunzhi/.composer/vendor/laravel/valet/server.php" last;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log off;
    error_log "/Users/Meilunzhi/.config/valet/Log/nginx-error.log";

    error_page 404 "/Users/Meilunzhi/.composer/vendor/laravel/valet/server.php";

    location ~ [^/]\.php(/|$) {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass "unix:/Users/Meilunzhi/.config/valet/valet74.sock";
        fastcgi_index "/Users/Meilunzhi/.composer/vendor/laravel/valet/server.php";
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME "/Users/Meilunzhi/.composer/vendor/laravel/valet/server.php";
        fastcgi_param PATH_INFO $fastcgi_path_info;
    }

    location ~ /\.ht {
        deny all;
    }
}
