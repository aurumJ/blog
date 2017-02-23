---
title: 关于 Android 使用 HTTPS 的学习记录
date: 2017-02-20 16:41:37
tags:
  - Android
  - HTTPS
  - 原创
---

### 起因
之前因为手机应用的安全性问题特意的组织讨论了一下,鉴于项目特性(功能验证),并非是实际场景应用,以及使用加密算法如果一旦数量级过高可能会造成服务器的负担,所以初步考虑先把 HTTPS 连接调通,保证基础的通道安全.

### 想法
因为服务端我并没有涉及,所以服务端的 HTTPS 相关配置由其他人去更改,在这个期间还是希望自己能和服务器端同步动作,但是没有一个支持 HTTPS 的后端测试起来相当麻烦,所以打算借助 GO 语言实现一个简易的支持 HTTPS 的服务端(真的很简易,就两行代码,但是生成 SSL 证书可是苦恼了我好久).

### 证书生成
关于各种证书这方面到现在我还没有具体的弄明白,可能是我太愚笨了,不过按照 Google 中的各种大神分享出来的相关资料还是弄出了一个可以用的证书.

以下是我生成证书的流程(此处只做记录,仅供参考,系统为 win7 64位):

- 下载并安装 [OpenSSL](http://slproweb.com/products/Win32OpenSSL.html) (关于下载版本与安装流程不做说明)
- 运行 OpenSSL
  - 生成 rsa 私钥
    ```
    # 生成服务器端私钥
    OpenSSL> genrsa -out server.key 1024
    # 生成服务器端公钥
    OpenSSL> rsa -in server.key -pubout -out server.pem
    # 生成客户端私钥
    OpenSSL> genrsa -out client.key 1024
    # 生成客户端公钥
    OpenSSL> rsa -in client.key -pubout -out client.pem

    ```

  - 生成 CA 的 crt
    ```
    # 生成 CA 私钥
    OpenSSL> genrsa -out ca.key 1024
    # X.509 Certificate Signing Request (CSR) Management.
    OpenSSL> req -new -key ca.key -out ca.csr
    # X.509 Certificate Data Management.
    openssl x509 -req -in ca.csr -signkey ca.key -out ca.crt
    ```
    生成的 ca.crt 文件是用来签署下面的 server.csr 文件.

  - 生成服务器证书
    ```
    # 服务器端需要向 CA 机构申请签名证书，在申请签名证书之前依然是创建自己的 CSR 文件
    openssl req -new -key server.key -out server.csr
    # 向自己的 CA 机构申请证书，签名过程需要 CA 的证书和私钥参与，最终颁发一个带有 CA 签名的证书
    openssl x509 -req -CA ca.crt -CAkey ca.key -CAcreateserial -in server.csr -out server.crt
    # client 端
    openssl req -new -key client.key -out client.csr
    # client 端到 CA 签名
    openssl x509 -req -CA ca.crt -CAkey ca.key -CAcreateserial -in client.csr -out client.crt
    ```
    这条命令执行后需要之前的私钥密码,并且需要依次输入国家,地区,组织,email.  common name 这个需要输入域名或者 IP 地址.在本地测试就输入 localhost

    _如果连续输入两次 req 命令可能会导致报出以下错误_
    ![req error](http://olihtbm3u.bkt.clouddn.com/image/02/20/req_error.png)
    _当然,作为一个临时使用的工具,能够绕过的问题就不算是问题,这个问题也是可以绕过的,既然不能连续输入两次那么就输入一次 req 命令之后重新打开 OpenSSL 即可.(这是一个笨方法,不过有效)_

### 服务器端搭建与证书验证
- 搭建服务器

  由于这次主要是记录 HTTPS 在 Android 方面的使用,所以服务器端代码直接记录下来,不具体描述(就两行代码).
  ```Go
  package main

  import (
	   "net/http"
	    "log"
	     "io"
     )

  func main() {
  	http.HandleFunc("/", func(w http.ResponseWriter, req *http.Request) {
  		io.WriteString(w, "hello, world!\n")
  	})
  	if e := http.ListenAndServeTLS(":8081", "server.crt", "server.key", nil); e != nil {
  		log.Fatal("ListenAndServe: ", e)
  	}
}
  ```
  其中 "server.crt" 即使上文生成的服务器证书, "server.key" 即使上文生成的服务器密钥
- 电脑上进行连接测试

  在访问各个支持 HTTPS 的网站时,如 Google/Baidu 我们会看到如下提示

  ![Google_HTTPS](http://olihtbm3u.bkt.clouddn.com/image/02/20/Google_Https.png)

  但是当我们访问自己签名的服务器时,则获得了另一种提示

  ![MY_HTTPS_UNSAFE](http://olihtbm3u.bkt.clouddn.com/image/02/20/MY_HTTPS_UNSAFE.png)

  这里就有一个疑问了,都是 HTTPS 的连接为什么他们的网站就是安全而我们自己搭建的服务器就是不安全呢的?

  答案就是 HTTPS 的证书签名了,我们自己搭建的这个服务器端的证书是由自己生成的根证书签名的,而不是由 CA 机构签名的,浏览器并不认识你这个颁发者,所以浏览器认为你这个网站是不安全的.

  为了让浏览器信任我们自己的根证书,我们需要把根证书安装上:

    - 双击 ca.crt
    - 点击安装证书
    - 注意要将证书放在 <受信任的根证书颁发机构>

  _证书安装完成后可能不会马上生效,可能会有一定的延时且需要将浏览器彻底关闭_

  安装完根证书并重启了浏览器后在访问 https://localhost:8081/ 就可以看到自己的连接是安全的了

  ![MY_HTTP_SAFE](http://olihtbm3u.bkt.clouddn.com/image/02/20/MY_HTTPS_SAFE.png)

### Android 应用使用 HTTPS 连接
这里我们尝试用 okhttp 访问 HTTP 连接的方式来访问 HTTPS 连接,会报出以下错误:
```
java.security.cert.CertPathValidatorException:
    Trust anchor for certification path not found.
```
以上错误表明我们服务器的证书不可信,也就是因为我们的服务器证书是由自己签名生成的,所以没有被信任,如果你尝试用这种方式访问 https://www.baidu.com 你就会发现你能访问成功,因为百度的正式是由 CA 机构签名办法的,得到了信任,我们自签名的当然就没有这种待遇了.那么如何解决这个问题呢?

其实和电脑端的解决办法差不多,那就是由我们自己效验证书并信任.
```java
//从 server.crt 中读取出来的字符串
String CER_CLIENT = "-----BEGIN CERTIFICATE-----\n" +
            "MIICIzCCAYwCCQC+PtNg8W5AwTANBgkqhkiG9w0BAQsFADBUMQswCQYDVQQGEwJD\n" +
            "TjEQMA4GA1UECAwHQmVpSmluZzEQMA4GA1UEBwwHQmVpamluZzENMAsGA1UECgwE\n" +
            "TXlDQTESMBAGA1UEAwwJbG9jYWxob3N0MB4XDTE3MDIyMzAzMTY1MloXDTE3MDMy\n" +
            "NTAzMTY1MlowWDELMAkGA1UEBhMCQ04xEDAOBgNVBAgMB0JlaUppbmcxEDAOBgNV\n" +
            "BAcMB0JlaUppbmcxETAPBgNVBAoMCE15U2VydmVyMRIwEAYDVQQDDAlsb2NhbGhv\n" +
            "c3QwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMo9KveK/dTgcX7Yv+Q4LaFF\n" +
            "N3s22ahcYS/RgSH5gCQ11iVDylsBRYcwRY9ayTIbdOW/eZpuWZkiju0cBPprj3/1\n" +
            "fmWW1lMcI/vN96spXSJ7pbODDn5IJS5nU+bqRI5FEx2jzdQxLL1NZ+OkoN3GECpn\n" +
            "JKwdB734cX5xnJGM77nlAgMBAAEwDQYJKoZIhvcNAQELBQADgYEAN+Aa4oFDVvSs\n" +
            "Vuts6lxnZegeY1+UQlYNqJNfUh4RvHt7dBVvbqdwJKTxi7FrYjVfc/83FqC3RzYG\n" +
            "4CwesgdHon8a/nd6+zT2NVi4QUfKG5XopvTobpSd8sZq2I7uVM3q3UPIBz3yVaNz\n" +
            "YTMaf4xo5Ys3/1pm0/kO5oPDWp5A3Pw=\n" +
            "-----END CERTIFICATE-----";
/**
* 实现了 X509TrustManager
* 通过此类中的 checkServerTrusted 方法来确认服务器证书是否正确
*/
class MyTrustManager implements X509TrustManager {
       X509Certificate cert;

       MyTrustManager(X509Certificate cert) {
           this.cert = cert;
       }

       @Override
       public void checkClientTrusted(X509Certificate[] chain, String authType) throws CertificateException {
           // 我们在客户端只做服务器端证书校验。
       }

       @Override
       public void checkServerTrusted(X509Certificate[] chain, String authType) throws CertificateException {
           // 确认服务器端证书和代码中 hard code 的 CRT 证书相同。
           if (chain[0].equals(this.cert)) {
               Log.i("Jin", "checkServerTrusted Certificate from server is valid!");
               return;// found match
           }
           throw new CertificateException("checkServerTrusted No trusted server cert found!");
       }

       @Override
       public X509Certificate[] getAcceptedIssuers() {
           return new X509Certificate[0];
       }
   }
   /**
  * 进行 HTTPS 访问测试
  * @throws NoSuchAlgorithmException
  * @throws KeyManagementException
  */
 private void testHttps() throws NoSuchAlgorithmException, KeyManagementException {
     SSLContext sc = SSLContext.getInstance("TLS");
     //信任证书管理,这个是由我们自己生成的,信任我们自己的服务器证书
     TrustManager tm = new MyTrustManager(readCert(CER_CLIENT));
     sc.init(null, new TrustManager[]{
             tm
     }, null);
     OkHttpClient okHttpClient = new OkHttpClient().newBuilder()
             .sslSocketFactory(sc.getSocketFactory(), (X509TrustManager) tm)
             .hostnameVerifier(hostnameVerifier)
             .build();
     Call call = okHttpClient.newCall(new Request.Builder().url("https://192.168.0.232:8081").get().build());
     call.enqueue(new Callback() {
         @Override
         public void onFailure(Call call, IOException e) {
             Log.i("Jin", "Failure :" + e.getMessage());
         }

         @Override
         public void onResponse(Call call, Response response) throws IOException {
             final String res = response.body().string();
             Log.i("Jin", "Response :" + res);
         }
     });
 }

 //主机地址验证
 final HostnameVerifier hostnameVerifier = new HostnameVerifier() {
     @Override
     public boolean verify(String hostname, SSLSession session) {
         return hostname.equals("192.168.0.232");
     }
 };

 /**
  * 根据字符串读取出证书
  * @param cer
  * @return
  */
 private static X509Certificate readCert(String cer) {
     if (cer == null || cer.trim().isEmpty())
         return null;
     InputStream caInput = new ByteArrayInputStream(cer.getBytes());
     X509Certificate cert = null;
     try {
         CertificateFactory cf = CertificateFactory.getInstance("X.509");
         cert = (X509Certificate) cf.generateCertificate(caInput);
     } catch (Exception e) {
         e.printStackTrace();
     } finally {
         try {
             if (caInput != null) {
                 caInput.close();
             }
         } catch (Throwable ex) {
         }
     }
     return cert;
 }
```
运行后可以看到控制台返回:
```
I/Jin: Response :hello, world!
```
通过以上的方法就可以访问我们自己签名的 HTTPS 服务器了.

以下为在学习 HTTPS 相关内容时查询的一些资料,还有一些因为没有记录的原因,未能找到,如果有相关内容涉及到您的分享,请联系我处理.

感谢这个分享知识的人.

>[ Android Https 相关完全解析 当 OkHttp 遇到 Https](http://blog.csdn.net/lmj623565791/article/details/48129405)

>[HTTPS 证书生成原理和部署细节](http://www.barretlee.com/blog/2015/10/05/how-to-build-a-https-server/)
