//
//  ImageDownloadOperation.m
//  SmoothTableView
//
//  Created by guoluchuan on 13-3-13.
//  Copyright (c) 2013年 yours. All rights reserved.
//

#import "ImageDownloadOperation.h"

static const NSString *kImageResultKey = @"image";
static const NSString *kURLResultKey = @"url";


@implementation ImageDownloadOperation
{
    NSURL *_imageURL;
    id _target;
    SEL _action;
}

- (id)initWithImageURL:(NSURL *)imageURL target:(id)target action:(SEL)action
{
    
    self = [super init];
    
    if (self) {
        _imageURL = imageURL;
        _target = target;
        _action = action;
    }
    
    return self;
}

- (void)main
{
    // Synchronously oad the data from the specified URL.
    NSData *data = [[NSData alloc] initWithContentsOfURL:_imageURL];
    UIImage *image = [[UIImage alloc] initWithData:data];
    
    // Package it up to send back to our target.
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:image, kImageResultKey, _imageURL, kURLResultKey, nil];
    [_target performSelectorOnMainThread:_action withObject:result waitUntilDone:NO];
}

@end
