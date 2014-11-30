title: Hexo博客访问速度优化
date: 2014-11-29 14:42:39
categories:
- 其他
tags:
- Hexo
- bash
- sed
---

## 问题及排查

这两天用手机访问本博客时发现慢得不行，一开始也不知道问题出在哪，瞎忙活了一阵，无果，最后只好静下心来慢慢排查问题。Hexo生成的是静态页面，而且我部署在gitcafe上，理应不慢，而且在电脑端访问速度确实也挺快的。于是，我首先怀疑是不是手机浏览器或者网速的问题，但用手机浏览器访问其他网站都挺快的，于是排除之。既然不是手机或网速的问题，那肯定就是站点本身的问题了。站点本身的问题可分为2类：域名解析的问题和页面加载的问题。然后我通过gitcafe提供的域名（lingdian618.gitcafe.io）访问发现还是一样慢，故排除之。其他能想到的原因都排除后，最终基本确定是页面加载环节出了问题。但网站页面都是Hexo生成了，理应不会出问题，用手机访问他人Hexo博客时也证明了这一点，接着我就想到是不是我自己添加的Gallery页面和About页面出了问题，于是将这2个页面去掉后再用手机访问，居然还是一样慢！这下子真不知道问题出在哪了。最后我甚至从头开始用Hexo建了一个博客，只是把原来的配置文件拿过来用，结果还是一样（此时我应当想到问题和配置文件有关）。就在我要放弃的时候，我发现了Google的[PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/)，它号称"使您的网页在所有设备上都能快速加载"，只要输入网页地址就能分析出网页中影响页面加载速度的元素，并提供相关建议。输入"lijian.ml"后分析的结果是"清除首屏内容中阻止呈现的 JavaScript 和 CSS"，一开始还不懂是啥意思，google之后才明白是脚本阻塞问题：页面中的脚本会阻塞其他资源的下载，如果将脚本放在头部，那么在脚本加载完成之前网页会是一片空白，因此推荐将所有脚本尽可能放到body标签的底部，以尽量减少对整个页面下载的影响。在我的网页中，引起阻塞的脚本是MathJax.js，这是渲染数学公式的脚本，由Hexo插件[Hexo-math](https://github.com/akfish/hexo-math)引入。

## 解决问题

问题发现后，一下子没想到解决的方法，因为引起阻塞的脚本是Hexo-math这个插件弄进去的，而我对Hexo插件开发什么的一窍不通，所以也就放弃了亲自修改Hexo-math的念头，我给插件[作者](http://catx.me/)发邮件反馈了相关问题，期待[作者](http://catx.me/)尽快更新插件。但我的问题得马上解决，所以最后采用了简单粗暴的方法，用bash对所有public目录下包含MathJax.js的文件进行修改：把MathJax.js的包含语句移到body标签底部。具体代码如下：

{% code lang:bash %}
#! /bin/bash

# 页面中关于MathJax的脚本包含语句分成了2行，begin 和 end
begin='<script type="text\/javascript" src="http:\/\/cdn.mathjax.org\/mathjax\/latest\/MathJax.js?config=TeX-AMS-MML_HTMLorMML">'
end='<\/script>'
# pos为参考行，最终将MathJax包含语句移动到pos的后面
pos='<script src="\/js\/script.js" type="text\/javascript"><\/script>'

# 先删掉MathJax包含语句，然后在参考位置后面添加MathJax包含语句
find ./public -name 'index.html' | xargs -I '{}' \
sed -i -e /"$begin"/,/"$end"/d -e "/^$pos/a$begin$end" '{}'
{% endcode %}

每次运行 Hexo g 命令后都要运行上述bash以调整MathJax包含语句的位置，然后再deploy。

## 其他优化
解决脚本阻塞问题后，手机访问明显快了不少。之后我又进行了一些其他的优化，比如把jQuery.min.js改成从本地包含，google的字体渲染干脆没用。这样下来速度已经很快了，[PageSpeed Insights](https://developers.google.com/speed/pagespeed/insights/)还提供了很多其他优化建议，由于太麻烦，暂且没弄了。

## 小结
整个过程挺纠结的，但也学到了不少，再次感受到bash的强大。
