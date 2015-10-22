//
//  InfPicture.h
//  InfPickture
//
//  Created by ihuzhou on 15/10/20.
//  Copyright © 2015年 ihuzhou. All rights reserved.
//
#import <UIKit/UIKit.h>
@class InfPicture;
/**
 *  返回图片序列的代理
 */
@protocol InfPictureDelegate <NSObject>
@optional
- (void)InfPicture:(InfPicture*)infPicture andImageIndex:(NSInteger)index;
@end

typedef void (^IndexOfImageClickBlock)(NSInteger index);
@interface InfPicture : UIView

/**
 *  返回图片序列block
 */
@property (nonatomic,copy) IndexOfImageClickBlock indexOfImageClickBlock;
@property (nonatomic,weak) id<InfPictureDelegate> delegate;

/**
 *  使用storyboard或者默认构造器没有选择初始化方法。所调用的配置图片方法
 *
 *  @param imageArray     进行展示的图片数组
 *  @param imageIndex     初始化展示序号，默认为0
 *  @param hasPageControl 是否添加pageControl
 *  @param isOpenTimer    是否无限循环
 *  @param block          图片返回block
 */
- (void)setImageArray:(NSMutableArray*)imageArray
        andImageIndex:(NSInteger)imageIndex
       hasPageControl:(BOOL)hasPageControl
   openAutoCycleImage:(BOOL)isOpenTimer
         timeInterval:(NSInteger)timeInterval
InfPictureBeenClicked:(IndexOfImageClickBlock)block;

/**
 *  纯代码添加InfView的init方法
 *
 *  @param frame          整个View的frame
 *  @param imageArray     进行展示的图片数组
 *  @param imageIndex     初始化展示序号，默认为0
 *  @param hasPageControl 是否添加pageControl
 *  @param isOpenTimer    是否无限循环
 *  @param block          图片返回block
 *
 *  @return 返回InfView实例
 */
- (instancetype)initWithFrame:(CGRect)frame
        setImageArray:(NSMutableArray*)imageArray
        andImageIndex:(NSInteger)imageIndex
       hasPageControl:(BOOL)hasPageControl
   openAutoCycleImage:(BOOL)isOpenTimer
         timeInterval:(NSInteger)timeInterval
InfPictureBeenClicked:(IndexOfImageClickBlock)block;

/**
 *  没有使用初始化构造器 或者使用sb 可以使用这个方法作为备选
 *
 *  @param imageArray     图片的数组 >>>目前可以是本地图片，网络URL，和UIImage对象，
 *                        放置URL的时候建议使用缓存机制同时对网络条件要求较高。
 *  @param imageIndex     图片序列
 *  @param hasPageControl 是否需要pageControl
 *  @param isOpenTimer    是否打开定时器
 *  @param timeInterval   定时器间隔
 */
- (void)setImageArray:(NSMutableArray*)imageArray
        andImageIndex:(NSInteger)imageIndex
       hasPageControl:(BOOL)hasPageControl
   openAutoCycleImage:(BOOL)isOpenTimer
         timeInterval:(NSInteger)timeInterval;

/**
 *  设置Frame大小
 *
 *  @param frame CGRect类型
 */
- (void)setFrame:(CGRect)frame;


@end
