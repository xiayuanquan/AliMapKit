//
//  AliMapViewShopModel.h
//  AliMapKit
//
//  Created by 夏远全 on 16/12/12.
//  Copyright © 2016年 广州市东德网络科技有限公司. All rights reserved.
//  商店模型

#import <Foundation/Foundation.h>

@class AMapPOI;
@interface AliMapViewShopModel : NSObject
/**
 *  商店名称
 */
@property (copy, nonatomic)NSString *shopName;
/**
 *  商店电话
 */
@property (copy, nonatomic)NSString *shopTel;
/**
 *  商店类型
 */
@property (copy, nonatomic)NSString *shopType;
/**
 *  商店地址
 */
@property (copy, nonatomic)NSString *shopAddress;
/**
 *  商店评分
 */
@property (copy, nonatomic)NSString *shopRating;
/**
 *  商店图片
 */
@property (strong, nonatomic)NSArray<AMapImage *>  *shopImages;

//初始化
-(instancetype)initWithAMapPOI:(AMapPOI *)shopPOI;

@end
