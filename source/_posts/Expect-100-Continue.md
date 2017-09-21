---
title: 'Expect: 100-Continue'
date: 2017-09-20 19:26:53
tags: Http
---



昨天碰到个客户问题, 客户用HttpClient发送请求, 结果返回的[response出现NoHttpResponseException的异常](http://maikoushuo.com/2017/09/19/HttpClient%E9%95%BF%E8%BF%9E%E6%8E%A5%E9%97%AE%E9%A2%98/). 昨天自己写了个测试用例跑了下, 以为问题解决了. 结果今天客户报还是有问题.  一阵苦恼.

后来比较了我的测试用例和客户的代码发现有细微出入: isExpectContinueEnabled. 这个method到底是何方神圣呢, 首先贴修改后的代码, 只加了`  requestBuilder = requestBuilder.setExpectContinueEnabled(true);`

```java
private HttpClient getHttpClient(int timeout) {
  RequestConfig.Builder requestBuilder = RequestConfig.custom();
  requestBuilder = requestBuilder.setConnectTimeout(timeout);
  requestBuilder = requestBuilder.setSocketTimeout(timeout);
  requestBuilder = requestBuilder.setExpectContinueEnabled(true);
  requestBuilder = requestBuilder.setConnectionRequestTimeout(timeout);

  HttpClientBuilder builder = HttpClientBuilder.create();
  builder.setDefaultRequestConfig(requestBuilder.build());
  return builder.build();
}
```

接着我们来细把一下, 正宗官方说明: [isExpectContinueEnabled](https://hc.apache.org/httpcomponents-client-ga/httpclient/apidocs/org/apache/http/client/config/RequestConfig.html#isExpectContinueEnabled())

```reStructuredText
public boolean isExpectContinueEnabled()
Determines whether the 'Expect: 100-Continue' handshake is enabled for entity enclosing methods. The purpose of the 'Expect: 100-Continue' handshake is to allow a client that is sending a request message with a request body to determine if the origin server is willing to accept the request (based on the request headers) before the client sends the request body.
The use of the 'Expect: 100-continue' handshake can result in a noticeable performance improvement for entity enclosing requests (such as POST and PUT) that require the target server's authentication.

'Expect: 100-continue' handshake should be used with caution, as it may cause problems with HTTP servers and proxies that do not support HTTP/1.1 protocol.

Default: false
```



估计大部分人看的云里雾里的, 那这篇文章['Expect: 100-Continue' Issues and Risks](https://support.urbanairship.com/hc/en-us/articles/213492003--Expect-100-Continue-Issues-and-Risks)就道出了原因, 

```reStructuredText
How the Expect: 100-Continue Header Works

When Expect: 100-Continue is NOT present, HTTP follows approximately the following flow (from the client's point of view):

The request initiates a TCP connection to the server.
When the connection to the server is established, the full request--which includes both the request headers and the request body--is transmitted to the server.
The client waits for a response from the server (comprised of response headers and a response body).
If HTTP keep-alives are supported, the request is optionally repeated from step 2.
When the client is using the Expect: 100-Continue feature, the following events occur:

The request initiates a TCP connection to the server.
When the connection to the server is established, the request--including the headers, the Expect: 100-Continue header, without the request body--is then transmitted to the server.
The client then waits for a response from the server.
If the status code is a final status code, using the prior steps above the client retries the request without Expect: 100-Continue header.
If the status code is 100-Continue, the request body is sent to the server.
The client will then wait for a response from the server (comprised of response headers and a response body).
If HTTP keep-alives are supported, the request is optionally repeated from step 2
```





