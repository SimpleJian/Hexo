title: JPEG图片压缩神器
categories:
  - 其他
tags:
  - TinyJPG
  - bash
date: 2014-11-30 12:07:38
---

昨天在微博上有人推荐[TinyJPG](https://tinyjpg.com/)，说是一款高保真JPEG图片压缩神器，我当时就试了2张图片，一张199.3k的压到104.2k，另一张3.6M的压到862.1k，关键是压缩后的图与压缩前的图片几乎肉眼无法分辨。

![压缩后](http://public-lingdian618.qiniudn.com/images/IMG_1545.JPG)
![压缩前](http://public-lingdian618.qiniudn.com/images/八达岭长城/IMG_1545.JPG)

于是乎，想着把博客Gallery页面中的图片都压缩下。[TinyJPG](https://tinyjpg.com/)提供了开发人员[API](https://tinypng.com/developers)，填写邮箱和姓名即可获取API key，免费用户每个月有500次压缩机会，对一般用户来说完全够用了。然后使用下面的语句提交图片进行压缩，完了会返回包含压缩后图片链接的结果。

提交图片进行压缩：
{% code lang:bash %}
curl -i --user api:YOUR_API_KEY --data-binary @large.png https://api.tinypng.com/shrink
{% endcode%}

返回结果示例：
{% code lang:bash %}
HTTP/1.1 100 Continue

HTTP/1.1 201 Created
Cache-Control: no-cache
Content-Type: application/json; charset=utf-8
Date: Sun, 30 Nov 2014 04:05:34 GMT
Location: https://api.tinypng.com/output/t3ovb77ss91l4tl5.jpg
Server: Apache/2
Strict-Transport-Security: max-age=31536000
X-Powered-By: Voormedia (voormedia.com/jobs)
Content-Length: 166
Connection: keep-alive

{"input":{"size":3624668,"type":"image/jpeg"},"output":{"size":862075,"type":"image/jpeg","ratio":0.2378,"url":"https://api.tinypng.com/output/t3ovb77ss91l4tl5.jpg"}}{% endcode %}

返回结果的末尾是一个JSON文件，其中包含了输入文件和输出文件的基本信息，压缩比，输出问题地址等。要实现批处理，关键在于从结果中提取输出文件的地址。于是搜了下如何用bash解析JSON，看到[stackoverflow](http://stackoverflow.com/questions/1955505/parsing-json-with-sed-and-awk)有人提到使用[jsawk](https://github.com/micha/jsawk)来做，但我在用的时候遇到一点小问题，可能跟系统环境有关。接着我发现返回结果的第6行中包含的Location字段其实就是输出文件的地址，使用awk可以很方便地得到这一行的信息。这样一来，批处理压缩图片也就很简单了，代码如下：
{% code lang:bash %}
#! /bin/bash
# 要压缩的图片目录，可包含多层子目录
src=$1
# 压缩图片存储目录
dst=$2
# 搜索JPG图片
for file in `find $src -name '*.JPG'`
do
  dir=`dirname $file`
  mkdir -p $dst/$dir
  # 提交单张图片进行压缩并下载压缩后的图片到本地
  curl -i --user api:hQgNGMmE4ThuaPn8AJj8EyV0ePoj8Mp2 --data-binary @$file https://api.tinypng.com/shrink | awk '/Location/{print $2}' | xargs -I '{}' curl -L '{}' > $dst/$dir/`basename $file`
done
{% endcode %}

