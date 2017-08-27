//
//  UIImage+Extension.h
//  OnlyBother_Personal
//
//  Created by 马康旭 on 2016/11/22.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;

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

///保持图片不旋转
+ (UIImage *)fixOrientation:(UIImage *)aImage;
// 加载不要被渲染的图片
+ (UIImage *)imageWithOriginalRenderingMode:(NSString *)imageName;

@end
