//
//  AliMapViewCustomCalloutView.h
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  自定义气泡

#import <UIKit/UIKit.h>

@interface AliMapViewCustomCalloutView : UIView
@property (nonatomic, strong)UIImage *image;    //商户图
@property (nonatomic, copy) NSString *title;    //商户名
@property (nonatomic, copy) NSString *subtitle; //商户地址
@end
