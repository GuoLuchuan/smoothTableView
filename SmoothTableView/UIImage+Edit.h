//
//  UIImage+Edit.h
//  SmoothTableView
//
//  Created by guo luchuan on 13-3-22.
//  Copyright (c) 2013年 yours. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Edit)

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile;

@end
