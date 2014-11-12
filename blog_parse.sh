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
