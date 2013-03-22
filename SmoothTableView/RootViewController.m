//
//  RootViewController.m
//  SmoothTableView
//
//  Created by guoluchuan on 13-3-13.
//  Copyright (c) 2013年 yours. All rights reserved.
//

#import "JSON.h"
#import "RootViewController.h"
#import "MyCustomCell.h"
#import "GLCImageCache.h"
#import "BriefIntroductionViewController.h"
#import "PictureInfo.h"
#import "GLCPathForDirectory.h"

#import "UIImage+Edit.h"

#import <QuartzCore/QuartzCore.h>

static const NSString *kFlickrAPIKey = @"583366ad887b297494873eb1710fa739";
static const NSInteger kNumberOfImages = 30;

@interface RootViewController ()
{
    UITableView *_tableView;
    NSMutableArray *_pictureList;
        
    GLCImageCache *_imageCache;
    
    UIActivityIndicatorView *_indicatorView;
}

@end

@implementation RootViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        _pictureList = [[NSMutableArray alloc] init];

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] bounds]), CGRectGetHeight([[UIScreen mainScreen] bounds]) - 44 -20) ];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _imageCache = [GLCImageCache sharedCache];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _indicatorView.frame = CGRectMake(0, 0, 40, 40);
        _indicatorView.center = _tableView.center;
        self.view.frame = [[UIScreen mainScreen] bounds];
        [self.view addSubview:_tableView];
        [self.view addSubview:_indicatorView];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_indicatorView startAnimating];
    [self beginLoadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [_imageCache removeAllObjects];
}

#pragma mark -
#pragma mark Download pictureInfo list

- (void)beginLoadData
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self downloadPictureLists];
    });
    
}

- (void)downloadPictureLists
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=%d&format=json&nojsoncallback=1", kFlickrAPIKey, @"Haerbin", kNumberOfImages];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Get the contents of the URL as a string, and parse the JSON into Foundation objects.
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *results = [jsonString JSONValue];
    
    [self didFinishDownloadPictureLists:results];

}

- (void)didFinishDownloadPictureLists:(NSDictionary *)pictureLists
{
    NSArray *photos = [[pictureLists objectForKey:@"photos"] objectForKey:@"photo"];
    for (NSDictionary *photo in photos) {
        
        for (NSString *key in [photo allKeys]) {
            NSLog(@"%@",key);
        }
        
        // Get the title for each photo
        PictureInfo *pictureInfo = [[PictureInfo alloc] init];
        
        NSString *title = [photo objectForKey:@"title"];
        title = (title.length > 0 ? title : @"Untitled");
        pictureInfo.title = title;
        
        // Construct the URL for each photo.
        NSString *photoURLString = [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg", [photo objectForKey:@"farm"], [photo objectForKey:@"server"], [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        pictureInfo.imageURL = [NSURL URLWithString:photoURLString];
        pictureInfo.pictureId = [photo objectForKey:@"id"];
        
        [_pictureList addObject:pictureInfo];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_indicatorView stopAnimating];
        [_tableView reloadData];
        [_tableView flashScrollIndicators];
    });

}

#pragma mark -
#pragma mark Asychonsized and lazy load image

- (void)startPoctureDownload:(PictureInfo *)pictureInfo block:(void (^)(UIImage *))block
{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        NSData *data = [NSData dataWithContentsOfURL:pictureInfo.imageURL];
        UIImage *image = [UIImage imageWithData:data];
        [image writeToFile:[self coverPath:pictureInfo.pictureId isThumbnail:NO] atomically:YES];
        
        UIImage *thumbnailImage = [image resizeToWidth:CELL_IMAGE_WIDTH height:CELL_IMAGE_HEIGHT];
        [thumbnailImage writeToFile:[self coverPath:pictureInfo.pictureId isThumbnail:YES] atomically:YES];
        
        [_imageCache setObject:thumbnailImage forKey:pictureInfo.pictureId];
        
        if (block) {
            block(image);
        }
        
    });

}

- (void)loadImagesForOnscreenRows
{
    if ([_pictureList count] > 0)
    {
        NSArray *visiblePaths = [_tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            PictureInfo *pictureInfo = [_pictureList objectAtIndex:indexPath.row];
            
            // avoid the app icon download if the app already has an icon
            if (![UIImage imageWithContentsOfFile:[self coverPath:pictureInfo.pictureId isThumbnail:NO]])
            {
                [self startPoctureDownload:pictureInfo block:^(UIImage *image) {
                    
                    MyCustomCell *cell = (MyCustomCell *)[_tableView cellForRowAtIndexPath:indexPath];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.customImageView.image = image;
                        CATransition *transiton = [[CATransition alloc] init];
                        transiton.duration = .5;
                        [cell.layer addAnimation:transiton forKey:@"Animation"];
                    });
                    
                }];
            }
            else
            {
                // means the cover.png is exist , but the thumbnail not exist
                if (![UIImage imageWithContentsOfFile:[self coverPath:pictureInfo.pictureId isThumbnail:YES]]) {
                    UIImage *image = [UIImage imageWithContentsOfFile:[self coverPath:pictureInfo.pictureId isThumbnail:NO]];
                    UIImage *thumbnailImage = [image resizeToWidth:CELL_IMAGE_WIDTH height:CELL_IMAGE_HEIGHT];
                    [thumbnailImage writeToFile:[self coverPath:pictureInfo.pictureId isThumbnail:YES] atomically:YES];
                    
                    [_imageCache setObject:thumbnailImage forKey:pictureInfo.pictureId];
                    
                    MyCustomCell *cell = (MyCustomCell *)[_tableView cellForRowAtIndexPath:indexPath];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.customImageView.image = image;
                        CATransition *transiton = [[CATransition alloc] init];
                        transiton.duration = .5;
                        [cell.layer addAnimation:transiton forKey:@"Animation"];
                    });

                }
            }
            
            
        }
    }
}

- (NSString *)coverPath:(id)pictureId isThumbnail:(BOOL)isThumbnail
{
    NSString *pictureName;
    
    if (isThumbnail) {
        pictureName = [NSString stringWithFormat:@"%@_thumbnail",pictureId];
    }
    else
    {
        pictureName = [NSString stringWithFormat:@"%@",pictureId];
    }
    
    return [[GLCPathForDirectory cachesDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",pictureName]];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_pictureList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MyCustomCellIdentifier";
    
    PictureInfo *pictureInfo = [_pictureList objectAtIndex:indexPath.row];
    
    MyCustomCell *myCustomCell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    if (myCustomCell == nil) {
        myCustomCell = [[MyCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
       
        
        [self startPoctureDownload:pictureInfo block:^(UIImage *__strong image){
            
            dispatch_async(dispatch_get_main_queue(), ^{
            
                myCustomCell.customImageView.image = image;
                CATransition *transition = [[CATransition alloc] init];
                transition.duration = .5;
                [myCustomCell.layer addAnimation:transition forKey:@"Animation"];
                
                
            });
            
        }];
        
    }
            
    myCustomCell.titleString = pictureInfo.title;
    
    UIImage *coverImage = [_imageCache objectForKey:pictureInfo.pictureId];
    
    if (coverImage == nil) {
        coverImage = [UIImage imageWithContentsOfFile:[self coverPath:pictureInfo.pictureId isThumbnail:YES]];
        if (coverImage) {
            [_imageCache setObject:coverImage forKey:pictureInfo.pictureId];
        }
        else
        {
            coverImage = [UIImage imageNamed:@"defaultCover.png"];
        }
    }
    
    myCustomCell.customImageView.image = coverImage;
    
    return myCustomCell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select : %d",indexPath.row);
    
    BriefIntroductionViewController *briefIntroduction = [[BriefIntroductionViewController alloc] init];
    
    [self.navigationController pushViewController:briefIntroduction animated:YES];
    
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}
@end
