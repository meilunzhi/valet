# ISOLATED_PHP_VERSION=74
server {
    listen 127.0.0.1:80;
    #listen 127.0.0.1:80; # valet loopback
    server_name laravel-admin.testing.com www.laravel-admin.testing.com *.laravel-admin.testing.com;
    return 301 https://$host$request_uri;
}

server {
    listen 127.0.0.1:443 ssl http2;
    #listen 127.0.0.1:443 ssl http2; # valet loopback
    server_name laravel-admin.testing.com www.laravel-admin.testing.com *.laravel-admin.testing.com;
    root /;
    charset utf-8;
    client_max_body_size 512M;
    http2_push_preload on;

    location /41c270e4-5535-4daa-b23e-c269744c2f45/ {
        internal;
        alias /;
        try_files $uri $uri/;
    }

    ssl_certificate "/Users/Meilunzhi/.config/valet/Certificates/laravel-admin.testing.com.crt";
    ssl_certificate_key "/Users/Meilunzhi/.config/valet/Certificates/laravel-admin.testing.com.key";

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

server {
    listen 127.0.0.1:60;
    #listen 127.0.0.1:60; # valet loopback
    server_name laravel-admin.testing.com www.laravel-admin.testing.com *.laravel-admin.testing.com;
    root /;
    charset utf-8;
    client_max_body_size 128M;

    add_header X-Robots-Tag 'noindex, nofollow, nosnippet, noarchive';

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

