①HttpClient 是同步公司IOS开发用来请求网络的工具类。
②HttpClient 是基于AFNetworking封装实现的。
③使用 HttpClient 需要 在项目中添加AFNetworking库以及SSZip库（对下载的文件进行解压时使用）

注意：
 
对参数的处理，默认是先添加token，然后进行附加操作。
如果附加操作需要在 添加token之前进行。
可以在附加操作中先将添加token的操作撤销，撤销的方式由子类实现，然后再进行添加token的操作。


在使用过程中，如果遇到bug。请联系 QQ：925258809
			  手机：18980466314
			 联系人：金忠俊
