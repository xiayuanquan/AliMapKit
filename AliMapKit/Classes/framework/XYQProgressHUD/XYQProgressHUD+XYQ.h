//
//  XYQProgressHUD+XYQ.h
//
//  Created by mac on 16/9/7.
//  Copyright © 2016年 xiayuanquan. All rights reserved.
//

#import "XYQProgressHUD.h"

@interface XYQProgressHUD (XYQ)

//显示框显示在指定View上
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (XYQProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;


//默认显示框显示在窗口顶层View上
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;
+ (XYQProgressHUD *)showMessage:(NSString *)message;

//隐藏显示框
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
