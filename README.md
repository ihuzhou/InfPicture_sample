##InfPicture
这就是一个图片无限循环的工程 InfPicture的inf是infinite的意思

-------
-------
###运行环境
 support xcode 7.0 
 iOS SDK 9.0
 但是理论上支持更低版本的，需要测试



how to use 如何使用
 
1.复制InfPicture.h 和InfPicture.m
 
2.import "InfPicture.h"到相应的ViewController中或者使用storyboard添加View并且修改对应的class
 
3.使用初始化方法对图片进行添加设置。


ps:支持的格式包括NSString，NSURL，UIImage。在数组中可以包含这些对象无需切换。
 ----------------------
 ----------------------
注意事项
1.本项目涉及到的无限循环原理建议在有第三方图片缓存库下使用。这样可以节约流量。因为所有的逻辑等都包括在这一个文件里，很方便可以复用和修改。
 
 

