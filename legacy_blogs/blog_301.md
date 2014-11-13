1. 当通过chk版本的编译后，最好再通过fre版本编译，因为fre版本对于源码的检查更加严格；

2. 尽量少在stack上分配较大的数据结构，因为内核的stack很宝贵；

3. 尽量使用UNICODE_STRING来管理字符串，因为这是Windows内核支持的，可以放心使用，也不会有效率问题；

注意UNICODE_STRING中的成员Length和MaximumLength非常有用，可以方便进行字符串的比较和操作。

4. 在release之前，一定要使用verifier进行测试，verifier发现的问题不一定要全修，但是至少能发现许多常规的测试和审阅无法发现的问题。

5. IRQL以及ProbeForRead/ProbeForWrite一定不要忘记，否则会出事的。

 
