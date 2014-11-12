tuples=$(grep -o 'src="[^"]*"' *.html | sed -e 's/:/ /' | awk 'BEGIN{FS="/"}{print $0, $(NF)}')
echo $tuples
echo $tuples | while read blog # url img
do
echo $blog
#echo $url
#echo $img
done

