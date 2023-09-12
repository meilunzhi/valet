<?php

namespace Valet\Drivers\Custom;

use Valet\Drivers\ValetDriver;

class Yii2AdvancedValetDriver extends ValetDriver
{
    /**
     * Determine if the driver serves the request.
     *
     * @param  string  $sitePath
     * @param  string  $siteName
     * @param  string  $uri
     * @return bool
     */
    public function serves(string $sitePath, string $siteName, string $uri): bool
    {
        return is_file($sitePath . '/yii');
    }

    /**
     * Determine if the incoming request is for a static file.
     *
     * @param  string  $sitePath
     * @param  string  $siteName
     * @param  string  $uri
     * @return string|false
     */
    public function isStaticFile(string $sitePath, string $siteName, string $uri) : string
    {
        $apps = $this->loadAllApplication($sitePath);
        foreach ($apps as $app => $basePath) {
            if (strpos($basePath, $uri) === 0 || strpos($uri, $basePath) === 0) {
                if (file_exists($staticFilePath = $sitePath . '/' . $app . '/web/' . $uri)) {
                    return $staticFilePath;
                }
            }
        }

        return false;
    }

    private function loadAllApplication(string $sitePath) : string
    {
        $handle = opendir($sitePath);

        $apps = [];
        while (($file = readdir($handle)) !== false) {
            if ($file === '.' || $file === '..') {
                continue;
            }
            $path = $sitePath . DIRECTORY_SEPARATOR . $file . DIRECTORY_SEPARATOR . 'config/main.php';
            if (is_file($path)) {
                $content = file_get_contents($path);
                if (preg_match('/[\'"]homeUrl[\'"]\s*=>\s*[\'"](.*?)[\'"]/', $content, $subject)) {
                    $apps[$file] = $subject[1];
                }
            }
        }
        closedir($handle);

        return $apps;
    }

    /**
     * Get the fully resolved path to the application's front controller.
     *
     * @param  string  $sitePath
     * @param  string  $siteName
     * @param  string  $uri
     * @return string
     */
    public function frontControllerPath(string $sitePath, string $siteName, string $uri) :string
    {
        $apps = $this->loadAllApplication($sitePath);
        foreach ($apps as $app => $basePath) {
            if (strpos($basePath, $uri) === 0 || strpos($uri, $basePath) === 0) {
                $baseUri = str_replace($basePath, '', $uri);
                if (file_exists($staticFilePath = $sitePath . '/' . $app . '/web/' . $baseUri)) {
                    if (substr($baseUri, -4, 4) == '.css') {
                        header('Content-Type: text/css;charset=UTF-8');
                    }
                    if (substr($baseUri, -3, 3) == '.js') {
                        header('Content-Type: application/javascript');
                    }
                    return $staticFilePath;
                }

                if (file_exists($staticFilePath = $sitePath . '/' . $app . '/web/index.php')) {
                    return $staticFilePath;
                }
            }
        }

        return false;
    }
}
