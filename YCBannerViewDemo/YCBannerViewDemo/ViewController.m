//
//  ViewController.m
//  YCBannerViewDemo
//
//  Created by 别逗我 on 2017/10/30.
//  Copyright © 2017年 YuChengGuo. All rights reserved.
//

#import "ViewController.h"
#import "YCBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *urlArr = [NSMutableArray array];
    
    [urlArr addObject:@"http://dev-cdd.xiaoxi6.com/uploads/videos/video_150595926018015.jpg"];
    [urlArr addObject:@"http://dev-cdd.xiaoxi6.com/uploads/videos/video_150633225271796.png"];
    [urlArr addObject:@"http://dev-cdd.xiaoxi6.com/uploads/videos/video_150615279148029.png"];
    [urlArr addObject:@"http://dev-cdd.xiaoxi6.com/uploads/videos/video_150615277856836.png"];
    [urlArr addObject:@"http://dev-cdd.xiaoxi6.com/uploads/videos/video_150615267342410.png"];
    [urlArr addObject:@"http://dev-cdd.xiaoxi6.com/uploads/videos/video_150615266275882.png"];
    
    CGSize size = [UIScreen mainScreen].bounds.size;

    //设置横幅视图
    YCBannerView *bannerView = [YCBannerView bannerViewWithFrame:CGRectMake(0, 64, size.width, 200)];
    bannerView.bannerViewDelegate = (id<YCBannerViewDelegate>)self;
    [self.view addSubview:bannerView];
    
    bannerView.urlArr = urlArr;
}
#pragma mark- YCBannerView代理
- (void)bannerView:(YCBannerView *)bannerView tapImageView:(UIImageView *)imageView tapRow:(NSInteger)row
{
    NSLog(@"点击的是第%zd张图片", row);
}

@end







