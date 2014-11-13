[read_pages](https://github.com/torvalds/linux/blob/master/mm/readahead.c#L111)
---------------------------------------------------------------------------------
    if (mapping->a_ops->readpages) {
		ret = mapping->a_ops->readpages(filp, mapping, pages, nr_pages);
		/* Clean up the remaining pages */
		put_pages_list(pages);
		goto out;
	}

	for (page_idx = 0; page_idx < nr_pages; page_idx++) {
		struct page *page = list_to_page(pages);
		list_del(&page->lru);
		if (!add_to_page_cache_lru(page, mapping,
					page->index, GFP_KERNEL)) {
			mapping->a_ops->readpage(filp, page);
		}
		page_cache_release(page);
	}
---------------------------------------------------------------------------------
对于**[address_space](https://github.com/torvalds/linux/blob/master/include/linux/fs.h#L397)**中的函数指针readpages和readpage，在不同的文件系统中对应于不同的具体函数。
对于NTFS文件系统，readpage指针对应的函数为[ntfs_readpage](https://github.com/torvalds/linux/blob/master/fs/ntfs/aops.c#L398)
NTFS文件系统使用了[虚拟的inode](https://github.com/torvalds/linux/blob/master/fs/ntfs/inode.h#L47)来代表MFT中与每个文件对应的Record的相关内容。
