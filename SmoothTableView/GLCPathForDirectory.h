//
//  GLCPathForDirectory.h
//  SmoothTableView
//
//  Created by guo luchuan on 13-3-18.
//  Copyright (c) 2013年 yours. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GLCPathForDirectory : NSObject

+ (NSString *)documentDirectory;

+ (NSString *)cachesDirectory;

+ (NSString *)libraryDirectory;



+ (NSString *)pathForDirectory:(NSSearchPathDirectory)searchPath;


@end
