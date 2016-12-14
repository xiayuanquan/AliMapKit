//
//  AliMapViewShopImageView.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  显示商店图片

#import "AliMapViewShopImageView.h"

@implementation AliMapViewShopImageView

//控件初始化
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        for (int i=0; i<3; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.tag = i;
            imageView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
            [self addSubview:imageView];
        }
    }
    return self;
}

//接收图片的urls
-(void)setUrls:(NSArray<AMapImage *> *)urls{
    _urls = urls;
    if (urls.count>0) {
        for (int i=0; i<urls.count; i++) {
            UIImageView *imageView = (UIImageView *)self.subviews[i];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urls[i].url==nil?@"":urls[i].url]];
        }
    }
}

//控件布局
-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat W = (self.bounds.size.width-2*Cell_Border)/3;
    CGFloat H = self.bounds.size.height;
    for (UIImageView *imageView in self.subviews) {
        imageView.frame = CGRectMake(X, Y, W, H);
        X += Cell_Border + W;
    }
}

@end
