//
//  YCBannerView.h
//  GeneralProject
//
//  Created by cxx on 2017/8/26.
//  Copyright © 2017年 tusm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCBannerView;
@protocol YCBannerViewDelegate <NSObject>
- (void)bannerView:(YCBannerView *)bannerView tapImageView:(UIImageView *)imageView tapRow:(NSInteger)row;

@end

@interface YCBannerView : UICollectionView <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) id <YCBannerViewDelegate> bannerViewDelegate;
@property (nonatomic, strong) NSArray *urlArr;       //地址(不用时设置这个为nil释放定时器)
@property (nonatomic, assign) BOOL isAutoPlay;       //是否需要自动播放(默认自动播放)
@property (nonatomic, assign) CGFloat playTime;      //每一张播放时间间隔(默认3秒)
@property (nonatomic, copy) NSString *currentUrl;    //当前滚到的地址

//初始化
+ (YCBannerView *)bannerViewWithFrame:(CGRect)frame;

@end
