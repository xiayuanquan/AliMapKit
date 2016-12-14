//
//  AliMapViewCustomPinAnnotationView.m
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  采用自定义气泡，但是使用默认的大头针标记

#import "AliMapViewCustomPinAnnotationView.h"
#import "AliMapViewCustomCalloutView.h"

#define kCalloutWidth       200.0
#define kCalloutHeight      70.0

@interface AliMapViewCustomPinAnnotationView ()
@property (strong,nonatomic)AliMapViewCustomCalloutView *calloutView;//自定义气泡
@end

@implementation AliMapViewCustomPinAnnotationView

//重写选中方法setSelected。选中时新建并添加calloutView，传入数据；非选中时删除calloutView
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            self.calloutView = [[AliMapViewCustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
        }
        self.calloutView.image = [UIImage imageNamed:@"tiananmen"];
        self.calloutView.title = self.annotation.title;
        self.calloutView.subtitle = self.annotation.subtitle;
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
}

@end
