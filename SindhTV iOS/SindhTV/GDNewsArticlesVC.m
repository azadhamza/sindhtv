//
//  GDNewsArticlesVC.m
//  SindhTV
//
//  Created by intellisense on 24/05/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDNewsArticlesVC.h"
#import "GDColVwCell.h"
#import "GDArticleCell.h"
#import "GDArticlesWebView.h"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)
@interface GDNewsArticlesVC ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *titleNamesArr;
    NSURL *getListUrl;
    NSDictionary *jsonData;
    GDArticlesWebView *lifelineViewController;
    NSIndexPath *myIndPath,*reloadPath;
    NSInteger mySectionValue;
    CGFloat heightForImageView;
    BOOL isfirstTime;
    NSUserDefaults *defaults;
    UILabel *titleLable;
    UIImageView *ImageView;
    
    TSActivityIndicatorView *customIndicator;
}
@end

@implementation GDNewsArticlesVC
@synthesize urlString,fromHeadlines;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults=[NSUserDefaults standardUserDefaults];
    UIImage *bgimage=[UIImage imageWithData:[defaults valueForKey:@"bgImg"]];
    self.imgVwForBg.image=bgimage;
    
    self.bannerView.adUnitID = [defaults valueForKey:@"bannerCode"];
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[DFPRequest request]];
    
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
    [self getData];
    
    isfirstTime=YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCurrentView) name:@"removeView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:@"reloadView" object:nil];
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
        return 280.0;
    }
    else if (IS_IPHONE_6P)
    {
        return 290.0;
    }
    else if (IS_IPAD)
    {
        return 390.0;
    }
    else
    {
        return 270;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return titleNamesArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    GDArticleCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[GDArticleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    cell.titleHeader.text=[[titleNamesArr objectAtIndex:indexPath.section] valueForKey:@"date"];
    cell.titleHeader.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    cell.titleHeader.textColor=[UIColor whiteColor];
    cell.moreBtn.hidden=YES;
   // NSLog(@"videos count ===========>%li",[[[titleNamesArr objectAtIndex:indexPath.section] objectForKey:@"videos"] count]);
    if ([[[titleNamesArr objectAtIndex:indexPath.section] objectForKey:@"videos"] count]>1) {
        cell.moreBtn.hidden=NO;
    }
    [cell setCollectionViewDataSourceDelegate:self indexPath:indexPath];
    reloadPath=indexPath;
    
    return cell;
    
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
                if ([[jsonData objectForKey:@"items"] isKindOfClass:[NSArray class]])
                {
                    titleNamesArr=[[NSMutableArray alloc]init];
                    titleNamesArr=[[jsonData objectForKey:@"items"] mutableCopy];
                    NSLog(@"Notification Data %@",jsonData);
                    NSLog(@"%lu",(unsigned long)titleNamesArr.count);
                    if (titleNamesArr )
                    {
                        self.articlesTblVw.delegate=self;
                        self.articlesTblVw.dataSource=self;
                        [self.articlesTblVw reloadData];
                        
                        [customIndicator stopAnimating];
                        [customIndicator removeFromSuperview ];
                    }
                    else{
                        
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Nothing to show here" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        //
                        [customIndicator stopAnimating];
                        [customIndicator removeFromSuperview ];
                    }
                    
                }
                else{
                    
                    UIAlertView *alert1=[[UIAlertView alloc]initWithTitle:nil message:@"Nothing to show here" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    
                    
                    [alert1 show];
                    //                    if ([fromHeadlines isEqualToString:@"fromVideos"])
                    //                    {
                    //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeView" object:self];
                    //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolValueNo" object:self];
                    //                        //[[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolForVideosNo" object:self];
                    //
                    //                    }
                    // [self.navigationController popViewControllerAnimated:YES];
                }
            }
        });
    });
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
    GDColVwCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CVCell" forIndexPath:indexPath];
    
    
    
    
    
    cell.titleLbl.text= [[[[titleNamesArr objectAtIndex:sectionValue] objectForKey:@"videos"]  objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    
    cell.titleLbl.textAlignment=NSTextAlignmentCenter;
    
    
    cell.titleLbl.numberOfLines=2;
    
    cell.titleLbl.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    cell.titleLbl.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    cell.titleLbl.textColor=[UIColor whiteColor];
    
    ImageView.backgroundColor=[UIColor clearColor];
    
    
    NSString *imgString=[[[[titleNamesArr objectAtIndex:sectionValue] objectForKey:@"videos"]  objectAtIndex:indexPath.row] objectForKey:@"thumb"];
    NSURL * url=[NSURL URLWithString:imgString];
    NSLog(@"USE PROFILE IMAGE URL IN ViewDidLoad=>%@",url);
    
    
    [cell.imageVw sd_setImageWithURL:url placeholderImage:[ UIImage imageNamed:@"logo"]];
    
    
    cell.backgroundColor=[UIColor clearColor];
    
    
    
    
    return cell;
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval =  CGSizeMake(self.view.frame.size.width, 240);
    
    retval.height = 240;
    heightForImageView=240;
    retval.width = self.view.frame.size.width;
    
    if (IS_IPHONE_6)
    {
        retval.height = 250;
        heightForImageView=250;
        // retval.width = 120;
    }
    else if (IS_IPHONE_6P)
    {
        retval.height=260;
        heightForImageView=260;
        // retval.width=135;
    }
    else if (IS_IPAD)
    {
        retval.height = 360;
        heightForImageView=360;
        // retval.width = 170;
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
    
    
}

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    
//    
//    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//    statusBarView.backgroundColor = [UIColor darkGrayColor];
//    [self.navigationController.navigationBar addSubview:statusBarView];
//    
//    
//    
//    [self.articlesTblVw reloadData];
//    
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//        
//        
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        
//    }
//}

-(void)viewWillAppear:(BOOL)animated
{
    [self.articlesTblVw reloadData];

}

@end
