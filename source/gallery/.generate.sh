#! /bin/bash

PHO_HOME=~/Pictures/public_photos/
dst_file=~/Documents/github/hexo/source/gallery/index.md

# 图片尺寸： 高度500px
style_h500='imageView2/2/h/500/q/85|watermark/2/text/bGlqaWFuLm1s/font/5a6L5L2T/fontsize/500/fill/I0VGRUZFRg==/dissolve/100/gravity/SouthEast/dx/10/dy/10'
# 图片尺寸： 高度100px
style_h100='imageView2/2/h/100/q/85'

prefix='http://public-lingdian618.qiniudn.com/images'

printf "layout: gallery\ntitle: Gallery\ndate: 2014-11-23 09:08:08\n---\n\n" > $dst_file


for x in ` ls $PHO_HOME -t `;
do
	if [ -d $PHO_HOME/$x ];
	then
		printf "\n\n## %s\n\n" $x >> $dst_file
		cd $PHO_HOME/$x
		` ls | cat | xargs -I '{}' printf "<a class=\"article-gallery-img fancybox\" href=\"%s/%s/%s?%s\" ><img src=\"%s/%s/%s?%s\" itemprop=\"image\"></a>" $prefix $x '{}' $style_h500 $prefix $x '{}' $style_h100 >> $dst_file `
	fi
done

