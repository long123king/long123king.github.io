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

