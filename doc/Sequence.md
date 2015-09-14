<h1 align=center>微信Auth Demo App交互时序说明文档</center></h1>

##目录
*   [一、建立登录前安全信道](#wow1)
*   [二、换取登录票据](#wow2)
	*   [利用微信SSO换取登录票据](#wow3)
	*   [利用App账号密码换取登录票据](#wow4)
	*   [注册App账号并换取登录票据](#wow5)
*   [三、使用登录票据登录并建立正式安全信道](#wow6)
*   [四、获得用户信息](#wow7)
*   [五、微信登录后绑定App账号](#wow8)
    *   [绑定已有的App账号](#wow9)
    *   [注册并绑定新App账号](#wow10)
*   [六、App登录后绑定微信号](#wow11)
*   [七、App登录态/SK过期](#wow12)
*   [八、微信登录的Token过期](#wow13)
    *   [Access Token过期](#wow14)
    *   [Refresh Token过期](#wow15)
    
<h2 id="wow1">一、建立登录前安全信道</h2>
<b>当App尚未登录服务器前，App与Server之间会经过一次握手建立登录前安全信道，时序图如下所示：</b>

<!--title 建立登录前安全信道的时序

note left of AppClient:  1. AppClient本地随机\n生成32个字节的密钥psk
AppClient->AppServer: 2. ConnectRequest: RSA公钥加密(psk)
note right of AppServer: 3. AppServer用RSA私钥解密(psk),\n保存psk，生成temp_uin

AppServer->AppClient: 4. ConnectResponse: psk作为密钥的\nAES加密(temp_uin)

note left of AppClient: 5. AppClient用psk作为密钥的\nAES解密保存temp_uin
-->
![](http://jeason.gitcafe.io/images/2015/09/02/connect.png)

<b>以下为详细说明:</b>

1. AppClient本地通过一些随机算法生成一个32bytes的密钥psk(*preSessionKey*)。

2. AppClient通过向服务器特定path发送HTTP请求包，内容为用HardCode在AppClient的RSA公钥加密的psk.

3. AppServer用RSA私钥解密包获得psk，生成一个临时的用户标示符temp_uin并建立```temp_uin<->psk```的映射。

4. AppServer用psk作为密钥，将```temp_uin```AES加密后用Base64 Encoding后返回给AppClient。

5. AppClient对回包进行Base64 Decode之后，用psk作为密钥进行AES解密获得temp_uin保存到内存中.

<b>至此AppClient和AppServer之间的登录前安全信道建立完成，之后一直至[使用登录票据登录AppServer](#wow6)之前，AppClient和AppServer都使用psk作为密钥加密报文，并把密文经过Base64Encode之后，并带上temp_uin一并发送出去。</b>

<h2 id="wow2">二、换取登录票据</h2>

<h3 id="wow3"> 利用微信SSO换取登录票据</h3>
<b>当用户点击“微信登录”按钮时，会触发利用微信SSO换取登录票据事件，此部分需在[登录前安全信道](#wow1)中进行，时序图如下所示：</b>

<!--title 利用微信SSO换取登录票据

note left of AppClient: 1. 拉起微信客户端，\n经过微信授权获得code参数

AppClient->AppServer: 2. WXLoginRequest: AES加密(code)+temp_uin

note left of AppServer: 3. 根据temp_uin索引到psk\n解密code

AppServer->WXOpenServer: 4. GetToken:{AppID,\n Code, AppSecret}

WXOpenServer->AppServer: 5. ReturnToken: {access_token,\n refresh_token, openId...}

note left of AppServer: 6. 根据OpenId查询Uin和LoginTicket，\n若无则生成新的Uin和LoginTicket

AppServer->AppClient: 7. WXLoginResponse: AES加密(loginTicket, Uin)

note left of AppClient: 8. 用psk解密Uin，\nLoginTicket并保存。
-->

![](http://jeason.gitcafe.io/images/2015/09/02/wxLogin.png)

<b>以下为详细说明: </b>

1. AppClient通过微信SDK拉起微信客户端，用户通过在微信客户端同意授权后，返回一个code给AppClient。

2. AppClient用psk对codeAES加密后进行Base64 Encode，连带temp_uin（明文）一并发给AppServer。

3. AppServer通过明文获得temp_uin并索引到psk，解密后获得code参数。

4. AppServer用存在本地的AppID，AppSecret以及code参数发向微信OpenServer请求Token信息。<font color=red size=4><b>注意，这里AppSecret只能存在于AppServer中，不能让AppClient直接请求Token信息。</b></font>

5. 微信的OpenServer返回用户的OpenId，AccessToken及其有效期，RefreshToken及其有效期等信息。

6. AppServer根据OpenId查询Uin，若无则生成新的Uin和LoginTicket，并建立```OpenId<->Uin<->LoginTicket```的映射。

7. AppServer用psk对{LoginTicket, Uin}加密后经过Base64 Encoding发送给AppClient。

8. AppClient收到，解密Uin和LoginTicket并保存到本地。

<h3 id="wow4"> 利用App账号密码换取登录票据</h3>
<b>当用户点击”普通登录“按钮时，会触发利用App账号密码换取登录票据事件，此部分需在[登录前安全信道](#wow1)中进行，时序图如下所示：</b>

<!--title 利用账号密码换取登录票据

note left of AppClient: 1. 获得输入的邮箱mail、\n密码（进行MD5后）pwdH1

AppClient->AppServer: 2. LoginRequest: AES加密(mail, pwdH1)

note right of AppServer: 3. 解密获得mail, pwdH1进行校验\n成功则返回Uin和LoginTicket

AppServer->AppClient: 4. LoginResponse: AES加密(Uin, LoginTicket)

note left of AppClient: 5. 用psk解密Uin，\nLoginTicket并保存。
-->

![](http://jeason.gitcafe.io/images/2015/09/02/login.png)

<b>以下为详细说明: </b>

1. AppClient对输入的邮箱校验格式无误后，对密码进行MD5获得pwdH1.

2. AppClient将mail和pwdH1用psk作为密钥进行AES加密并Base64 Encode后，连带temp_uin（明文）一并发给AppServer。

3. AppServer通过明文获得temp_uin并索引到psk，解密后获得mail，pwdH1，并对pwdH1加盐后进行二次MD5得到pwdH2。AppServer匹配mail和pwdH2，若匹配成功则利用mail查找对应的Uin，LoginTicket。

4. AppServer用psk对{LoginTicket, Uin}加密后经过Base64 Encoding发送给AppClient。

5. AppClient收到，解密Uin和LoginTicket并保存到本地。


<h3 id="wow5"> 注册App账号并换取登录票据</h3>
<b>当用户点击"现在注册"按钮时，会触发注册App账号并换取登录票据事件，此部分需在[登录前安全信道](#wow1)中进行，时序图如下所示 ：</b>

<!--title 注册App账号并换取登录票据

note left of AppClient: 1. 获得输入的邮箱mail、\n密码（进行MD5后）pwdH1、\n昵称nickName等

AppClient->AppServer: 2. RegisterRequest: AES加密(mail, pwdH1, nickName...)

note right of AppServer: 3. 解密获得信息后注册新用户\n，成功则返回Uin和LoginTicket

AppServer->AppClient: 4. RegisterResponse: AES加密(Uin, LoginTicket)

note left of AppClient: 5. 用psk解密Uin，\nLoginTicket并保存。
-->

![](http://jeason.gitcafe.io/images/2015/09/02/register.png)

<b>以下为详细说明:</b>

1. AppClient对输入的邮箱，昵称等校验格式无误后，对密码进行MD5获得pwdH1.

2. AppClient将mail、pwdH1，nickName等AES加密后进行Base64 Encode，连带temp_uin（明文）一并发给AppServer。

3. AppServer通过明文获得temp_uin并索引到psk，解密获得信息，并对pwdH1加盐后进行二次MD5得到pwdH2。AppServer根据信息新建用户，若成功则建立```mail<->Uin<->LoginTicket```的映射。

4. AppServer用psk对{LoginTicket, Uin}加密后经过Base64 Encoding发送给AppClient。

5. AppClient收到后，解密Uin和LoginTicket并保存到本地。

<h2 id="wow6">三、使用登录票据登录并建立正式安全信道</h2>
<b>当AppClient获得正式Uin和LoginTicket时，会触发通过登录票据登录AppServer事件，此部分跟安全信道无关，时序图如下所示 ：</b>

<!--title 通过登录票据登录AppServer

note left of AppClient: 1. AppClient本地随机\n生成32个字节的密钥temp_key

AppClient->AppServer: 2. CheckLoginRequest: RSA公钥加密\n(temp_key, Uin, LoginTicket)

note right of AppServer: 3. RSA私钥解密temp_key,Uin,\n LoginTicket, 生成SK和expireTime

AppServer->AppClient: 4. CheckLoginResponse: temp_key\n作为密钥的AES加密(SK，expireTime)

note left of AppClient: 5. 用temp_key解密SK，\nexpireTime并保存。
-->

![](http://jeason.gitcafe.io/images/2015/09/02/checkLogin.png)

<b>以下为详细说明:</b>

1. AppClient本地通过一些随机算法生成一个32bytes的密钥temp_key。

2. AppClient用HardCode在AppClient的RSA公钥加密的temp_key, Uin, LoginTicket发送给服务器.

3. AppServer通过RSA私钥解密获得temp_key, Uin, LoginTicket, 之后尝试匹配Uin和LoginTicket并且检查LoginTicket是否过期。如果票据是很久之前（例如三个月之前的）生成的，或者最近没有使用过（例如一周没使用过），那么票据就是过期的。若检查都成功则生成一个密钥SK(*SessionKey*)和对应的过期时间expireTime，并建立```Uin<->SK```的映射。
4. AppServer用temp_key对{SK, expireTime}进行AES加密后经过Base64 Encoding发送给AppClient。

5. AppClient收到后，用temp_key作为密钥解密获得SK和expireTime并保存到内存。

<b>至此，AppClient和AppServer之间的正式安全信道建立完成，直至expireTime之前，AppClient和AppServer都使用SK作为密钥加密报文，并把密文经过Base64Encode之后，并带上Uin（明文）一并发送出去。 </b>

<h2 id="wow7">四、获得用户信息</h2>
<b>当AppClient获得SK和expireTime时，会触发获得用户信息事件，此部分需在[正式安全信道](#wow6)中进行，时序图如下所示 ：</b>

<!--title 获得用户信息

AppClient->AppServer: 1. GetUserInfoRequest:SK\n作为密钥的AES加密(Uin, LoginTicket)+Uin

note left of AppServer: 2. 解密获得Uin,LoginTicket,\n若Uin和LoginTicket匹配，\n则根据Uin查询用户信息


AppServer->WXOpenServer: 3. GetWXInfo: {OpenId, AccessToken}

WXOpenServer->AppServer: 4. ReturnWXInfo:{headimgurl,nickname...}

AppServer->AppClient: 5. GetUserInfoResponse: SK\n作为密钥的AES加密(App信息,微信信息)

note left of AppClient: 6. 解密用户信息\n并保存显示。
-->

![](http://jeason.gitcafe.io/images/2015/09/02/getUserInfo.png)

<b>以下为详细说明:</b>

1. AppClient用SK对｛Uin，LoginTicket｝加密并Base64 Encode之后，与Uin(明文)一同发给AppServer。

2. AppServer通过明文获得Uin并索引到SK，若SK已过期，则触发[App登录态/SK过期](#wow12)子事件, 否则解密获得LoginTicket。之后查询Uin和LoginTicket是否匹配，若成功，则根据Uin查询获得用户OpenId等用户信息。

3. AppServer利用OpenId和AccessToken向WXOpenServer查询用户的微信信息。<font color=red size=4>注意，这里AccessToken和RefreshToken只能存在于AppServer中，不能让AppClient直接请求微信用户信息。</font>
	
4. 若AccessToken未过期，WXOpenServer返回对应的微信用户信息，包括微信昵称，头像Url等，若已过期，则触发[微信登录的Token过期](#wow13)子事件。

5. AppServer用SK对用户信息（包括昵称，头像，OpenId，AccessToken有效期，Refresh Token有效期）进行AES加密发送给AppClient。

6. AppClient收到后，用SK作为密钥解密获得用户信息并保存到内存中和展示在屏幕上。

<h2 id="wow8">五、微信登录后绑定App账号</h2>
<b> 用户[微信登录](#wow2)后，在未绑定App账号的情况下点击"绑定App账号"按钮时，会触发微信登录后绑定App账号事件，此部分需在[正式安全信道](#wow6)中进行。分为绑定已有的App账号和注册并绑定新App账号两种情况。</b>

<h3 id="wow9">绑定已有的App账号</h3>
<b>用户通过输入App账号密码进行绑定，会触发绑定已有的App账号子事件，时序图为：</b>

<!--title 绑定已有的App账号

note left of AppClient: 1. 获得输入的邮箱mail、\n密码（进行MD5后）pwdH1

AppClient->AppServer: 2. wxBindAppRequest:AES加密(code, pwdH1)

note right of AppServer: 3. 根据明文获得Uin1\n解密获得mail, pwdH1进行校验\n成功则获得Uin2和LoginTicket2\n根据Uin1查询微信登录信息\n让微信登录信息跟Uin2绑定

AppServer->AppClient: 4. wxBindAppResponse: AES加密(Uin2, LoginTicket2)

note left of AppClient: 5. 用psk解密Uin2，LoginTicket2\n并替换原来的Uin1和LoginTicket1\n保存并重新登录服务器。
-->

![](http://jeason.gitcafe.io/images/2015/09/02/bindAppLogin.png)

<b>以下为详细说明:</b>

1. AppClient对输入的邮箱校验格式无误后，对密码进行MD5获得pwdH1.

2. AppClient将mail和pwdH1用SK作为密钥进行AES加密并Base64 Encode后，连带当前的Uin，称为Uin1（明文）一并发给AppServer。

3. AppServer通过明文获得Uin1并索引到SK, 若SK已过期，则触发[App登录态/SK过期](#wow12)子事件, 否则解密获得mail，pwdH1，并对pwdH1加盐后进行二次MD5得到pwdH2。AppServer匹配mail和pwdH2，若匹配成功则利用mail查找对应的Uin2，LoginTicket2。根据Uin1查询OpenId，然后建立```Uin2<->OpenId```的映射。

4. AppServer用SK对{LoginTicket2, Uin2}加密后经过Base64 Encoding发送给AppClient。

5. AppClient收到，解密获得Uin2和LoginTicket2并替换Uin1和LoginTicket1。因为Uin已经改变，这时候需要重新[登录AppServer](#wow6)以刷新用户信息。

<h3 id="wow10">注册并绑定新App账号</h3>
<b>用户通过注册新的App账号进行绑定，会触发注册并绑定新App账号子事件，时序图为：</b>

<!--title 注册并绑定新App账号

note left of AppClient: 1. 获得输入的邮箱mail、\n密码（进行MD5后）pwdH1、\n昵称nickName等

AppClient->AppServer: 2. wxBindAppRequest: AES加密(mail, \npwdH1, nickName...)+Uin

note right of AppServer: 3. 解密获得信息后注册新用户,\n并与微信登录信息绑定，\n成功则返回Uin和LoginTicket

AppServer->AppClient: 4. AES加密(Uin, LoginTicket)

note left of AppClient: 5. 解密获得Uin和LoginTicket，\n重新获得用户信息。
-->

![](http://jeason.gitcafe.io/images/2015/09/02/bindAppRegister.png)

<b>以下为详细说明：</b>

1. AppClient对输入的邮箱，昵称等校验格式无误后，对密码进行MD5获得pwdH1.

2. AppClient将mail、pwdH1，nickName等AES加密后进行Base64 Encode，连带Uin（明文）一并发给AppServer。

3. AppServer通过明文获得Uin并索引到SK，若SK已过期，则触发[App登录态/SK过期](#wow12)子事件, 否则解密获得信息，并对pwdH1加盐后进行二次MD5得到pwdH2。AppServer根据信息新建用户，若成功则建立```mail<->Uin```的映射，再加上之前[微信登录](#wow2)建立的```Uin<->OpenId```的映射即可完成绑定。

4. AppServer用SK对{LoginTicket, Uin}加密后经过Base64 Encoding发送给AppClient。

5. AppClient收到后，解密Uin和LoginTicket并重新[获取用户信息](#wow7)。

<h2 id="wow11">六、App登录后绑定微信号</h2>
<b>用户用[账号密码登录](#wow3)后，在未绑定微信号的情况下点击“绑定微信号”按钮，会触发App登录后绑定微信号事件。此部分需在[正式安全信道](#wow6)中进行，时序图为：</b>

<!--title App登录后绑定微信号

note left of AppClient: 1. 拉起微信客户端，\n经过微信授权获得code参数

AppClient->AppServer: 2. appBindWXRequest: AES加密(code)+Uin

note left of AppServer: 3. 根据Uin索引到SK，\n解密获得Code

AppServer->WXOpenServer: 4. GetToken:{AppID,\ncode, AppSecret}

WXOpenServer->AppServer: 5. ReturnToken: {access_token,\n refresh_token, openId...}

note left of AppServer: 6. OpenId和Uin绑定

AppServer->AppClient: 7. appBindWXResponse: AES加密{Uin, LoginTicket}

note left of AppClient: 8. 解密获得Uin和LoginTicket，\n重新获得用户信息。
-->

![](http://jeason.gitcafe.io/images/2015/09/02/appBindWX.png)

<b>以下为详细说明：</b>

1. AppClient通过微信SDK拉起微信客户端，用户通过在微信客户端同意授权后，返回一个code给AppClient。

2. AppClient用SK对codeAES加密后进行Base64 Encode，连带Uin（明文）一并发给AppServer。

3. AppServer通过明文获得Uin并索引到SK，若SK已过期，则触发[App登录态/SK过期](#wow12)子事件, 否则解密后获得code参数。

4. AppServer用存在本地的AppID，AppSecret以及code参数发向微信OpenServer请求Token信息。<font color=red size=4><b>注意，这里AppSecret只能存在于AppServer中，不能让AppClient直接请求Token信息。</b></font>

5. 微信的OpenServer返回用户的OpenId，AccessToken及其有效期，RefreshToken及其有效期等信息。

6. AppServer建立```OpenId<->Uin```的映射,这样就算完成了绑定。

7. AppServer用psk对{LoginTicket, Uin}加密后经过Base64 Encoding发送给AppClient。

8. AppClient收到，解密Uin和LoginTicket并重新[获取用户信息](#wow7)。

<h2 id="wow12">七、App登录态/SK过期</h2>

<b>当AppServer在[获得用户信息](#wow7)或[微信登录后绑定App账号](#wow8)或[App登录后绑定微信号](#wow11)子事件中发现SK过期时，会触发App登录态/SK过期事件。此部分只需要执行之前的子事件即可，是否为安全通道由具体子事件决定，时序图如下：</b>

<!--title App登录态/SK过期

AppClient->AppServer: 1. GetUserInfoRequest或\nwxBindAppRequest或\nappBindWXRequest

note right of AppServer: 2. 发现SK过期

AppServer->AppClient: 3. ErroCode = SK Expired

note left of AppClient: 4. 收到错误码，\n重新登录

AppClient->AppServer: 5. CheckLoginRequest

note right of AppServer: 6. 重新生成SK和有效期

AppServer->AppClient: 7. CheckLoginResponse

note left of AppClient: 8. 更新SK和有效期\n重发请求

AppClient->AppServer: 9. GetUserInfoRequest或\nwxBindAppRequest或\nappBindWXRequest
-->

![](http://jeason.gitcafe.io/images/2015/09/02/SKExpired.png)

<b>以下为详细说明：</b>

1. AppClient发起GetUserInfoRequest或wxBindAppRequest或appBindWXRequest请求.

2. AppServer通过Uin索引到SK，并查找SK的有效期，发现SK已过期。

3. AppServer返回一个错误码标识SK已经过期。

4. AppClient收到错误码后重新执行[使用登录票据登录并建立正式安全信道](#wow6)子事件.

5. AppClient重新发起GetUserInfoRequest或wxBindAppRequest或appBindWXRequest请求.


<h2 id="wow13">八、微信登录的Token过期</h2>

<b>当AppServer在[获得用户信息](#wow7)子事件中通过OpenId和AccessToken向WXOpenServer请求微信信息时，发现AccessToken过期，会触发微信登录的Token过期事件。此部分分为AccessToken过期和RefreshToken过期两种情况。以下为分别描述：</b>

<h3 id="wow14">Access Token过期</h3>

<b>若只是AccessToken，AppServer需要用RefreshToken去刷新AccessToken。这部分与安全信道无关，时序图如下：</b>

<!--title Access Token过期

note left of AppServer: 1. 发现AccessToken过期

AppServer->WXOpenServer: 2. {AppId, RefreshToken}

WXOpenServer->AppServer: 3. {New AccessToken ExpireTime}

note left of AppServer: 4. 再次请求微信信息
-->
![](http://jeason.gitcafe.io/images/2015/09/02/accessTokenExpired.png)

<b>以下为详细说明：</b>

1. AppServer在向WXOpenServer请求微信用户信息的过程中发现AccessToken过期.

2. AppServer向WXOpenServer发起刷新AccessToken请求，请求里带上AppId和RefreshToken。<font color=red size=4>注意，这里AccessToken和RefreshToken只能存在于AppServer中，不能让AppClient直接刷新AccessToken。</font>

3. WXOpenServer将新的AccessToken过期时间返回给AppServer。

4. AppServer刷新AccessToken的有效期并再次请求用户的微信信息.

<h3 id="wow15">Refresh Token过期</h3>

<b>若AppServer在刷新AccessToken的过程中发现RefreshToken过期，则需要让AppClient重新进行微信授权以获得新的RefreshToken。此部分需在[正式安全信道](#wow6)中进行，时序图为:</b>

<!--title Refresh Token过期

AppClient->AppServer: 1. 获得用户信息

note right of AppServer: 2. 发现RefreshToken过期

AppServer->AppClient:  3. ErrorCode = RefreshToken Expired

note over AppClient, AppServer: 4. 重新进行利用微信SSO\n换取登录票据子事件

note left of AppClient: 5. 重新登录AppServer\n并获取用户信息
-->

![](http://jeason.gitcafe.io/images/2015/09/02/refreshTokenExpired.png)

<b>以下为详细说明：</b>

1. AppClient向AppServer请求用户信息。

2. AppServer向WXOpenServer请求微信用户信息的过程中发现RefreshToken过期。

3. AppServer给AppServer返回一个错误码标识Refresh Token过期了。

4. AppClient收到错误码后重新触发[利用微信SSO换取登录票据](#wow2)子事件。

5. AppClient重新触发[使用登录票据登录并建立正式安全信道](#wow6)子事件并重新[获取用户信息](#wow7)。