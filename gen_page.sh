if  [ -e "$1".md ]
then

if [ -e "$1".html ]
then 
rm -f "$1".html
fi

echo '<html xmlns="http://www.w3.org/1999/xhtml" lang="zh-cn">' > "$1".html
echo '<head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>' >> "$1".html
echo "<title>$1</title>" >> "$1".html
echo "<body>" >> "$1".html 
markdown "$1".md >> "$1".html
echo "</body>" >> "$1".html
echo "</html>" >> "$1".html

fi
