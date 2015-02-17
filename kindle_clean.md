# How to safe delete useless files in kindle folder
**********************************************
	import os,sys,shutil

	doc = os.path.join(os.getcwd(), "documents")

	assets = {}

	class Assets():
		def __init__(self):
			self.major_exts = []
			self.minor_exts = []

		def put_major(self, ext):
			if ext not in self.major_exts:
				self.major_exts.append(ext)

		def put_minor(self, ext):
			if ext not in self.minor_exts:
				self.minor_exts.append(ext)

		def empty_major(self):
			return len(self.major_exts) == 0

		def iter_major(self):
			for ext in self.major_exts:
				yield ext

		def iter_minor(self):
			for ext in self.minor_exts:
				yield ext


	def put_major(fullname, ext):
		if not assets.has_key(fullname):
			assets[fullname] = Assets()

		assets[fullname].put_major(ext)

	def put_minor(fullname, ext):
		if not assets.has_key(fullname):
			assets[fullname] = Assets()

		assets[fullname].put_minor(ext)

	def proc(param, folder, filenames):
		for filename in filenames:
			fullpath = os.path.join(folder, filename)
			fullname, ext = os.path.splitext(fullpath)
			if ext == ".azw":
				put_major(fullname, ext)
			elif ext == ".azw3":
				put_major(fullname, ext)
			elif ext == ".pdf":
				put_major(fullname, ext)
			elif ext == ".mobi":
				put_major(fullname, ext)
			elif ext == ".sdr":
				put_minor(fullname, ext)
			elif ext == ".opf":
				put_minor(fullname, ext)
			elif ext == ".jpg":
				put_minor(fullname, ext)

	os.path.walk(doc, proc, None)

	for key in assets.keys():
		if (assets[key].empty_major()):
			for ext in assets[key].iter_minor():
				fullpath = "%s%s" % (key, ext)
				if (os.path.isdir(fullpath)):
					print "[D]  ", fullpath
					shutil.rmtree(fullpath)
				elif (os.path.isfile(fullpath)):
					print "[F]  ", fullpath
					os.remove(fullpath)
**********************************************
