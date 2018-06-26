//
//  UITextField+Shake.m
//  Shake
//
//  Created by lanouhn on 16/3/1.
//  Copyright © 2016年 LGQ. All rights reserved.
//

#import "UITextField+Shake.h"

/**
 * 为textField扩展一个左右晃动的动画
 */

@implementation UITextField (Shake)

- (void)shake {
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keyFrame.duration = 0.5;
    CGFloat x = self.layer.position.x;
    keyFrame.values = @[@(x - 10), @(x - 10), @(x + 8), @(x - 8), @(x + 6), @(x - 6), @(x + 4), @(x - 4),  @(x + 2), @(x - 2)];
    [self.layer addAnimation:keyFrame forKey:@"shake"];

}

@end
