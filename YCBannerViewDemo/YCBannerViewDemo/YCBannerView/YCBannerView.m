//
//  YCBannerView.m
//  GeneralProject
//
//  Created by cxx on 2017/8/26.
//  Copyright © 2017年 tusm. All rights reserved.
//

#import "YCBannerView.h"
#import "YCBannerCell.h"

@implementation YCBannerView
{
    NSString *_bannerCellID;
    NSMutableArray *_newUrlArr;
    
    CGFloat _width;
    CGFloat _height;
    
    UIPageControl *_pageControl;
    NSTimer *_timer;
}
#pragma mark- 释放资源
- (void)dealloc
{
    //停止定时器
    if ([_timer isValid]){
        [_timer invalidate];
         _timer = nil;
    }
}
#pragma mark- 初始化
+ (YCBannerView *)bannerViewWithFrame:(CGRect)frame
{
    //设置cell显示属性
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //横向滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //cell的大小
    layout.itemSize = CGSizeMake(frame.size.width, frame.size.height);
    //cell之间的距离为0
    layout.minimumLineSpacing = 0;
    
    YCBannerView *bannerView = [[YCBannerView alloc] initWithFrame:frame collectionViewLayout:layout];
    
    return bannerView;
}
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self)
    {
        //记录宽和高
        _width = frame.size.width;
        _height = frame.size.height;
        
        //设置为翻页模式
        self.pagingEnabled = YES;
        self.backgroundColor = [UIColor clearColor]; //滚动背景必须为黑色
        self.showsHorizontalScrollIndicator = NO;    //隐藏水平滚动条
        self.dataSource = self;
        self.delegate = self;
        
        //注册cell
        _bannerCellID = @"YCBannerCell";
        [self registerClass:[YCBannerCell class] forCellWithReuseIdentifier:_bannerCellID];
        
        //设置小点视图
        [self setPageControl];
        
        //默认自动播放
        _isAutoPlay = YES;
        
        //每一张播放时间间隔(默认3秒)
        _playTime = 3.0;
    }
    return self;
}
#pragma mark- 设置小点视图
- (void)setPageControl
{
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.origin.y + self.frame.size.height - 20, self.frame.size.width, 20)];
    
    //设置不可点击
    _pageControl.userInteractionEnabled = NO;
    
    //设置小点不同状态颜色(没有选中和选中的颜色)
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:184/255.f green:184/255.f blue:184/255.f alpha:0.8];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
}
#pragma mark- 设置图片
- (void)setUrlArr:(NSArray *)urlArr
{
    //停止定时器
    if ([_timer isValid]){
        [_timer invalidate];
         _timer = nil;
    }
    
    //URL数据
    _urlArr = urlArr;
    if (_urlArr.count == 0) {
        return;
    }
    _newUrlArr = [NSMutableArray array];
    [_newUrlArr addObjectsFromArray:_urlArr];
    
    //设置轮播URL
    if (_urlArr.count >= 2) {
        NSString *url1 = _urlArr[0];
        NSString *url2 = _urlArr[_urlArr.count - 1];
        [_newUrlArr insertObject:url2 atIndex:0];
        [_newUrlArr addObject:url1];
    }
    
    //记录当前滚到的图片地址
    if (_newUrlArr.count == 1) {
        _currentUrl = _newUrlArr[0];
    }else{
        _currentUrl = _newUrlArr[1];
    }
    
    //设置有几个点(默认0个)
    _pageControl.numberOfPages = _newUrlArr.count - 2;
    
    //设置选中的小点(默认选中第0个)
    _pageControl.currentPage = 0;
    
    //添加到父视图
    [self.superview addSubview:_pageControl];
    
    //刷新图片
    [self reloadData];
    
    //默认滚动到第2个
    if (_newUrlArr.count >= 2) {
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    }
    
    //设置定时器
    if (_isAutoPlay && _urlArr.count >= 2){
        _timer = [NSTimer scheduledTimerWithTimeInterval:_playTime target:self selector:@selector(autoPlay) userInfo:nil repeats:YES];
      
        //[[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
    }
}
#pragma mark- UICollectionView代理
//多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _newUrlArr.count;
}
//返回cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_bannerCellID forIndexPath:indexPath];
    
    cell.bannerView = self;
    cell.tag = indexPath.row + 1000;

    [cell refreshImageUrl:_newUrlArr[indexPath.row] row:indexPath.row];
    
    return cell;
}
#pragma mark- UIScrollView代理
//正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //(当前偏移的位置)除(每次偏移的x)就是第几张,移到一半算一张
    CGFloat p = (scrollView.contentOffset.x / _width) + 0.5;

    //计算真实的页数
    NSInteger row = (NSInteger)p;
    if (_urlArr.count >= 2) {
        if (row == 0) {
            row = _urlArr.count;
        }
        else if (row == _newUrlArr.count - 1) {
            row = 0;
        }
        else{
            row = row - 1;
        }
    }
    
    //记录当前滚到的图片地址
    if (row < _urlArr.count && row >= 0) {
        _pageControl.currentPage = row;
        _currentUrl = _urlArr[row];
    }
}
//已经结束滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //(当前偏移的位置)除(每次偏移的x)就是第几张,移到一半算一张
    CGFloat p = (scrollView.contentOffset.x / _width);
    
    //第一张和最后一张图片滚动的处理
    NSInteger row = (NSInteger)p;
    if (_urlArr.count >= 2) {
        if (row == 0) {
            [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_newUrlArr.count - 2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
        else if (row == _newUrlArr.count - 1) {
             [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        }
    }
}
#pragma mark- 自动播放
- (void)autoPlay
{
    //(当前偏移的位置)除(每次偏移的x)就是第几张,移到一半算一张
    CGFloat p = (self.contentOffset.x / _width);
    
    //播放下一张
    NSInteger row = (NSInteger)p;
    if (_urlArr.count >= 2) {
        //下一张
        row = row + 1;
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        //判断位置
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self scrollViewDidEndDecelerating:self];
        });
    }
}

@end



