//
//  UIImage+Yasuo.h
//  Link
//
//  Created by apple on 14-6-17.
//  Copyright (c) 2014年 51sole. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;
+ (NSArray *)getBigImageFromImage:(UIImage *)image;
- (UIImage *)imageToMax800Image;
- (UIImage *)imageToImageMaxWidthOrHeight:(CGFloat)max;
- (UIImage *)imageToImageMaxHeight:(CGFloat)max;
- (UIImage *)imageToMaxImage:(CGSize)maxSize;
+ (CGSize)downloadImageSizeWithURL:(id)imageURL;
+ (UIImage *)imageFitScreen:(UIImage *)image withSize:(CGSize)size;

- (UIImage *)imageFixImageViewSize:(CGSize)viewSize;

@end
