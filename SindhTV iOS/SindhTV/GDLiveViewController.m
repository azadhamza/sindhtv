//
//  GDLiveVieeController.m
//  SindhTV
//
//  Created by intellisense on 11/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDLiveViewController.h"
#import "GDLiveTableViewCell.h"
#import "GDCollectionViewCell.h"
#import "GDLiveCollectionViewCell.h"
#import "GDWebLiveController.h"
#import "GDArticlesWebView.h"
#import "GDViewAllController.h"
#import "ViewController.h"


#import "TSActivityIndicatorView.h"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)


@interface GDLiveViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *titleArr;
    NSDictionary *jsonData;
    NSURL *getListUrl;
    NSMutableArray *titleNamesArr,*newsArr;
    NSUserDefaults *defaults;
    UIActivityIndicatorView *indicator;
    TSActivityIndicatorView *customIndicator;
    UIImageView *imageview1;
    NSInteger topValue;
    NSIndexPath *myIndPath;
    NSInteger mySectionValue;
    GDArticlesWebView *lifelineViewController;
}
@end

@implementation GDLiveViewController
@synthesize fromHeadlines,headLinesArr,videosArr,urlString,value;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults=[NSUserDefaults standardUserDefaults];
    
    self.bannerView.adUnitID = [defaults valueForKey:@"bannerCode"];
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[DFPRequest request]];
    
    
    
    
    
    if ([fromHeadlines isEqualToString:@"fromVideos"]) {
        
        
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:(75/255.0) blue:(142/255.0) alpha:1.0]];
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.topSpaceForTblVw.constant=value;
    }
    
    UIImage *image = [UIImage imageNamed:[defaults valueForKey:@"applogo"]];
    
    imageview1 = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = imageview1;
    
    
    
    UIImage *bgimage=[UIImage imageWithData:[defaults valueForKey:@"bgImg"]];
    
    self.imgVwForBg.image=bgimage;
    self.tblVw.backgroundColor=[UIColor clearColor];
    customIndicator =
    [[TSActivityIndicatorView alloc] initWithFrame:CGRectMake(160-17, 100, 40, 40)];
    customIndicator.frames = @[@"activity-indicator-1",
                               @"activity-indicator-2",
                               @"activity-indicator-3",
                               @"activity-indicator-4",
                               @"activity-indicator-5",
                               @"activity-indicator-6"];
    
    
    customIndicator.duration = 0.5f;
    customIndicator.hidesWhenStopped = YES;
    customIndicator.center=self.view.center;
    [self.view addSubview:customIndicator];
    
    [customIndicator startAnimating];
    
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCurrentView) name:@"removeView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:@"reloadView" object:nil];
    //reloadView
    [self getData];
    
    // titleArr=@[@"Live",@"Headlines",@"Article",@"Videos",@"ePaper",@"User Uploads",@"Share"];
    titleArr=headLinesArr;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)removeCurrentView
{
    [lifelineViewController.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolForArticlesNo" object:self];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolForVideosNo" object:self];
    
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (IS_IPHONE_6) {
        return 140.0;
    }
    else if (IS_IPHONE_6P)
    {
        return 150.0;
    }
    else if (IS_IPAD)
    {
        return 170.0;
    }
    else
    {
    return 122.0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return titleNamesArr.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDLiveTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"tableCell"];
    if (cell==nil) {
        cell=[[GDLiveTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    // if ([fromHeadlines isEqualToString:@"headLines"]) {
    
    cell.viewAllBtn.hidden=YES;
    cell.viewAll2.hidden=YES;
    
    //}
    cell.viewAllBtn.tag=indexPath.section;
    cell.viewAll2.tag=indexPath.section;
    
    if ([fromHeadlines isEqualToString:@"fromVideos"])
    {
        cell.titleHeader.text=[[titleNamesArr valueForKey:@"schedule_name" ] objectAtIndex:indexPath.section];
    }
    else{
        cell.titleHeader.text=[[titleNamesArr valueForKey:@"schedule_name" ] objectAtIndex:indexPath.section];
    }
    cell.titleHeader.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    cell.titleHeader.textColor=[UIColor whiteColor];
    
    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    
    return cell;
    
}
- (IBAction)viewAllBtnAction:(UIButton *)sender
{
    
    GDViewAllController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"viewAll"];
    if ([fromHeadlines isEqualToString:@"fromVideos"])
    {
        vc.headerTitle=[[titleNamesArr valueForKey:@"schedule_name" ] objectAtIndex:sender.tag];
    }
    else
    {
        vc.headerTitle=[[titleNamesArr valueForKey:@"date" ] objectAtIndex:sender.tag];
    }
    
    vc.articlesArr=[[titleNamesArr valueForKey:@"videos" ] objectAtIndex:sender.tag];
    vc.value=topValue;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    // newsArr=[[titleNamesArr objectAtIndex:collectionView.tag] objectForKey:@"videos"];
    // NSLog(@"tag ========>>>>%i",collectionView.tag);
    //return [[[titleNamesArr objectAtIndex:collectionView.tag] objectForKey:@"videos"] count];
    //NSLog(@"count== ========>>>>%i",newsArr.count);
    //return newsArr.count;
    //return titleArr.count;
    
    
    return [[[titleNamesArr objectAtIndex:collectionView.tag] objectForKey:@"videos"] count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    int sectionValue=(int)collectionView.tag;
    GDLiveCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"liveCell" forIndexPath:indexPath];
    
      
    
    // cell.titleName.text=[[newsArr valueForKey:@"title" ] objectAtIndex:indexPath.row];
    
    cell.titleName.text= [[[[titleNamesArr objectAtIndex:sectionValue] objectForKey:@"videos"]  objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    // [cell.titleLbl sizeToFit];
    
    cell.titleName.textAlignment=NSTextAlignmentCenter;
    
    if ([fromHeadlines isEqualToString:@"headLines"])
    {
        cell.titleName.numberOfLines=1;
        cell.titleName.font = [UIFont fontWithName:@"Arial-BoldMT" size:15];
        
    }
    else
    {
        cell.titleName.numberOfLines=2;
        
        cell.titleName.font = [UIFont fontWithName:@"Arial-BoldMT" size:10];
    }
    cell.titleName.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    NSString *imgString=[[[[titleNamesArr objectAtIndex:sectionValue] objectForKey:@"videos"]  objectAtIndex:indexPath.row] objectForKey:@"thumb"];
    NSURL * url=[NSURL URLWithString:imgString];
    NSLog(@"USE PROFILE IMAGE URL IN ViewDidLoad=>%@",url);
    
    
    [cell.imgVw sd_setImageWithURL:url placeholderImage:[ UIImage imageNamed:@"logo"]];
       //    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
    //        if (succeeded) {
    //
    //            if (image==nil) {
    //                cell.imgVw.image=[UIImage imageNamed:@"logo"];
    //
    //            }
    //            else{
    //                cell.imgVw.image=image;
    //
    //
    //
    //            }
    //            // save image in
    //        }
    //        else
    //        {
    //           cell.imgVw.image=[UIImage imageNamed:@"logo"];
    //        }
    //
    //    }];
    return cell;
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval =  CGSizeMake(75, 100);
    
    retval.height = 75;
    retval.width = 100;
    
    if (IS_IPHONE_6)
    {
        retval.height = 90;
        retval.width = 120;
    }
    else if (IS_IPHONE_6P)
    {
        retval.height=95;
        retval.width=135;
    }
    else if (IS_IPAD)
    {
        retval.height = 120;
        retval.width = 170;
    }
    //    else if (IS_IPAD_PRO_1366)
    //    {
    //        NSLog(@"It is ipad pro 1366");
    //        retval.height = 200;
    //        retval.width = 700;
    //    }
    
    return retval;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int sectionValue=(int)collectionView.tag;
    
    
    if ([fromHeadlines isEqualToString:@"FROMARTICLES"])
    {
        myIndPath=indexPath;
        mySectionValue=(int)collectionView.tag;
        //
        //        GDArticlesWebView *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"articlesWebVw"];
        //        vc.urlString=[NSString stringWithFormat:@"%@",[[[[titleNamesArr objectAtIndex:sectionValue] objectForKey:@"videos"]  objectAtIndex:indexPath.row] objectForKey:@"webview_url"] ];
        //        NSLog(@"web url========>>>>%@",vc.urlString);
        //        [self.navigationController pushViewController:vc animated:YES];
        
        
        
        lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"articlesWebVw"];
        
        //lifelineViewController.fromHeadlines=@"FROMARTICLES";
        lifelineViewController.urlString=[NSString stringWithFormat:@"%@",[[[[titleNamesArr objectAtIndex:sectionValue] objectForKey:@"videos"]  objectAtIndex:indexPath.row] objectForKey:@"webview_url"] ];
        
        
        
        lifelineViewController.view.frame =self.mainVw.bounds;
        [lifelineViewController willMoveToParentViewController:self];
        [self.mainVw addSubview:lifelineViewController.view];
        [self addChildViewController:lifelineViewController];
        [lifelineViewController didMoveToParentViewController:self];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolValue" object:self];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"setForArticles" object:self];
        
        
        
        
    }
    else
    {
        GDWebLiveController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"webLive"];
        vc.urlString=[NSString stringWithFormat:@"%@",[[[[titleNamesArr objectAtIndex:sectionValue] objectForKey:@"videos"]  objectAtIndex:indexPath.row] objectForKey:@"webview_url"] ];
        NSLog(@"web url========>>>>%@",vc.urlString);
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    //[[newsArr valueForKey:@"webview_url" ] objectAtIndex:indexPath.row]];
    
    
}

-(void)reloadView
{
    [lifelineViewController.view removeFromSuperview];
    lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"articlesWebVw"];
    
    //lifelineViewController.fromHeadlines=@"FROMARTICLES";
    lifelineViewController.urlString=[NSString stringWithFormat:@"%@",[[[[titleNamesArr objectAtIndex:mySectionValue] objectForKey:@"videos"]  objectAtIndex:myIndPath.row] objectForKey:@"webview_url"] ];
    
    
    
    lifelineViewController.view.frame =self.mainVw.bounds;
    [lifelineViewController willMoveToParentViewController:self];
    [self.mainVw addSubview:lifelineViewController.view];
    [self addChildViewController:lifelineViewController];
    [lifelineViewController didMoveToParentViewController:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolValue" object:self];
    
    
}

-(void)getData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString * post=[NSString stringWithFormat:@""];
        getListUrl=[[NSURL alloc] initWithString:urlString];
        NSLog(@"URL ====== %@",getListUrl);
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:getListUrl];
        [request setHTTPMethod:@"GET"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSError *error;
        NSHTTPURLResponse *response = nil;
        
        NSData * urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %ld", (long)[response statusCode]);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (urlData)
            {
                jsonData=[[NSDictionary alloc] init];
                jsonData = [NSJSONSerialization
                            JSONObjectWithData:urlData
                            options:NSJSONReadingMutableContainers
                            error:nil];
                if ([jsonData objectForKey:@"items"])
                {
                    titleNamesArr=[[NSMutableArray alloc]init];
                    titleNamesArr=[[jsonData objectForKey:@"items"] mutableCopy];
                    NSLog(@"Notification Data %@",jsonData);
                    NSLog(@"%lu",(unsigned long)titleNamesArr.count);
                    if (titleNamesArr )
                    {
                        self.tblVw.delegate=self;
                        self.tblVw.dataSource=self;
                        [self.tblVw reloadData];
                        
                        [customIndicator stopAnimating];
                        [customIndicator removeFromSuperview ];
                    }
                    else{
                        
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Nothing to show here" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        
                        [customIndicator stopAnimating];
                        [customIndicator removeFromSuperview ];
                    }
                    
                }
                else{
                    
                    UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:nil message:@"Nothing to show here" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    
                    [alert1 show];
                    if ([fromHeadlines isEqualToString:@"fromVideos"])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeView" object:self];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolValueNo" object:self];
                        //[[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolForVideosNo" object:self];
                        
                    }
                    [customIndicator stopAnimating];
                    [customIndicator removeFromSuperview ];
                    // [self.navigationController popViewControllerAnimated:YES];
                }
            }
        });
    });
}

- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if ( !error )
                               {
                                   UIImage *image = [[UIImage alloc] initWithData:data];
                                   completionBlock(YES,image);
                               }
                               else        {
                                   completionBlock(NO,nil);
                               }
                           }];
}
//-(void) restrictRotation:(BOOL) restriction
//{
//    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.restrictRotation = restriction;
//}


//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//        // topValue=32;
//        
//        
//        
//        if (!IS_IPAD)
//        {
//            imageview1.frame=CGRectMake(0, 0, 120, 25);
//        }
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        
//        
//        
//        NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        if (!IS_IPAD)
//        {
//            imageview1.frame=CGRectMake(0, 0, 100, 30);
//            
//        }
//        
//        
//        
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        
//        NSLog(@"UIDeviceOrientationPortrait");
//    }
//}
//

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
    UIImage *image = [UIImage imageNamed:[defaults valueForKey:@"applogo"]];
    
    imageview1 = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = imageview1;
    
    
 //   [self restrictRotation:NO];
    
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        
//        //topValue=64;
//        
//        if ([fromHeadlines isEqualToString:@"fromVideos"]) {
//            
//            if (IS_IPAD) {
//                //self.topSpaceForTblVw.constant=64;
//            }
//            else
//            {
//                
//                //self.topSpaceForTblVw.constant=64;
//            }
//        }
//        if (IS_IPAD&& [fromHeadlines isEqualToString:@"fromVideos"]) {
//            // self.topSpaceForTblVw.constant=64;
//        }
//        
//        if (!IS_IPAD)
//        {
//            imageview1.frame=CGRectMake(0, 0, 100, 40);
//            
//        }
//        
//    }
//    
//    else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//        topValue=32;
//        
//        if ([fromHeadlines isEqualToString:@"fromVideos"])
//        {
//            
//            
//            if (IS_IPAD) {
//                //self.topSpaceForTblVw.constant=64;
//            }
//            else
//            {
//                
//                // self.topSpaceForTblVw.constant=32;
//            }
//            
//        }
//        
//        if (!IS_IPAD)
//        {
//            imageview1.frame=CGRectMake(0, 0, 120, 30);
//        }
//        
//        
//        
//        NSLog(@"Lanscapse");
//    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"forArticles" object:self];
    
}

@end
