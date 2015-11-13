<?php if (!defined('WX_AUTH_DEMO')) { die('Unauthorized Access!'); }

/* !!! 请配置以下信息 !!! */

error_reporting(E_ALL);
date_default_timezone_set('Asia/Shanghai');

// 应用的AppID及AppSecret，可在open.weixin.qq.com中找到，应与app客户端一致
define('WX_APP_ID', 'wxbeafe42095e03edf');
define('WX_APP_SECRET', '52bdd90af64b2f70f28bfe19532befb1');

// SDK路径
define('WX_AUTH_SDK_PATH', __DIR__ . '/../sdk/');

// 若使用demo自带的文件存储，请创建数据文件存储的目录，并保证目录可写
// 为避免数据泄露，请不要使用默认路径
define('WX_AUTH_STORE_PATH', __DIR__ . '/_store/');

// RSA密钥地址
define('WX_AUTH_RSA_PRIVATE_KEY', __DIR__ . '/_key/rsa_private.key');

// 加密登录票据(token、密码等)的盐
// 为避免暴力破解，请不要使用默认值
define('WX_AUTH_SALT', 'WxAuthDemo');

// 票据相关时间，单位为秒
define('WX_LOGIN_TOKEN_EXPIRE_CREATE_TIME', 60*60*24*30);
define('WX_LOGIN_TOKEN_EXPIRE_LAST_LOGIN_TIME', 60*60*24*7);
define('WX_AUTH_SESSION_KEY_EXPIRE_TIME', 60*60);

// 第三方业务相关的错误码，可根据实际业务情况来定义
define('WX_ERR_INVALID_COMMENT_CONTENT',			-40001);	//留言内容不合法
define('WX_ERR_INVALID_REPLY_CONTENT',				-40002);	//回复内容不合法
define('WX_ERR_NO_COMMENT',							-40003);	//留言不存在

/* !!! 请配置以上信息 !!! */


function wxlog($str) {
	if (!is_string($str)) {
		$str = json_encode($str);
	}
	$file = WX_AUTH_STORE_PATH.'/log.txt';
	if (!file_exists($file)) {
		file_put_contents($file, '');
	}
	$fp = fopen($file, 'a');
	fwrite($fp, date('[m-d H:i:s]')." ".$str."\n");
	fclose($fp);
}


/* END file */