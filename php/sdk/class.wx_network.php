<?php

class WXNetwork
{

	public function get_request($is_json = true)
	{
		$req = file_get_contents('php://input');
		// wxlog('get_request:'.$req);
		if ($req == false) {
			return null;
		}
		if ($is_json == true) {
			$req = json_decode($req, true);
		}
		return $req;
	}

	public function response_error($errcode = -1)
	{
		header('Content-Type: application/json; charset=utf8');
		$resp = array(
			'errcode' => $errcode
		);
		echo json_encode($resp_buffer);
		exit(0);
	}

	public function response($aes_key, $data = array(), $errcode = 0, $errmsg = '')
	{
		header('Content-Type: application/json; charset=utf8');
		$resp = array(
			'base_resp' => array(
				'errcode' => $errcode,
				'errmsg' => $errmsg
			)
		);
		if ($data) {
			$resp = array_merge($resp, $data);
		}
		$buffer = $this->AES_encode($resp, $aes_key);
		$resp_buffer = array(
			'errcode' => $errcode,
			'resp_buffer' => $buffer
		);
		$output = json_encode($resp_buffer);
		// wxlog($output);
		echo $output;
		exit(0);
	}

	public function RSA_decode($data, $rsa_private_key_path, $to_type = '')
	{
		$fp = fopen($rsa_private_key_path, 'r');
		$key = fread($fp, 8192);
		fclose($fp);
		$res = openssl_pkey_get_private($key);
		$data = base64_decode($data);
		if (openssl_private_decrypt($data, $decode, $res, OPENSSL_PKCS1_PADDING)) {
			if ($to_type == 'json') {
				$decode = json_decode($decode, true);
			}
			return $decode;
		} else {
			return false;
		}
	}

	public function AES_encode($data, $key)
	{
		$data = json_encode($data);
		wxlog($data);
		$iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC);
		$iv = mcrypt_create_iv($iv_size, MCRYPT_RAND);
		$encode = $this->AES256_cbc_encrypt($data, $key, $iv);
		$encode = base64_encode($iv . $encode);
		return $encode;
	}

	public function AES_decode($data, $key, $to_type = '')
	{
		$data = base64_decode($data);
		$iv_size = mcrypt_get_iv_size(MCRYPT_RIJNDAEL_128, MCRYPT_MODE_CBC);
		$iv = substr($data, 0, $iv_size);
		$encode = substr($data, $iv_size);
		// wxlog('iv: '.$iv);
		$decode = $this->AES256_cbc_decrypt($encode, $key, $iv);
		// wxlog('encode: '.$encode);
		if (!$decode) {
			return null;
		}
		if ($to_type == 'json') {
			$decode = json_decode($decode, true);
		}
		return $decode;
	}
	
	protected function AES256_cbc_encrypt($data, $key, $iv) {
		if (32 !== strlen($key)) $key = hash('SHA256', $key, true);
		if (16 !== strlen($iv)) $iv = hash('MD5', $iv, true);
		$padding = 16 - (strlen($data) % 16);
		$data .= str_repeat(chr($padding), $padding);
		return mcrypt_encrypt(MCRYPT_RIJNDAEL_128, $key, $data, MCRYPT_MODE_CBC, $iv);
	}

	protected function AES256_cbc_decrypt($data, $key, $iv) {
		if (32 !== strlen($key)) $key = hash('SHA256', $key, true);
		if (16 !== strlen($iv)) $iv = hash('MD5', $iv, true);
		$data = mcrypt_decrypt(MCRYPT_RIJNDAEL_128, $key, $data, MCRYPT_MODE_CBC, $iv);
		$padding = ord($data[strlen($data) - 1]);
		return substr($data, 0, -$padding);
	}

} // END

/* END file */