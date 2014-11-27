awk '/\(Nt|Zw|Ke|Ob|Rtl|Mm|Io|Se|Ex|Kf|mem|wcs|str|Inter|_)/{print}' strings.txt > api_call.txt

sed -re 's/(Nt|Zw|Ke|Ob|Rtl|Mm|Io|Se|Ex|Kf|mem|wcs|str|Inter|_).*//' strings.txt

awk '/\.(dll|exe)/{print}' strings.txt > executable_files.txt
