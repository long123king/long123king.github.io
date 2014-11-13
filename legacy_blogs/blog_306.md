#inode#
___________________________________________________________________
    struct [inode](https://github.com/torvalds/linux/blob/master/include/linux/fs.h#L538) {
    ......
    #ifdef CONFIG_FS_POSIX_ACL
	struct posix_acl	*i_acl;
	struct posix_acl	*i_default_acl;
    #endif
    ......
    }
___________________________________________________________________

posix_acl里面保存的就是rwxrwxrwx这样的权限。
