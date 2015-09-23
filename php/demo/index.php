<?php
define('WX_AUTH_DEMO', 1);

include_once 'config.php';
include_once 'class.wx_auth_controller_demo.php';

// here we go
$controller = new WXAuthControllerDemo();
$controller->main();

/* END file */