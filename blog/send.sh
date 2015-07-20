perl gen_html.pl $1
$title=basename $1
cd ..
git add blog/$title.md
git add blog/$title.html
git commit -m "editing $title.."
git push
cd blog
