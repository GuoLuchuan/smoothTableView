//
//  GLCImageCache.m
//  SmoothTableView
//
//  Created by guoluchuan on 13-3-13.
//  Copyright (c) 2013年 yours. All rights reserved.
//

#import "GLCImageCache.h"

#define DEFAULT_CACHE_SIZE    4 * 1024 * 1024

@implementation GLCImageCache

+(GLCImageCache *) sharedCache
{
    static GLCImageCache *shareCache = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        shareCache = [[GLCImageCache alloc] init];
        [shareCache setTotalCostLimit:DEFAULT_CACHE_SIZE];
        
    });
    
    return shareCache;
    
}

- (void)setObject:(id)obj forKey:(id)key
{
    if ([obj isKindOfClass:[UIImage class]]) {
        UIImage *image = obj;
        [super setObject:image forKey:key cost:[self imageDataSize:image]];
    }
}

- (size_t)imageDataSize:(UIImage *)image
{
    
    size_t height      = (NSUInteger) image.size.height;
    size_t bytesPerRow = CGImageGetBytesPerRow(image.CGImage);
    
    if (bytesPerRow % 16) {
        bytesPerRow = ((bytesPerRow / 16) + 1) * 16;
    }
    
    return height * bytesPerRow;
}

@end
