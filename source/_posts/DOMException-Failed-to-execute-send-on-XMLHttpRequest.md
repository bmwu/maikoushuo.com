---
title: 'DOMException: Failed to execute ''send'' on ''XMLHttpRequest'''
date: 2017-09-29 11:25:58
tags: Http
---

The problem is the synchronous option specified by:

`async: false`,
This seems not to work in Chrome probably because of the specification of the jQuery's ajax method, which says:

**Cross-domain requests** and **dataType: "jsonp" requests** do not support synchronous operation.
The strange of the situation is that Firefox and Internet Explorer seem to ignore that specification and they both perform the http request and return the XML result.



```java
<script>
    // ...
    $.ajax(... async: false ...); // Hey browser! first complete this request, 
                                  // then go for other codes

    $.ajax(...); // Executed after the completion of the previous async:false request.
</script>
```

When async setting is set to false, a Synchronous call is made instead of an Asynchronous call.

When the async setting of the jQuery AJAX function is set to true then a jQuery Asynchronous call is made. AJAX itself means Asynchronous JavaScript and XML and hence if you make it Synchronous by setting async setting to false, it will no longer be an AJAX call.

You should mostly always use an asynchronous Ajax Request, in fact I know only about one place where a synchronous Ajax Request should be used which is if you're in an Ajax Request embedding a new JavaScript file on the client and then referencing types and/or objects from that JavaScript file in the return from the original Ajax Request. Then the fetching of this new JS file should (or can sanely) be included through using a synchronous Ajax Request...

Other then that you should *always* use asynchronous Ajax Requests. The most important reason is that a synchronous Ajax Request makes the UI (browser) unresponsive...

