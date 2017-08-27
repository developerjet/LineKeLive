//
//  UIImage+Estend.h
//  OnlyBrother_ Seller
//
//  Created by 任健东 on 16/9/22.
//  Copyright © 2016年 任健东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Estend)

/**
 保持图片不旋转
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 加载不要被渲染的图片
 */
+ (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName;

/** 
 根据颜色生成一张尺寸为1*1的相同颜色图片 
 */
+ (UIImage *)imageWithColor:(UIColor *)color;



@end
