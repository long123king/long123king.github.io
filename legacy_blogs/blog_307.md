     /* __insert_inode_hash - hash an inode
     *	@inode: unhashed inode
     *	@hashval: unsigned long value used to locate this object in the
     *		inode_hashtable.
     *
     *	Add an inode to the inode hash for this superblock.
     */
     void __insert_inode_hash(struct inode *inode, unsigned long hashval)
     {
         struct hlist_head *b = inode_hashtable + hash(inode->i_sb, hashval);

         spin_lock(&inode_hash_lock);
         spin_lock(&inode->i_lock);
         hlist_add_head(&inode->i_hash, b);
         spin_unlock(&inode->i_lock);
         spin_unlock(&inode_hash_lock);
     }
     EXPORT_SYMBOL(__insert_inode_hash);
---------------------------------------------------------------------
**inode_hashtable**就是hash table的表头，通过拉链法来解决冲突。
其中b就是计算出的拉链表，通过hlist_add_head将**inode->i_hash**作为锚点，添加到拉链表的头部。

关于inode_hashtable，参见[Linux Kernel Hash Table Behavior, Analysis and Improvements](http://www.citi.umich.edu/techreports/reports/citi-tr-00-1.pdf)一文。

> The dentry cache, described above, provides a fast way
> of mapping directory entries to inodes.

**[dentry](https://github.com/torvalds/linux/blob/master/include/linux/dcache.h#L108)**代表着目录分量，即一个完整的路径被"\"分开的各个部分，并且将其指向到具体的inode上。

因此，**dentry**存在的意义在于，可以通过路径名快速地找到它所对应的**inode**。

所有文件中的数据，说白了，就是该文件映射的内存页面，都是存在的**inode->i_mapping->page_tree**中，这些页面是在**mmap系统调用**时和具体的文件系统中的节点建立起了映射关系，在**page fault**时从具体的文件系统的节点中读取出内容来初始化的。
