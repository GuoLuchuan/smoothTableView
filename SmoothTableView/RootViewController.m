//
//  RootViewController.m
//  SmoothTableView
//
//  Created by guoluchuan on 13-3-13.
//  Copyright (c) 2013年 yours. All rights reserved.
//

#import "RootViewController.h"
#import "MyCustomCell.h"
#import "GLCImageCache.h"
#import "ImageDownloadOperation.h"
#import "BriefIntroductionViewController.h"

#define CELLHEIGHT      60

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
        
        _tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
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
    //TODO:show the indicator
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //TODO:download the picture name list
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
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
