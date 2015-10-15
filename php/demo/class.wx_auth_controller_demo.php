<?php if (!defined('WX_AUTH_DEMO')) { die('Unauthorized Access!'); }

/**
 * @version 2015-09-15
 */
class WXAuthControllerDemo
{
	protected $db;
	protected $sdk;
	protected $data;

	function __construct()
	{
		// 加载SDK
		if (file_exists(WX_AUTH_SDK_PATH . 'class.wx_sdk_handler.php')) {
			require_once WX_AUTH_SDK_PATH . 'class.wx_sdk_handler.php';
			require_once WX_AUTH_SDK_PATH . 'class.wx_network.php';
			require_once WX_AUTH_SDK_PATH . 'class.wx_open_api.php';
			require_once WX_AUTH_SDK_PATH . 'interface.wx_database.php';
		} else {
			$this->show_server_error('WX Auth SDK does not exist.');
		}

		// 数据存取
		require_once __DIR__ . '/class.wx_auth_database_demo.php';
		$this->db = new WXAuthDatabaseDemo();
		if (!$this->db->is_available()) {
			$this->show_server_error('Database is not available.');
		}

		$opt = array(
			'app_id' => WX_APP_ID,
			'app_secret' => WX_APP_SECRET,
			'rsa_private_key' => WX_AUTH_RSA_PRIVATE_KEY,
			'salt' => WX_AUTH_SALT,
			'database' => $this->db,
			'delegate' => $this
		);
		$this->sdk = new WXSDKHandler($opt);
	}

	/**
	 * 控制器入口，根据action路由到各个页面
	 */
	public function main()
	{
		$action = 'action_' . urldecode($_GET['action']);
		if (!method_exists($this, $action)) {
			$this->show_server_error('Request action does not exist.');
		}
		call_user_func(array($this, $action));
	}


	/***************************************************************
	 * Actions
	 ***************************************************************/

	public function action_test()
	{
		$encode = 'MTIzNDU2NzgxMjM0NTY3OPJrgIkDx0G4ixfGpZgGHf89zFuCrochdfhmloA04QHTT27HmMHYG2mUeRkQp3HpFO7tO1heCSlkGZZblPOJ77o=';
		echo base64_decode($encode);
	}

	/**
	 * 建立登录前安全信道
	 * 获取密钥psk，并生成temp_uin
	 */
	public function action_connect()
	{
		$this->sdk->connect();
	}

	public function action_wxlogin()
	{
		$this->sdk->session_start();

		$resp = $this->sdk->wxlogin();

		$this->sdk->session_end($resp);
	}

	public function action_checklogin()
	{
		$this->sdk->checklogin();
	}

	public function action_getuserinfo()
	{
		wxlog("\n\t\t\tgetuserinfo");
		$sdk = $this->sdk;
		$sdk->session_start();
		$sdk->need_login();
		// $sdk->need_oauth();

		$req = $sdk->get_request_data();
		$resp = array();

		$mail = $this->db->get_mail_by_uin($req['uin']);
		if ($mail) {
			wxlog('has app_user');
			$app_user = $this->db->get_user_by_mail($mail);
			$resp = array_merge($resp, $app_user);
		}
		
		$oauth = $this->db->get_oauth_by_uin($req['uin']);
		if ($oauth) {
			wxlog('has oauth');
			$wx_user = $sdk->request_api('/sns/userinfo', $oauth, array());
			wxlog($wx_user);
			if (!$wx_user or isset($wx_user['errcode'])) {
				wxlog('ERR: Got API with errcode: '.$wx_user['errcode']);
				$sdk->session_end(null, $wx_user['errcode'], 'Fail to get API');
			}

			$wx_user['access_token_expire_time'] = $oauth['create_time'] + $oauth['expires_in'];
			$wx_user['refresh_token_expire_time'] = $oauth['create_time'] + 60*60*24*30;

			$resp = array_merge($resp, $wx_user);
		}

		$resp['access_log'] = array(
			array('login_time'=>time(), 'login_type'=>1)
		);
		
		wxlog($resp);
		wxlog('getuserinfo OK');
		$sdk->session_end($resp);
	}

	public function action_register()
	{
		wxlog("\n\t\t\tregsiter");
		$sdk = $this->sdk;
		$sdk->session_start();
		
		// 获取app提交的数据
		$req = $sdk->get_request_data();
		$form = $req['buffer'];
		wxlog($form);

		// 检查是否已注册
		$exist_user = $this->db->get_user_by_mail($form['mail']);
		if ($exist_user) {
			$sdk->session_end(null, -1, 'Mail already exists');
		}

		// 生成新用户id
		$uin = $sdk->generate_uin();

		// 根据提交的数据，配置新用户的各属性
		$user = array(
			'mail' => $form['mail'],
			'nickname' => $form['nickname'],
			'sex' => $form['sex'],
			'headimgurl' => '',
			'pwd' => md5($form['pwd_h1'] . WX_AUTH_SALT)
		);

		// 写入数据库
		$this->db->set_mail_by_uin($form['mail'], $uin);
		$this->db->set_user_by_mail($user, $form['mail']);

		// 生成登录凭据
		$login_ticket = $sdk->do_login($uin);
		
		$resp = array(
			'uin' => $uin,
			'login_ticket' => $login_ticket
		);
		wxlog($resp);
		$sdk->session_end($resp);
	}

	public function action_login()
	{
		wxlog("\n\t\t\tlogin");
		$sdk = $this->sdk;
		$sdk->session_start();

		$req = $sdk->get_request_data();
		$form = $req['buffer'];
		wxlog($req);

		$app_user = $this->db->get_user_by_mail($form['mail']);
		if (!$app_user) {
			$sdk->session_end(null, -1, 'No user');
		}
		if ($this->pwd_encode($form['pwd_h1']) != $app_user['pwd']) {
			$sdk->session_end(null, -1, 'Wrong password');
		}

		$uin = $this->db->get_mail_by_uin($form['mail']);
		if (!$uin) {
			$uin = $sdk->generate_uin();
			$this->db->set_mail_by_uin($form['mail'], $uin);
		}

		// 生成登录凭据
		$login_ticket = $sdk->do_login($uin);
		
		$resp = array(
			'uin' => $uin,
			'login_ticket' => $login_ticket
		);
		wxlog($resp);
		$sdk->session_end($resp);
	}

	public function action_wxbindapp()
	{
		wxlog("\n\t\t\twxbindapp");
		$sdk = $this->sdk;
		$sdk->session_start();
		$sdk->need_oauth();

		$req = $sdk->get_request_data();
		$uin = $req['uin'];
		$form = $req['buffer'];
		wxlog($form);

		if ($form['is_to_create']) {
			// 注册新帐号
			// 检查是否已注册
			$exist_user = $this->db->get_user_by_mail($form['mail']);
			if ($exist_user) {
				$sdk->session_end(null, -1, 'Mail already exists');
			}

			// 根据提交的数据，配置新用户的各属性
			$user = array(
				'mail' => $form['mail'],
				'nickname' => $form['nickname'],
				'sex' => $form['sex'],
				'headimgurl' => '',
				'pwd' => md5($form['pwd_h1'] . WX_AUTH_SALT)
			);

			// 写入数据库
			$this->db->set_user_by_mail($user, $form['mail']);
		} else {
			// 登录已有帐号
			$app_user = $this->db->get_user_by_mail($form['mail']);
			if (!$app_user) {
				$sdk->session_end(null, -1, 'No user');
			}
			if ($this->pwd_encode($form['pwd_h1']) != $app_user['pwd']) {
				$sdk->session_end(null, -1, 'Wrong password');
			}
		}

		// 记录关联关系
		$this->db->set_mail_by_uin($form['mail'], $uin);

		$login_ticket = $sdk->do_login($uin);

		$resp = array(
			'uin' => $uin,
			'login_ticket' => $login_ticket
		);
		wxlog('wxbindapp OK');
		wxlog($resp);
		$sdk->session_end($resp);
	}

	public function action_appbindwx()
	{
		wxlog("\n\t\t\tappbindwx");
		$sdk = $this->sdk;
		$sdk->session_start();
		$sdk->need_login();

		$resp = $sdk->wxlogin();

		$sdk->session_end($resp);

	}

	public function action_commentlist()
	{
		wxlog("\n\t\t\tcommentlist");
		$sdk = $this->sdk;
		$sdk->session_start();

		$req = $sdk->get_request_data();
		$start_id = $req['buffer']['start_id'];
		

		$perpage = 20;
		$count = $this->db->get_comment_count();
		$list = $this->db->get_comment_list($start_id, $perpage);

		// 处理回复，截取前3条
		foreach ($list as $key => $comment) {
			if ($comment['reply_count'] > 3) {
				$list[$key]['reply_list'] = array_slice($comment['reply_list'], 0, 3);
			}
		}

		$resp = array(
			'perpage' => $perpage,
			'comment_count' => $count,
			'comment_list' => $list
		);
		
		wxlog($resp);
		wxlog('commentlist OK');
		$sdk->session_end($resp);

	}

	public function action_replylist()
	{
		wxlog("\n\t\t\tcommentlist");
		$sdk = $this->sdk;
		$sdk->session_start();

		$req = $sdk->get_request_data();
		$comment_id = $req['buffer']['comment_id'];
		
		$comment = $this->db->get_comment($comment_id);
		if (!$comment) {
			wxlog('no comment');
			$sdk->session_end(null, WX_ERR_NO_COMMENT, 'Cannot get comment by comment_id');
		}

		$resp = array(
			'reply_list' => array_values($comment['reply_list'])
		);
		
		wxlog($resp);
		wxlog('replylist OK');
		$sdk->session_end($resp);
	}

	public function action_addcomment()
	{
		wxlog("\n\t\t\taddcomment");
		$sdk = $this->sdk;
		$sdk->session_start();
		$sdk->need_login();
		$sdk->need_oauth();

		$req = $sdk->get_request_data();
		$form = $req['buffer'];
		$resp = array();

		// 校验内容
		if (!$form['content']) {
			wxlog('no content');
			$sdk->session_end(null, WX_ERR_INVALID_COMMENT_CONTENT, 'Empty comment content');
		}
		
		// 获取用户
		$wx_user = $this->db->get_wxuser_by_uin($req['uin']);
		if (!$wx_user) {
			wxlog('no wx_user');
			$oauth = $this->db->get_oauth_by_uin($req['uin']);
			$wx_user = $sdk->request_api('/sns/userinfo', $oauth, array());
			if (!$wx_user or isset($wx_user['errcode'])) {
				wxlog('ERR: Got API with errcode: '.$wx_user['errcode']);
				$sdk->session_end(null, $wx_user['errcode'], 'Fail to get API');
			}
			$this->db->set_wxuser_by_uin($wx_user, $req['uin']);
		}

		// 生成新留言
		$comment = array(
			'id' => uniqid(), // 随机生成字符串，因为业务量小，所以不考虑id冲突
			'content' => $form['content'],
			'date' => time(),
			'user' => $wx_user,
			'reply_count' => 0,
			'reply_list' => array()
		);
		$this->db->add_comment($comment);

		$resp['comment'] = $comment;
		
		wxlog($resp);
		wxlog('addcomment OK');
		$sdk->session_end($resp);
	}

	public function action_addreply()
	{
		wxlog("\n\t\t\taddreply");
		$sdk = $this->sdk;
		$sdk->session_start();
		$sdk->need_login();
		$sdk->need_oauth();

		$req = $sdk->get_request_data();
		$form = $req['buffer'];
		$resp = array();

		// 校验内容
		if (!$form['content']) {
			wxlog('no content');
			$sdk->session_end(null, WX_ERR_INVALID_REPLY_CONTENT, 'Empty reply content');
		}

		// 获取留言
		$comment = $this->db->get_comment($form['comment_id']);
		if (!$comment) {
			wxlog('no comment');
			$sdk->session_end(null, WX_ERR_NO_COMMENT, 'Cannot get comment by comment_id');
		}
		
		// 获取用户
		$wx_user = $this->db->get_wxuser_by_uin($req['uin']);
		if (!$wx_user) {
			wxlog('no wx_user');
			$oauth = $this->db->get_oauth_by_uin($req['uin']);
			$wx_user = $sdk->request_api('/sns/userinfo', $oauth, array());
			if (!$wx_user or isset($wx_user['errcode'])) {
				wxlog('ERR: Got API with errcode: '.$wx_user['errcode']);
				$sdk->session_end(null, $wx_user['errcode'], 'Fail to get API');
			}
			$this->db->set_wxuser_by_uin($wx_user, $req['uin']);
		}

		// 找到被回复的人
		if ($form['reply_to_id']) {
			if (isset($comment['reply_list'][ $form['reply_to_id'] ])) {
				$form['content'] = '回复 ' . $comment['reply_list'][ $form['reply_to_id'] ] . '：' . $form['content'];
			}
		}

		// 生成新回复
		$reply = array(
			'id' => uniqid(), // 随机生成字符串，因为业务量小，所以不考虑id冲突
			'content' => $form['content'],
			'date' => time(),
			'reply_to_id' => $form['reply_to_id'],
			'user' => $wx_user
		);
		$this->db->add_reply($reply, $comment['comment_id']);

		$resp['reply'] = $reply;
		
		wxlog($resp);
		wxlog('addreply OK');
		$sdk->session_end($resp);
	}

	/***************************************************************
	 * Helpers
	 ***************************************************************/

	protected function show_server_error($msg)
	{
		header($_SERVER['SERVER_PROTOCOL'] . ' 500 Internal Server Error', true, 500);
		$msg = '<h1>500 Internal Server Error</h1>' . $msg;
		die($msg);
	}

	protected function pwd_encode($pwd)
	{
		return md5($pwd . WX_AUTH_SALT);
	}


} // END

/* END file */