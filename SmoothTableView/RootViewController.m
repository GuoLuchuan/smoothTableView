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
#import "ImageDownloadOperation.h"
#import "BriefIntroductionViewController.h"
#import "PictureInfo.h"

#define CELLHEIGHT      60

static const NSString *kFlickrAPIKey = @"583366ad887b297494873eb1710fa739";
static const NSInteger kNumberOfImages = 30;

@interface RootViewController ()
{
    UITableView *_tableView;
    NSMutableArray *_pictureList;
    
    NSOperationQueue *_operationQueue;
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
        
        _operationQueue = [[NSOperationQueue alloc] init];
        [_operationQueue setMaxConcurrentOperationCount:NSOperationQueueDefaultMaxConcurrentOperationCount];
        
        self.view.frame = [[UIScreen mainScreen] bounds];
        [self.view addSubview:_tableView];
        
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
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //TODO:show the indicator
    [self beginLoadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)beginLoadData
{
    NSInvocationOperation *pictureListOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadPictureLists) object:nil];
    [_operationQueue addOperation:pictureListOperation];
}

- (void)downloadPictureLists
{
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=%d&format=json&nojsoncallback=1", kFlickrAPIKey, @"Haerbin", kNumberOfImages];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    // Get the contents of the URL as a string, and parse the JSON into Foundation objects.
    NSString *jsonString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *results = [jsonString JSONValue];
    
    [self performSelectorOnMainThread:@selector(didFinishDownloadPictureLists:) withObject:results waitUntilDone:NO];

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
    
    [_tableView reloadData];
    [_tableView flashScrollIndicators];
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
    MyCustomCell *myCustomCell = [tableView dequeueReusableCellWithIdentifier:identifier] ;
    if (myCustomCell == nil) {
        myCustomCell = [[MyCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
       
        //TODO:set up the cell base property
        
    }
    
    //TODO:set up the different cells different property
    myCustomCell.textLabel.text = ((PictureInfo *)[_pictureList objectAtIndex:indexPath.row]).title;
    return myCustomCell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select : %d",indexPath.row);
    
    BriefIntroductionViewController *briefIntroduction = [[BriefIntroductionViewController alloc] init];
    
    [self.navigationController pushViewController:briefIntroduction animated:YES];
    
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //TODO:lazy load
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //TODO:lazy load
}
@end
