//
//  YCBannerCell.h
//  GeneralProject
//
//  Created by cxx on 2017/8/26.
//  Copyright © 2017年 tusm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCBannerView.h"

@interface YCBannerCell : UICollectionViewCell
@property (nonatomic, weak) YCBannerView *bannerView;
@property (nonatomic, strong) UIImageView *imageView;

//刷新图片
- (void)refreshImageUrl:(NSString *)url row:(NSInteger)row;

@end
