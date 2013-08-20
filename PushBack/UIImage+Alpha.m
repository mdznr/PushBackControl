//
// UIImage+Alpha.m
// Created by Trevor Harmon on 9/20/09
// and by Matt Zanchelli on 8/18/13.
// 
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.
//

#import "UIImage+Alpha.h"

// Private helper methods
@interface UIImage ()

- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;

@end

@implementation UIImage (Alpha)


// Returns true if the image has an alpha layer
- (BOOL)hasAlpha
{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}


// Returns a copy of the given image, adding an alpha channel if it doesn't already have one
- (UIImage *)imageWithAlpha
{
    if ([self hasAlpha]) {
        return self;
    }
    
    CGImageRef imageRef = self.CGImage;
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
    CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
                                                          width,
                                                          height,
                                                          8,
                                                          0,
                                                          CGImageGetColorSpace(imageRef),
                                                          kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
    
    // Draw the image into the context and retrieve the new image, which will now have an alpha layer
    CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
    UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha];
    
    // Clean up
    CGContextRelease(offscreenContext);
    CGImageRelease(imageRefWithAlpha);
    
    return imageWithAlpha;
}


// Returns a copy of the image with a transparent border of the given size added around its edges.
// Created by Matt Zanchelli
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize
{
//	UIImage *image = [self imageWithAlpha]; // TODO: Fix this to return correct scale
	CGSize size = { ( 2 * borderSize ) + self.size.width,
		            ( 2 * borderSize ) + self.size.height};
	UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
	[self drawAtPoint:CGPointMake(borderSize, borderSize)];
	UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return output;
}

@end
