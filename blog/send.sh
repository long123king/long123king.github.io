perl gen_html.pl $1
title=$(basename $1)
echo $title
perl gen_html.pl $title.md
cd ..
pwd
git add blog/$title.md
git add blog/$title.html
git commit -m "editing $title.."
echo "[$title](http://long123king.github.io/blog/$title.html)    " >> new_entry.md
git push
cd blog
pwd
