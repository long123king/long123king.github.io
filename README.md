long123king.github.io
=====================

This is the main entrance of my coming blogs.

I have got this idea while I am posting a blog to cnblogs site, where my previous blogs resides.
You may know, the cnblogs is not so ideal for hosting a blog site.

But cnblogs provide a great function to backup all blogs to a xml file.
so my oppotunity comes, I can write a script to extract all my previous blogs and commit them all 
to the GitHub, my ideal place to host my blog.

Because I like use the **markdown** to write, and the GitHub support it very well.

All I need to do is write some Homepage or something, to provide entry for all my blogs(You guess right, 
all the blogs are written in markdown).

### \[ blog_parse.sh \] ###
*****************************************************************
     index=0     
          
     while [[ $index -lt 100 ]]     
     do     
     index=$(($index+1))     
          
          
     xmllint --xpath "/rss/channel/item["$index"]/title/text()" $1     
     echo ""     
          
     xmllint --xpath "/rss/channel/item["$index"]/description/text()" $1     
     echo ""     
          
     done     
*****************************************************************
### \[ blog_parse.sh (2014年 11月 12日 星期三 11:24:41 CST)\] ###
*****************************************************************
     index=9     
     title=""     
          
     echo "#Daniel King's Previous blogs#" > entry.md     
          
     while true     
     do     
     index=$(($index+1))     
          
     title=$(xmllint --xpath "/rss/channel/item["$index"]/title/text()" $1)     
     content=$(xmllint --xpath "/rss/channel/item["$index"]/description/text()" $1 | sed -e 's/^<!\[CDATA\[//' | sed -e 's/\]\]>$//')     
          
     if [[ -z $title ]]     
     then     
     break     
          
     else     
     echo "[$title](http://long123king.github.io/blog_$index.html)" >> entry.md     
          
     #echo "title:"     
     #echo "$title"     
     #echo "content:"     
     #echo "$content"     
     #echo "++++++++++++++++++++++++++++++++++++++"     
          
     echo '<html xmlns="http://www.w3.org/1999/xhtml" lang="zh-cn">' > blog_"$index".html     
     echo '<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>' >> blog_"$index".html     
     echo "<title>$title</title>" >> blog_"$index".html     
     echo "<body>$content</body>" >> blog_"$index".html     
     echo "</html>" >> blog_"$index".html     
     fi     
          
     done     
*****************************************************************
### \[ legacy_blogs/replace_img.sh (2014年 11月 12日 星期三 16:56:51 CST)\] ###
*****************************************************************
     mkdir img     
     grep -o 'src="[^"]*"' *.html | sed -e 's/:/ /' | awk 'BEGIN{FS="/"}{printf("%s %s\n", $0, $(NF));}' | while read blog url img     
     do     
     blog_tag=$(echo $blog | sed -e 's/\.html$//')     
     origin_url=$(echo $url | sed -e 's/src="\(.*\)\"/\1/')     
     img_name=$(echo $img | sed -e 's/"//')     
     # 1. download original img files, save it to "img" folder     
     #wget -O "img/$blog_tag"_"$img_name" $origin_url     
     # 2. construct new url     
     new_url="http://long123king.github.io/legacy_blogs/img/$blog_tag"_"$img_name"     
     echo $new_url     
     # 3. replace old url with new url     
     sed -e "s!$origin_url!$new_url!" $blog > replace_tmp     
     mv replace_tmp $blog     
     done     
          
     rm -f replace_tmp     
          
*****************************************************************
