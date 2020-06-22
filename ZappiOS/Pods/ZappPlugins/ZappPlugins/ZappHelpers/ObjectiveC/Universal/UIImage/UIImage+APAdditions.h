//
//  UIImage+APAddition.h
//  ApplicasterSDK
//
//  Created by Tom Susel on 1/10/12.
//  Copyright (c) 2012 Applicaster. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Helper category currently used for getting images from the APCore bundle.
 */
@interface UIImage (APAdditions)

/**
 Create a masked image by using an image and an image for masking
 @param image Image to mask
 @param maskImage Should be black / white - NOT ALPHA 0 / 1
 @return New image with the mask applied
 */
+ (UIImage*)getCropped:(UIImage *)image withMask:(UIImage *)maskImage;

+ (UIImage *)imageMaskedImage:(UIImage*)image color:(UIColor *)color;
@end

//
//  UIImage+ProportionalFill.h
//
//  Created by Matt Gemmell on 20/08/2008.
//  Copyright 2008 Instinctive Code.
//

/**
 Resizing helper category. Courtesy of https://github.com/mattgemmell/MGImageUtilities
 */
@interface UIImage (MGProportionalFill)

typedef enum {
    MGImageResizeCrop,	// analogous to UIViewContentModeScaleAspectFill, i.e. "best fit" with no space around.
    MGImageResizeCropStart,
    MGImageResizeCropEnd,
    MGImageResizeScale	// analogous to UIViewContentModeScaleAspectFit, i.e. scale down to fit, leaving space around if necessary.
} MGImageResizingMethod;

/**
 Returns an image fitted to a new size.
 @param size The size within which to fit the image.
 @param resizeMethod The method for resizing the image.
 @return The resized image.
 */
- (UIImage *)imageToFitSize:(CGSize)size method:(MGImageResizingMethod)resizeMethod;

/**
 Returns [self imageToFitSize:fitSize method:MGImageResizeCrop];
 @param size The size of the cropped image.
 @return The cropped image.
 */
- (UIImage *)imageCroppedToFitSize:(CGSize)size; // uses MGImageResizeCrop

/**
 Returns [self imageToFitSize:fitSize method:MGImageResizeScale];
 @param size The size of the scaled image.
 @return The scaled image.
 */
- (UIImage *)imageScaledToFitSize:(CGSize)size; // uses MGImageResizeScale

@end

//
//  UIImage+Tint.h
//
//  Created by Matt Gemmell on 04/07/2010.
//  Copyright 2010 Instinctive Code.
//

/**
 Image tinting helper category. Courtesy of https://github.com/mattgemmell/MGImageUtilities
 */
@interface UIImage (MGTint)

/**
 Tints an image with a given color.
 @param color The color to tint the image.
 @return A new image tinted by the given color.
 */
- (UIImage *)imageTintedWithColor:(UIColor *)color;

/**
 Multiplies the colors of each pixel. This is useful for taking images with white and coloring them in. Black areas remain unaffected.
 @param color The color to color the image.
 @return A new image colored in by the given color.
 */
- (UIImage *)imageColoredInWithColor:(UIColor *)color;

/**
 Tint the image according the selected color.
 @param tintColor The color to tint the image.
 @param img The image who want to tint.
 @return A image tinted by the given color.
 */
+ (UIImage *)imageWithTint:(UIColor *)tintColor andImage:(UIImage *)img;

//Apple image effects https://developer.apple.com/downloads/index.action# (search for imageEffects)

/**
 Light effects
 */
- (UIImage *)applyLightEffect;

/**
 Extra light effects
 */
- (UIImage *)applyExtraLightEffect;

/**
 Dark effects
 */
- (UIImage *)applyDarkEffect;

/**
 Change background color
 */
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor;

/**
 Specific background Color
 */
- (UIImage *)applyTintEffectWithColor:(UIColor *)tintColor alpha:(CGFloat)alpha radius:(CGFloat)blurRadius saturationDeltaFactor:(CGFloat)saturationDeltaFactor;

/**
 Add blur radius to image
 */
- (UIImage *)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end

