//
//  ToolManager.m
//  KenJiao
//
//  Created by mac on 16/2/18.
//  Copyright © 2016年 xiayuanquan. All rights reserved.
//  通过颜色、大小来画图片

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  按照指定的颜色返回一个图片
 *
 *  @param color 给定的图片颜色
 *
 *  @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  按照指定的大小返回一个图片
 *
 *  @param itemSize  给定的大小
 *  @param imageName 给定的名称
 *  @return 图片
 */
+ (UIImage *)imageWithSize:(CGSize)itemSize imageName:(NSString *)imageName;


/**
 *  利用qurazt2D画图的方法返回旋转后的图片
 *
 *  @param image       原始图片
 *  @param orientation 旋转方向
 */
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;

@end
