//
//  MAAnimatedAnnotation.h
//  MAMapKit
//
//  Created by shaobin on 16/12/8.
//  Copyright © 2016年 le.weng. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "MAAnnotationMoveAnimation.h"

@interface MAAnimatedAnnotation : MAPointAnnotation<MAAnimatableAnnotation>

/**
 @brief 添加移动动画, 第一个添加的动画以当前coordinate为起始点，沿传入的coordinates点移动，否则以上一个动画终点为起始点. since 4.5.0
 @param coordinates 数组
 @param count 要传入的个数
 @param duration 动画时长，0或<0为无动画
 @param name 名字，如不指定可传nil
 @param completeCallback 动画完成回调，isFinished: 动画是否执行完成
 */
- (void)addMoveAnimationWithKeyCoordinates:(CLLocationCoordinate2D *)coordinates
                                     count:(NSUInteger)count
                              withDuration:(CGFloat)duration
                                  withName:(NSString *)name
                          completeCallback:(void(^)(BOOL isFinished))completeCallback;

/**
 获取所有未完成的移动动画, 返回数组内为MAAnnotationMoveAnimation对象. since 4.5.0
 */
- (NSArray<MAAnnotationMoveAnimation*> *)allMoveAnimations;

/**
 * 移动方向. since 4.5.0
 */
@property (nonatomic, assign) CLLocationDirection movingDirection;

@end
