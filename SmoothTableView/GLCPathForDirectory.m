//
//  GLCPathForDirectory.m
//  SmoothTableView
//
//  Created by guo luchuan on 13-3-18.
//  Copyright (c) 2013年 yours. All rights reserved.
//

#import "GLCPathForDirectory.h"

@implementation GLCPathForDirectory

+ (NSString *)documentDirectory
{
    return [GLCPathForDirectory pathForDirectory:NSDocumentDirectory];
}

+ (NSString *)cachesDirectory
{
    return [GLCPathForDirectory pathForDirectory:NSCachesDirectory];
}

+ (NSString *)libraryDirectory
{
    return [GLCPathForDirectory pathForDirectory:NSLibraryDirectory];
}

+ (NSString *)pathForDirectory:(NSSearchPathDirectory)searchPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(searchPath, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@end
