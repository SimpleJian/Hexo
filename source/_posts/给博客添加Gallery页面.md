title: 给博客添加Gallery页面
categories:
  - 其他
tags:
  - Hexo
date: 2014-11-26 08:50:58
---

# 引言
博客迁到Hexo后，试用了很多[主题](https://github.com/hexojs/hexo/wiki/Themes)，一开始感觉都还不错，比如之前用的[Pacman](http://yangjian.me/pacman/hello/introducing-pacman-theme/)就非常好，后来要在博客中发布照片时，就感觉有些地方不太合我口味。最初在发布照片时，我把同一主题的照片发布到同一篇博客，这样下来大概有10篇左右的照片博客，弄完之后发现把照片博客混在一般的文章中很不爽，一方面找起来不方便，另一方面首页看起来挺混乱的，于是就想着专门弄一个Gallery页面来放照片博客，试用了很多主题后都没找到解决方案，为此我还在hexo的github页面提了[issues](https://github.com/hexojs/hexo/issues/912#comments)，然后[xing5](https://github.com/xing5)给出了一种方案：把每篇照片博客都打上一个特殊的tag，然后在设置中把Gallery的链接设置为该tag的目录。这种方案确实可以简单有效地建立Gallery页面，但是首页和Archive页面还是会显示照片博客，所以我最终没采用此方案。后来纠结了很久也没找到比较合适的方案，就在我要妥协的时候，About页面给了我思路：Gallery页面其实也可以看成是About页面，只不过是About My Pictures，可以把所有的照片放在同一个页面中，同一个主题的照片可以分段隔开，放在同一个fancybox中，最终效果看[=>这里<=](http://lijian.ml/gallery/)。但由于要发布的照片有100+张，手工写图片链接想想都可怕，好在会点批处理，可以用bash快速生成Gallery页面的index.md文件。整个流程如下。

## 生成新页面
在博客目录下执行：
{% code lang:bash %}
hexo new page 'Gallery'
{% endcode %}

## 使用批处理生成Gallery页面的index文件

{% code lang:bash %}
#! /bin/bash

# 要发布的照片目录，目录中的每个子目录为同一个主题的照片，放在同一个fancybox中
PHO_HOME=~/Pictures/public_photos/
# Gallery页面index文件
dst_file=~/Documents/github/hexo/source/gallery/index.md

# 七牛缩略图样式： 高度500px 
style_h500='imageView2/2/h/500/q/85|watermark/2/text/bGlqaWFuLm1s/font/5a6L5L2T/fontsize/500/fill/I0VGRUZFRg==/dissolve/100/gravity/SouthEast/dx/10/dy/10'
# 七牛缩略图样式： 高度100px
style_h100='imageView2/2/h/100/q/85'

# 七牛云中照片的前缀
prefix='http://public-lingdian618.qiniudn.com/images'

# 格式化输出头文件
printf "layout: gallery\ntitle: Gallery\ndate: 2014-11-23 09:08:08\n---\n\n" > $dst_file

# 按最后touch时间遍历子目录
for x in ` ls $PHO_HOME -t `;
do
	if [ -d $PHO_HOME/$x ];
	then
		printf "\n\n## %s\n\n" $x >> $dst_file
		cd $PHO_HOME/$x
		` ls | cat | xargs -I '{}' printf "<a class=\"article-gallery-img fancybox\" href=\"%s/%s/%s?%s\" ><img src=\"%s/%s/%s?%s\" itemprop=\"image\"></a>" $prefix $x '{}' $style_h500 $prefix $x '{}' $style_h100 >> $dst_file `
	fi
done
{% endcode %}

## 去掉Gallery页面的Sidebar
我的修改是基于默认主题landscape，通过 hexo new page产生的页面最终都会有Sidebar，看起来不爽，如果想去掉，可以通过修改landscape的layout.ejs文件实现。
{% code lang:html %}
if(page.layout == 'about' || page.layout == 'gallery'){
	<div class="outer"><section>
    	<%- body%>
	</section></div>
}else...
{% endcode %}
思路是这样的：对于不想要Sidebar的页面，在index.md文件中设定特殊的layout，例如我的Gallery页面index.md头文件如下：
{% code lang:bash %}
layout: gallery
title: Gallery
date: 2014-11-23 09:08:08
---
{% endcode %}
然后在layout.ejs文件中根据page.layout来控制是否加载Sidebar模块。

# 小结
通过这种方法添加Gallery页面简单粗暴，虽然有点麻烦，但在找到更好的方法之前只能这样了。这篇博客就当抛砖引玉，期待哪位仁兄能提出更好的解决方案。