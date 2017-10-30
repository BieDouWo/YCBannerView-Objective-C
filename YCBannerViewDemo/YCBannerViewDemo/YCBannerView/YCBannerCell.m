//
//  YCBannerCell.m
//  GeneralProject
//
//  Created by cxx on 2017/8/26.
//  Copyright © 2017年 tusm. All rights reserved.
//

#import "YCBannerCell.h"
#import "UIImageView+WebCache.h"

@implementation YCBannerCell

#pragma mark- 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        [self setImageView];
        [self tapGestureRecognizer];
    }
    return self;
}
#pragma mark- 设置图片视图
- (void)setImageView
{
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_imageView];
}
#pragma mark- 设置点击手势
- (void)tapGestureRecognizer
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapCell:)];
    [self addGestureRecognizer:tap];
}
#pragma mark- 点击手势调用
- (void)tapCell:(UITapGestureRecognizer *)tap
{
    if (_bannerView.bannerViewDelegate && [_bannerView.bannerViewDelegate respondsToSelector:@selector(bannerView:tapImageView:tapRow:)])
    {
        if (_bannerView.urlArr.count >= 2)
        {
            NSInteger row = self.tag - 1000;
            if (row == 0) {
                row = _bannerView.urlArr.count - 1;
            }
            else if (row == _bannerView.urlArr.count + 1) {
                row = 0;
            }
            else{
                row = row - 1;
            }
            [_bannerView.bannerViewDelegate bannerView:_bannerView tapImageView:_imageView tapRow:row];
        }
        else{
            [_bannerView.bannerViewDelegate bannerView:_bannerView tapImageView:_imageView tapRow:0];
        }
    }
}
#pragma mark- 刷新图片
- (void)refreshImageUrl:(NSString *)url row:(NSInteger)row
{
    _imageView.tag = self.tag;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
}

@end




