//
//  MAAnnotationMoveAnimation.h
//  MAMapKit
//
//  Created by shaobin on 16/11/21.
//  Copyright © 2016年 le.weng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAAnnotation.h"

/*
 * annotation移动动画. since 4.5.0
 */
@interface MAAnnotationMoveAnimation : NSObject

- (NSString *)name;
- (CLLocationCoordinate2D *)coordinates;
- (NSUInteger)count;
- (CGFloat)duration;
- (CGFloat)elapsedTime;
- (void)cancel;
- (BOOL)isCancelled;


@end
