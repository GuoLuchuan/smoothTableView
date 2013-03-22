//
//  UIImage+Edit.m
//  SmoothTableView
//
//  Created by guo luchuan on 13-3-22.
//  Copyright (c) 2013年 yours. All rights reserved.
//

#import "UIImage+Edit.h"

@implementation UIImage (Edit)

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height
{
    CGFloat destW = width;
    CGFloat destH = height;
    CGFloat sourceW = width;
    CGFloat sourceH = height;
    
    CGImageRef imageRef = self.CGImage;
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                destW,
                                                destH,
                                                CGImageGetBitsPerComponent(imageRef),
                                                4 * ((int)destW),
                                                CGImageGetColorSpace(imageRef),
                                                (kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst));
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, sourceW, sourceH), imageRef);
    
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage *result = [UIImage imageWithCGImage:ref];
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return result;
}

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile
{

        @try {
            if ([path length]) {
                NSString *ext = [path pathExtension];
                
                NSData *imageData = [[ext lowercaseString] isEqualToString:@"png"] ?
                UIImagePNGRepresentation(self) :
                UIImageJPEGRepresentation(self, 0);
                
                if ([imageData length]) {
                    [imageData writeToFile:path atomically:useAuxiliaryFile];
                    
                    return YES;
                }
            }
            
            return NO;
            
        } @catch (NSException *exception) {
            return NO;
        }
}

@end
