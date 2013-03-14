//
//  ImageDownloadOperation.h
//  SmoothTableView
//
//  Created by guoluchuan on 13-3-13.
//  Copyright (c) 2013年 yours. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageDownloadOperation : NSOperation

- (id)initWithImageURL:(NSURL *)imageURL target:(id)target action:(SEL)action;

@end
