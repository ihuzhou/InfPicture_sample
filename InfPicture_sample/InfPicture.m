//
//  InfPicture.m
//  InfPickture
//
//  Created by ihuzhou on 15/10/20.
//  Copyright © 2015年 ihuzhou. All rights reserved.
//

#import "InfPicture.h"

static const NSInteger normalTimeInterval = 4;

@interface InfPicture()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView* scrollView;

@property (nonatomic,strong) UIImageView* firstImageView;
@property (nonatomic,strong) UIImageView* middleImageView;
@property (nonatomic,strong) UIImageView* thirdImageView;

@property (nonatomic,strong) UIPageControl* pageControl;
@property (nonatomic,assign) BOOL hasPageControl;

@property (nonatomic,strong) NSMutableArray* imageArray;
@property (nonatomic,assign) NSInteger imageIndex;

@end
@implementation InfPicture{
    NSTimer* timer;
    CGFloat viewWidth;
    CGFloat viewHeight;
    NSInteger _timeInterval;
}


#pragma mark
#pragma mark init InfView Method

- (instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        [self setupUI];
    }
    return self;
    
}

- (void)awakeFromNib{
    [self setupUI];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupUI];
    }
    return self;
}

    //设置frame
- (void)setFrame:(CGRect)frame{
        [self setupUI];
}

    //定制的UI设置方法
- (void)setImageArray:(NSMutableArray*)imageArray
        andImageIndex:(NSInteger)imageIndex
       hasPageControl:(BOOL)hasPageControl
   openAutoCycleImage:(BOOL)isOpenTimer
         timeInterval:(NSInteger)timeInterval
{
    _imageArray = [imageArray mutableCopy];
    _imageIndex = imageIndex>=_imageArray.count||imageIndex<0?0:imageIndex;
    _hasPageControl = hasPageControl;
    
    [self reloadImageData];
    
    [self isNeedInitPageControl:hasPageControl];
    
    [self openAutoCycleImage:isOpenTimer andTimeInterval:timeInterval];
    
    [self scrollViewNeedHandleTouch];
}

    //使用storyboard 后调用的简洁方法
- (void)setImageArray:(NSMutableArray*)imageArray
        andImageIndex:(NSInteger)imageIndex
       hasPageControl:(BOOL)hasPageControl
   openAutoCycleImage:(BOOL)isOpenTimer
         timeInterval:(NSInteger)timeInterval
InfPictureBeenClicked:(IndexOfImageClickBlock)block{
    
    [self setImageArray:imageArray
          andImageIndex:imageIndex
         hasPageControl:hasPageControl
     openAutoCycleImage:isOpenTimer
           timeInterval:timeInterval];
    
    _indexOfImageClickBlock = block;
}

    //使用代码写的初始化方法
- (instancetype)initWithFrame:(CGRect)frame
        setImageArray:(NSMutableArray*)imageArray
        andImageIndex:(NSInteger)imageIndex
       hasPageControl:(BOOL)hasPageControl
   openAutoCycleImage:(BOOL)isOpenTimer
         timeInterval:(NSInteger)timeInterval
InfPictureBeenClicked:(IndexOfImageClickBlock)block{
    self=[super initWithFrame:frame];
    if(self){
        [self setupUI];
        [self setImageArray:imageArray
              andImageIndex:imageIndex
             hasPageControl:hasPageControl
         openAutoCycleImage:isOpenTimer
         timeInterval:timeInterval
         ];
        _indexOfImageClickBlock = block;
    }
    return self;
}


#pragma mark
#pragma mark UISetting
/**
 *  给InfView添加手势监听
 */
- (void)scrollViewNeedHandleTouch{
    UITapGestureRecognizer* tapScroll = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapScroll)];
    [_scrollView addGestureRecognizer:tapScroll];
}

/**
 *  响应手势
 */
- (void)handleTapScroll{
    if(_indexOfImageClickBlock){
        _indexOfImageClickBlock(_imageIndex);
    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(InfPicture:andImageIndex:)]){
        [self.delegate InfPicture:self andImageIndex:_imageIndex];
    }
    
}

/**
 *  是否需要pageControl
 *
 *  @param hadPageControl BOOL
 */
- (void)isNeedInitPageControl:(BOOL)hadPageControl{
    if(hadPageControl||_imageArray.count>1){
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, viewHeight-10, viewWidth, 10)];
        _pageControl.currentPage = _imageIndex;
        _pageControl.numberOfPages = _imageArray.count;
        [self addSubview:_pageControl];
    }
}

/**
 *  滑动时候重载图片
 */
- (void)reloadImageData{
        //图片加载分几种情况
    if(_imageArray.count == 1){
        [self setImageView:_middleImageView
          findImageInArray:_imageArray
                  andIndex:_imageIndex];
        _scrollView.scrollEnabled=NO;
    }
    else if (_imageArray.count > 1){
        _scrollView.scrollEnabled=YES;

        [self setImageView:_middleImageView
          findImageInArray:_imageArray
                  andIndex:_imageIndex];
        if(_imageIndex==0){
            [self setImageView:_firstImageView
              findImageInArray:_imageArray
                      andIndex:_imageArray.count-1];
            [self setImageView:_thirdImageView
              findImageInArray:_imageArray
                      andIndex:_imageIndex+1];
        }
        else if (_imageIndex ==_imageArray.count-1){
            [self setImageView:_firstImageView
              findImageInArray:_imageArray
                      andIndex:_imageIndex-1];
            [self setImageView:_thirdImageView
              findImageInArray:_imageArray
                      andIndex:0];
        }
        else{
            [self setImageView:_firstImageView
              findImageInArray:_imageArray
                      andIndex:_imageIndex-1];
            [self setImageView:_thirdImageView
              findImageInArray:_imageArray
                      andIndex:_imageIndex+1];
        }
        

    }
    else{
        NSLog(@"Image data error");
    }
}

/**
 *  根据图片的class 来处理图片，给ImageView
 *
 *  @param imageView  需要传给的图片
 *  @param imageArray 图片数组
 *  @param index      图片序号
 */
- (void)setImageView:(UIImageView*)imageView
    findImageInArray:(NSMutableArray*)imageArray
            andIndex:(NSInteger)index{
    
    id objectInArray = imageArray[index];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    if([objectInArray isKindOfClass:[NSString class]] ){
        imageView.image = [UIImage imageNamed:objectInArray];
    }
    else if ([objectInArray isKindOfClass:[NSURL class]] ){
        [self ImageView:imageView
        setImageWithURL:objectInArray
       placeHolderImage:@"2.jpg"];
    }
    else if([objectInArray isKindOfClass:[UIImage class]] ){
        imageView.image=objectInArray;
    }
    else{
        NSLog(@"cannot play");
    }
}

/**
 *  网络获取图片，这个方法是简单的获取网络图片，建议使用网络上流行的第三方库对图片进行缓存处理
 *
 *  @param imageView            需要添加图片的ImageView
 *  @param url                  图片URL
 *  @param placeHolderImageName 本地存的预制图片
 */
- (void)ImageView:(UIImageView*)imageView
  setImageWithURL:(NSURL*)url
 placeHolderImage:(NSString*)placeHolderImageName{
    imageView.image = [UIImage imageNamed:placeHolderImageName];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSURLSessionDataTask* task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data&&!error) {
                [self setImage:imageView andData:data];
            }
        }];
        [task resume];
    });
}

/**
 *  设置图片
 *
 *  @param imageView ImageView
 *  @param data      NSData
 */
- (void)setImage:(UIImageView*)imageView andData:(NSData*)data{
    [imageView setImage:[UIImage imageWithData:data]];
}

/**
 *  初始化ImageArray和ImageIndex数据
 */
- (void)initImageData{
    _imageArray = [[NSMutableArray alloc]initWithCapacity:0];
    _imageIndex = 0;
}

/**
 * 设置边界
 */
- (void)setupUI{
    
    viewWidth = self.bounds.size.width;
    viewHeight = self.bounds.size.height;

    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.contentSize = CGSizeMake(viewWidth*3, viewHeight);
    _scrollView.contentOffset = CGPointMake(viewWidth, 0);

    [self addSubview:_scrollView];
    
    _firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [_scrollView addSubview:_firstImageView];

    _middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(viewWidth, 0, viewWidth, viewHeight)];
    [_scrollView addSubview:_middleImageView];

    _thirdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2*viewWidth, 0, viewWidth, viewHeight)];
    [_scrollView addSubview:_thirdImageView];
}

#pragma mark
#pragma mark ScrollView Delegate Method

/**
 *  图片滑动判定
 *
 *  @param scrollView ScrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    CGFloat offset = scrollView.contentOffset.x;
    
    if(offset >= 2*viewWidth){
        _scrollView.contentOffset = CGPointMake(offset-viewWidth, 0);
   
        if(_imageIndex == _imageArray.count-1){
            _imageIndex = 0;
            
        }
        else{
            _imageIndex++;
        }
        [self reloadImageData];
        _pageControl.currentPage = _imageIndex;
    }
    else if (offset <= 0){
        _scrollView.contentOffset = CGPointMake(offset+viewWidth, 0);
 
        
        if(_imageIndex == 0){
            _imageIndex = _imageArray.count-1;

        }
        else{
            _imageIndex--;
        }
        [self reloadImageData];
        _pageControl.currentPage = _imageIndex;
    }
}

/**
 *  放弃触摸开启Timer
 *
 *  @param scrollView ScrollView
 *  @param decelerate BOOL
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}

/**
 *  有戳拽事件的时候
 *
 *  @param scrollView ScrollView
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}

#pragma mark
#pragma mark NSTimer Method
/**
 *  NSTimer方法
 *
 *  @param isOpenTimer  是否打开无限循环功能
 *  @param timeInterval 时间间隔
 */
- (void)openAutoCycleImage:(BOOL)isOpenTimer andTimeInterval:(NSInteger)timeInterval{
    if (isOpenTimer) {
        NSInteger interval = timeInterval>0?timeInterval:normalTimeInterval;
        _timeInterval= interval;
        timer=[NSTimer scheduledTimerWithTimeInterval:interval
                                               target:self
                                             selector:@selector(handleTimer:)
                                             userInfo:nil
                                              repeats:YES
               ];
    }
   
}
/**
 *  timer事件
 *
 *  @param timer NSTimer
 */
- (void)handleTimer:(NSTimer*)timer
{
    [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x+viewWidth, 0) animated:YES];
}

/**
 *  开启Timer
 */
- (void)startTimer{
    if(timer){
        NSDate* date=[NSDate dateWithTimeInterval:_timeInterval sinceDate:[NSDate date]];
        [timer setFireDate:date];
    }

}

/**
 *  暂停Timer
 */
- (void)stopTimer
{
    if(timer){
        [timer setFireDate:[NSDate distantFuture]];
    }
}

@end
