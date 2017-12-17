
//
//  GDChannelVideos.m
//  SindhTV
//
//  Created by intellisense on 22/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDChannelVideos.h"
#import "GDLiveViewController.h"
#import "GDMyVideoCustomCell.h"
#import "TSActivityIndicatorView.h"
#import "UIImageView+WebCache.h"
#import "KTCenterFlowLayout.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)

@interface GDChannelVideos ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSURL *getListUrl;
    NSMutableArray *titleNamesArr;
    NSMutableDictionary *jsonData;
    NSUserDefaults *defaults;
    
    UIActivityIndicatorView *indicator;
    GDLiveViewController *lifelineViewController;
    UIImageView *imageview1;
    TSActivityIndicatorView *customIndicator;
    NSInteger pathForReload;
    UIImageView *imageVw;
    NSMutableString *myUrlString;
    NSString *orientation;
    NSIndexPath *rotationPath;

}
@end

@implementation GDChannelVideos
@synthesize urlString;
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
  imageVw=[[UIImageView alloc]init];
    
    defaults=[NSUserDefaults standardUserDefaults];
    
    
    
    KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
    layout.minimumInteritemSpacing = -10.f;
    layout.minimumLineSpacing = 0.f;
    if (IS_IPHONE_4) {
        layout.minimumLineSpacing = 0.f;
    }
    
    
    //KTCenterFlowLayout *layout = [[KTCenterFlowLayout alloc] init];
    
    [self.videosColVw setCollectionViewLayout:layout];

    
    
    self.bannerView.adUnitID = [defaults valueForKey:@"bannerCode"];
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[DFPRequest request]];
    
    
    UIImage *bgimage=[UIImage imageWithData:[defaults valueForKey:@"bgImg"]];
    
    self.imgVwForBgVw.image=bgimage;
    
    
    
    UIImage *image = [UIImage imageNamed:[defaults valueForKey:@"applogo"]];
    
    imageview1 = [[UIImageView alloc] initWithImage:image];
    //      if (IS_IPAD)
    //    {
    //        imageview1.frame=CGRectMake(0, 0, 160, 40);
    //
    //    }
    //
    //    else{
    //        imageview1.frame=CGRectMake(0, 0, 100, 40);
    //
    //    }
    
    
    // set the text view to the image view
    self.navigationItem.titleView = imageview1;
    
    //removeView
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeCurrentView) name:@"removeView" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContent) name:@"reloadVideos" object:nil];
   
    
    [self getDetails];
    // Do any additional setup after loading the view.
}
-(void)reloadContent
{
    [lifelineViewController.view removeFromSuperview];

    lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"live"];
    

    lifelineViewController.urlString=[NSString stringWithFormat:@"%@",[defaults valueForKey:@"url"]];
    lifelineViewController.fromHeadlines=@"fromVideos";

    lifelineViewController.view.frame =self.mainVw.bounds;
    
    [lifelineViewController willMoveToParentViewController:self];
    [self.mainVw addSubview:lifelineViewController.view];
    [self addChildViewController:lifelineViewController];
    [lifelineViewController didMoveToParentViewController:self];
    
}
-(void)removeCurrentView
{
    //[self.navigationController popViewControllerAnimated:YES];
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
    {
        
        
             if (IS_IPAD) {
            
        }else{
            imageview1.frame=CGRectMake(0, 0, 120, 30);
             self.navigationItem.titleView = imageview1;
            
        }
        
        NSLog(@"Lanscapse");
    }
    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
    {
        
        if (!IS_IPAD)
        {
            imageview1.frame=CGRectMake(0, 0, 100, 40);
             self.navigationItem.titleView = imageview1;
            
        }
        
          }

    [lifelineViewController.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolForVideosNo" object:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)videosBtnAction:(UIButton *)sender
{
    pathForReload=sender.tag;
   lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"live"];
    
    
    lifelineViewController.urlString=[NSString stringWithFormat:@"http://sindhtv.tv/index.php/api/category_video/%@/%@",[[titleNamesArr valueForKey:@"menu_id"]objectAtIndex:sender.tag],[defaults valueForKey:@"channelID"]];
    
    [defaults setValue:[NSString stringWithFormat:@"http://sindhtv.tv/index.php/api/category_video/%@/%@",[[titleNamesArr valueForKey:@"menu_id"]objectAtIndex:pathForReload ],[defaults valueForKey:@"channelID"]] forKey:@"url"];
    
    myUrlString=[NSMutableString stringWithFormat:@"http://sindhtv.tv/index.php/api/category_video/%@/%@",[[titleNamesArr valueForKey:@"menu_id"]objectAtIndex:sender.tag ],[defaults valueForKey:@"channelID"]];
    lifelineViewController.fromHeadlines=@"fromVideos";
  
    lifelineViewController.view.frame =self.mainVw.bounds;
    
    [lifelineViewController willMoveToParentViewController:self];
    [self.mainVw addSubview:lifelineViewController.view];
    [self addChildViewController:lifelineViewController];
    [lifelineViewController didMoveToParentViewController:self];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolValue" object:self];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"setForVideos" object:self];
    //[self.navigationController pushViewController:vc animated:YES];
}


-(void)getDetails
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
        
        //           [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
        
        NSError *error;
        NSHTTPURLResponse *response = nil;
        
        NSData * urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        NSLog(@"Response code: %ld", (long)[response statusCode]);
        
        //        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        //        NSLog(@"Response ==> %@", responseData);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (urlData)
            {
                jsonData=[[NSMutableDictionary alloc] init];
                jsonData = [NSJSONSerialization
                            JSONObjectWithData:urlData
                            options:NSJSONReadingMutableContainers
                            error:nil];
                if ([[jsonData objectForKey:@"items"] isKindOfClass:[NSArray class]])
                {
                    titleNamesArr=[[NSMutableArray alloc]init];
                    titleNamesArr=[jsonData objectForKey:@"items"];
                    
                    NSLog(@"Notification Data %@",jsonData);
                    
                    
                    NSLog(@"%lu",(unsigned long)titleNamesArr.count);
                    
                    if (titleNamesArr )
                    {
                        self.videosColVw.delegate=self;
                        self.videosColVw.dataSource=self;
                        [self.videosColVw reloadData];
                        [customIndicator stopAnimating];
                        [customIndicator removeFromSuperview];
                        
                    }
                    else{
                        
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Nothing to show here" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        [customIndicator stopAnimating];
                        [customIndicator removeFromSuperview];
                    }
                    
                }
                else{
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Nothing to show here" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    [customIndicator stopAnimating];
                    [customIndicator removeFromSuperview];
                    //[self.navigationController popViewControllerAnimated:YES];
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
                               } else{
                                   completionBlock(NO,nil);
                               }
                           }];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return titleNamesArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GDMyVideoCustomCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"MyVideosCell" forIndexPath:indexPath];
    
    cell.videosTitleName.text=[[titleNamesArr valueForKey:@"menu_name"] objectAtIndex:indexPath.row];
    
    cell.videosTitleName.textAlignment=NSTextAlignmentCenter;
    if (IS_IPAD) {
        cell.videosTitleName.font=[UIFont fontWithName:@"Arial-BoldMT" size:21];
    }

    
    NSString *imgString=[[titleNamesArr valueForKey:@"menu_icon"] objectAtIndex:indexPath.row];
    NSURL * url=[NSURL URLWithString:imgString];
    NSLog(@"USE PROFILE IMAGE URL IN ViewDidLoad=>%@",url);
   
    
//    [imageVw sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"sindhTv"]];
//    
//    [cell.videosBtn setBackgroundImage:imageVw.image forState:UIControlStateNormal];
    
    
    
    
    //[cell.imgVw sd_setImageWithURL:url placeholderImage:[ UIImage imageNamed:@"logo"]];
    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            
            if (image==nil) {
                [cell.videosBtn setBackgroundImage:[UIImage imageNamed:@"sindhTv" ] forState:UIControlStateNormal];
            }
            else{
                [cell.videosBtn setBackgroundImage:image forState:UIControlStateNormal];
                
                                cell.videosBtn.layer.cornerRadius = cell.videosBtn.frame.size.height/2; // 60 this value vary as per your desire
                                cell.videosBtn.clipsToBounds = YES;
                
            }
            // save image in
        }
        else
        {
            [cell.videosBtn setBackgroundImage:[UIImage imageNamed:@"sindhTv" ] forState:UIControlStateNormal];        }
        
    }];
    
    
    
    
   // [cell.Channel setBackgroundImage:[UIImage imageNamed:@"sindhTv" ] forState:UIControlStateNormal];
    
    cell.videosBtn.tag=indexPath.row;
    
    NSLog(@"indexpath is %li",(long)cell.videosBtn.tag);
    
    
    
    
    
    
    
//    
//    if ([orientation isEqualToString:@"Portrait"])
//    {
//   
//        if (indexPath.row%2==0  &&[orientation isEqualToString:@"Portrait"]&& !IS_IPAD) {
//            cell.btnLeftConstant.constant=35;
//            cell.btnRightConstant.constant=5;
//        }
//        else if(indexPath.row%2==1 &&[orientation isEqualToString:@"Portrait"] &&!IS_IPAD)
//        {
//            cell.btnLeftConstant.constant=5;
//            cell.btnRightConstant.constant=35;
//            
//        }
//    }
//    else //if([orientation isEqualToString:@"Lanscapse"])
//    {
//        
//        cell.btnLeftConstant.constant=20;
//        cell.btnRightConstant.constant=20;
//    }
    
    
    
    
    
//    else{
//        if (indexPath.row%2==0  && !IS_IPAD) {
//            cell.btnLeftConstant.constant=35;
//            cell.btnRightConstant.constant=5;
//        }
//        else if(indexPath.row%2==1  &&!IS_IPAD)
//        {
//            cell.btnLeftConstant.constant=5;
//            cell.btnRightConstant.constant=35;
//            
//        }
//
//    }

    rotationPath=indexPath;
    
    return cell;
    
    
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval =  CGSizeMake(150, 160);
    
    retval.height = 160;
    retval.width = 150;
    
    if (IS_IPHONE_6)
    {
        retval.height = 170;
        retval.width = 160;
    }
    else if (IS_IPHONE_6P)
    {
        retval.height=190;
        retval.width=180;
    }
    else if (IS_IPAD)
    {
        retval.height = 240;
        retval.width = 230;
    }
    //    else if (IS_IPAD_PRO_1366)
    //    {
    //        NSLog(@"It is ipad pro 1366");
    //        retval.height = 200;
    //        retval.width = 700;
    //    }
    
    return retval;
}



//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//   
//    
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//                // [self.videosColVw reloadData];
//
//        
//        
//               UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        orientation=@"Lanscape";
//        NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        
//       // [self.videosColVw reloadData];
//        
//        
//                UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        orientation=@"Portrait";
//        
//        NSLog(@"UIDeviceOrientationPortrait");
//    }
//}
//
//

-(void)viewWillAppear:(BOOL)animated
{

//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//        
//        
//        
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        
//        if (IS_IPAD) {
//                     
//        }else{
//            imageview1.frame=CGRectMake(0, 0, 120, 25);
//             self.navigationItem.titleView = imageview1;
//          
//        }
//        orientation=@"Lanscape";
//        NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//       
//        if (!IS_IPAD)
//        {
//            imageview1.frame=CGRectMake(0, 0, 100, 30);
//             self.navigationItem.titleView = imageview1;
//            
//        }
//        
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        
//        orientation=@"Portrait";
//
//        NSLog(@"UIDeviceOrientationPortrait");
//    }
//
}

@end
