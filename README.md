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
