---
title: HttpClient长连接问题
date: 2017-09-19 17:29:55
tags: Http
---

## httpclient 出现NoHttpResponseException的异常解决

用httpClient写了个简单的测试:

```java
@Test
// 测试长连接问题
public void keepAlive() throws Exception {
  Map<String, String> params = new HashMap<>();
  params.put("id", "id");
  HttpClient  httpClient = getHttpClient(30000);
  HttpClientPost(httpClient, "http://127.0.0.1:6500/test", "utf-8", params);
  HttpClientPost(httpClient, "http://127.0.0.1:6500/test", "utf-8", params);
}

private HttpClient getHttpClient(int timeout) {
  RequestConfig.Builder requestBuilder = RequestConfig.custom();
  requestBuilder = requestBuilder.setConnectTimeout(timeout);
  requestBuilder = requestBuilder.setSocketTimeout(timeout);
  requestBuilder = requestBuilder.setConnectionRequestTimeout(timeout);

  HttpClientBuilder builder = HttpClientBuilder.create();
  builder.setDefaultRequestConfig(requestBuilder.build());
  return builder.build();
}

private void HttpClientPost(HttpClient httpclient, String url , String charset , Map<String, String> map) throws Exception  {
  HttpPost httpPost = new HttpPost(url);
  List<NameValuePair> nvps = new ArrayList<>();
  for (Map.Entry<String, String> obj : map.entrySet()) {
    nvps.add(new BasicNameValuePair(obj.getKey() , obj.getValue()));
  }
  httpPost.setEntity(new UrlEncodedFormEntity(nvps));
  HttpResponse response2 = httpclient.execute(httpPost);
  try {
    HttpEntity entity2 = response2.getEntity();
    System.out.println(EntityUtils.toString(entity2));
  } finally {
  }
}
```

maven
```xml
<dependency>
  <groupId>org.apache.httpcomponents</groupId>
  <artifactId>httpclient</artifactId>
  <version>4.5</version>
</dependency>
```



但在测试过程中发现，第一次没有问题, 接下来出现如下的异常

```shell
org.apache.http.NoHttpResponseException: 127.0.0.1:80 failed to respond
	at org.apache.http.impl.conn.DefaultHttpResponseParser.parseHead(DefaultHttpResponseParser.java:143)
	at org.apache.http.impl.conn.DefaultHttpResponseParser.parseHead(DefaultHttpResponseParser.java:57)
```

网上查了相关的报错信息，找到官网上的描述

```
org.apache.commons.httpclient.NoHttpResponseException java.io.IOException +- org.apache.commons.httpclient.NoHttpResponseExceptionIn some circumstances, usually when under heavy load, the web server may be able to receive requests but unable to process them. A lack of sufficient resources like worker threads is a good example. This may cause the server to drop the connection to the client without giving any response. HttpClient throws NoHttpResponseException when it encounters such a condition. In most cases it is safe to retry a method that failed with NoHttpResponseException.
```

根据描述主要就是因为服务端断开连接，但并没有通知客户端，导致下次请求该服务时httpclient继续使用该连接导致报错。