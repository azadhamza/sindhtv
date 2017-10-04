//
//  GDChannelsViewController.m
//  SindhTV
//
//  Created by intellisense on 16/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDChannelsViewController.h"
#import "GDCustomViewCell.h"
#import "ViewController.h"
#import "KTCenterFlowLayout.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)

@interface GDChannelsViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSURL *ChannelUrl;
    NSDictionary *jsonData;
    NSArray *channelArr,*ChannelImagesArr,*ChannelNamesArr;
    NSString *orientation;
    NSUserDefaults *defaults;
    UIImageView *imageview;
    TSActivityIndicatorView *customIndicator;
    
    UIActivityIndicatorView *indicator;
    AppDelegate *appdelegate;
}
@end

@implementation GDChannelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegate=[[UIApplication sharedApplication]delegate];
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
    
    ChannelImagesArr=@[@"sindhTvIcon",@"sindhtvnewsIcon",@"jeejalIcon"];
    ChannelNamesArr=@[@"Sindh TV",@"Sindh TV News",@"Daily Jeejal"];
    //[indicator startAnimating];
    defaults = [NSUserDefaults standardUserDefaults];
    
    KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
    layout.minimumInteritemSpacing = -15.f;
    layout.minimumLineSpacing = 0.f;
    if (IS_IPHONE_4) {
        layout.minimumLineSpacing = 0.f;
    }
    
    
    
    [self.channelsColVw setCollectionViewLayout:layout];
    self.backGroundVw.image=[UIImage imageNamed:@"allchannel_bg"];

    
    self.bannerView.adUnitID = [defaults valueForKey:@"bannerCode"];
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[DFPRequest request]];
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:(75/255.0) blue:(142/255.0) alpha:1.0]];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
    statusBarView.backgroundColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    
    [self getDetails];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GDCustomViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"channelCell" forIndexPath:indexPath];
    
    cell.channelTitleName.text=[ChannelNamesArr objectAtIndex:indexPath.row];//[[channelArr valueForKey:@"channel_name"] objectAtIndex:indexPath.row];
    
    cell.channelTitleName.textAlignment=NSTextAlignmentCenter;
    if (IS_IPAD) {
        cell.channelTitleName.font=[UIFont fontWithName:@"Arial-BoldMT" size:25];
    }
    
    NSString *imgString=[[channelArr valueForKey:@"channel_thumb"] objectAtIndex:indexPath.row];
    NSURL * url=[NSURL URLWithString:imgString];
    NSLog(@"USE PROFILE IMAGE URL IN ViewDidLoad=>%@",url);
    [cell.Channel setBackgroundImage:[UIImage imageNamed:[ChannelImagesArr objectAtIndex:indexPath.row] ] forState:UIControlStateNormal];
   
//    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
//        if (succeeded) {
//            
//            if (image==nil) {
//                [cell.Channel setBackgroundImage:[UIImage imageNamed:@"sindhTv" ] forState:UIControlStateNormal];
//            }
//            else{
//                [cell.Channel setBackgroundImage:image forState:UIControlStateNormal];
//                
////                cell.Channel.layer.cornerRadius = cell.Channel.frame.size.width/2; // 60 this value vary as per your desire
////                cell.Channel.clipsToBounds = YES;
//                
//            }
//            // save image in
//        }
//        else
//        {
//            [cell.Channel setBackgroundImage:[UIImage imageNamed:@"sindhTv" ] forState:UIControlStateNormal];
//        }
//        
//    }];
    
    
    
    
    //[cell.Channel setBackgroundImage:[UIImage imageNamed:@"sindhTv" ] forState:UIControlStateNormal];
    
    cell.Channel.tag=indexPath.row;
    
    NSLog(@"indexpath is %li",(long)cell.Channel.tag);
    
    if (channelArr.count==2 )
    {
        CGFloat hight=self.view.frame.size.height/2;
        
        
        CGFloat topSpace=hight-140;
        self.topSpaceForColVw.constant=topSpace;
           }
    
     return cell;
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize retval =  CGSizeMake(self.channelsColVw.frame.size.width-40, 160);
    
    retval.height = 160;
    retval.width = 150;
    
    //    if (IS_IPHONE_5) {
    //        retval.height = 170;
    //        retval.width = 160;
    //    }
    if (IS_IPHONE_6)
    {
        retval.height = 185;
        retval.width = 175;
    }
    else if (IS_IPHONE_6P)
    {
        retval.height=204;
        retval.width=194;
    }
    else if (IS_IPAD)
    {
        retval.height = 260;
        retval.width = 250;
    }
    //    else if (IS_IPAD_PRO_1366)
    //    {
    //        NSLog(@"It is ipad pro 1366");
    //        retval.height = 200;
    //        retval.width = 700;
    //    }
    retval.height = 160;
    retval.width= self.channelsColVw.frame.size.width-40;
    return retval;
}


//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row==0) {
//
//    ViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
//    [self.navigationController pushViewController:vc animated:YES];
//
//    }
//
//}

- (IBAction)ChannelAction:(UIButton *)sender {
    
    NSLog(@"path is %li",(long)sender.tag);
    
    
    ViewController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"viewController"];
    
    if (sender.tag==0)
    {
        vc.channelID=@"30";//[[channelArr valueForKey:@"channel_id"] objectAtIndex:sender.tag];
        [defaults setValue:@"30" forKey:@"channelID"];

        
        
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"sindhTvBg"], 1.0);
     
        [ defaults setValue:@"sindhTvIcon" forKey:@"applogo"];
        [ defaults setObject:imageData forKey:@"bgImg"];
        [defaults synchronize];

    }
    else if (sender.tag==1)
    {
//    sindhtvnews_bg
        vc.channelID=@"29";//[[channelArr valueForKey:@"channel_id"] objectAtIndex:sender.tag];
        [defaults setValue:@"29" forKey:@"channelID"];
        NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"sindhtvnews_bg"], 1.0);
        
        [ defaults setValue:@"sindhtvnewsIcon" forKey:@"applogo"];
       
        [ defaults setObject:imageData forKey:@"bgImg"];
        [defaults synchronize];

    }
    else{
        vc.channelID=@"58";//[[channelArr valueForKey:@"channel_id"] objectAtIndex:sender.tag];
        [defaults setValue:@"58" forKey:@"channelID"];
        [ defaults setValue:@"jeejalIcon" forKey:@"applogo"];
        [defaults synchronize];

    
    }
    //channel_thumb
    [defaults setObject:[[channelArr valueForKey:@"channel_thumb"] objectAtIndex:sender.tag] forKey:@"channelImage"];
    
    [defaults synchronize];
    
    if ([orientation isEqualToString:@"Lanscape"])
    {
        
        if (IS_IPAD) {
            vc.value=64;
        }
        else  if ([UIScreen mainScreen].bounds.size.width==736) {
            vc.value=44;
        }
        else{
            vc.value=32;
        }
    }
    else{
        vc.value=64;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getDetails
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString * post=[NSString stringWithFormat:@""];
        
        
        
        ChannelUrl=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://sindhtv.tv/index.php/api/config"]];
        
        
        NSLog(@"URL ====== %@",ChannelUrl);
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:ChannelUrl];
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
        
        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (urlData)
            {
                jsonData=[[NSDictionary alloc] init];
                jsonData = [NSJSONSerialization
                            JSONObjectWithData:urlData
                            options:NSJSONReadingMutableContainers
                            error:nil];
                
                channelArr=[jsonData objectForKey:@"items"];
                
                NSString *bgImageString=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"application_bg"]];
                
                
                NSString *listBgClr=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"list_bgcolor"]];
                [defaults setValue:listBgClr forKey:@"sideMenuBg"];
                
                NSString *listTextClr=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"list_tcolor"]];
                [defaults setValue:listTextClr forKey:@"sideMenuText"];
                
                
                NSString *menuActionClr=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"menu_acolor"]];
                [defaults setValue:menuActionClr forKey:@"colVwSelectionClr"];
                
                NSString *menuSeparotor=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"menu_scolor"]];
                [defaults setValue:menuSeparotor forKey:@"colVwSepearator"];
                
                
                NSString *menuBgClr=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"menu_bgcolr"]];
                [defaults setValue:menuBgClr forKey:@"colVwBgClr"];
                
                
                NSString *menuSeparateClr=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"menu_scolor"]];
                [defaults setValue:menuSeparateClr forKey:@"colVwSeparator"];
                
                
                NSString *menuTextClr=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"menu_tcolor"]];
                [defaults setValue:menuTextClr forKey:@"colVwTextClr"];
                
                
                NSString *menuUClr=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"menu_ucolor"]];
                [defaults setValue:menuUClr    forKey:@"colVwUnderLineClr"];
                
                
                
                NSString *bannerCode=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"banner_code_ios"]];
                [defaults setValue:bannerCode forKey:@"bannerCode"];
                
                NSString *interestitialsCode=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"interstitial_code_ios"]];
                //playstore_ios
                
                
                [defaults setValue:interestitialsCode forKey:@"interestitialsCode"];
                
                NSString *playStoreLink=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"playstore_ios"]];
                
                [defaults setValue:playStoreLink forKey:@"playStoreLink"];
                
                [defaults synchronize];
                
                self.bannerView.adUnitID = [defaults valueForKey:@"bannerCode"];
                self.bannerView.rootViewController = self;
                [self.bannerView loadRequest:[DFPRequest request]];

                
                NSString *appLogo=[NSString stringWithFormat:@"%@", [[jsonData objectForKey:@"application" ] valueForKey:@"application_logo"]];
                [defaults setValue:[[jsonData objectForKey:@"application" ] valueForKey:@"application_logo"] forKey:@"imageUrl"];
                [defaults synchronize];
                
                NSURL *url1=[NSURL URLWithString:appLogo];
                
                
                [self downloadImageWithURL:url1 completionBlock:^(BOOL succeeded, UIImage *image) {
                    if (succeeded) {
                        
                        if (image==nil)
                        {
                            UIImage *image = [UIImage imageNamed: @"logo"];
                            
                            imageview = [[UIImageView alloc] initWithImage:image];
                            imageview.frame=CGRectMake(0, 0, 100, 30);
                            
                            if (IS_IPAD)
                            {
                                imageview.frame=CGRectMake(0, 0, 120, 30);
                                
                            }
                            
                            
                            
                            self.navigationItem.titleView = imageview;
                            
                        }
                        else{
                            
                            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
                            
                            
                            
                            // UIImage *image = [UIImage imageNamed: @"logo"];
                            imageview = [[UIImageView alloc] initWithImage:image];
                            if (IS_IPAD)
                            {
                                imageview.frame=CGRectMake(0, 0, 120, 30);
                                
                            }
                            
                            else{
                                imageview.frame=CGRectMake(0, 0, 100, 30);
                                
                            }
                            
                            self.navigationItem.titleView = imageview;
                         //   [ defaults setObject:imageData forKey:@"applogo"];
                            [defaults synchronize];
                            
                        }
                    }
                    else
                    {
                        UIImage *image = [UIImage imageNamed: @"logo"];
                        imageview = [[UIImageView alloc] initWithImage:image];
                        if (IS_IPAD)
                        {
                            imageview.frame=CGRectMake(0, 0, 100, 30);
                            
                        }
                         self.navigationItem.titleView = imageview;
                    }
                    
                }];
                
                
                
                
                NSLog(@"Notification Data %@",jsonData);
                
                if ([channelArr count]>=1)
                    
                {
                    
                    self.channelsColVw.delegate=self;
                    self.channelsColVw.dataSource=self;
                    [self.channelsColVw reloadData];
                    
                    
                }
                else{
                    [customIndicator stopAnimating];
                    [customIndicator removeFromSuperview];
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

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    if (!IS_IPAD) {
//        
//        [appdelegate hideStatusBarAction];
//    }
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//        
//              if (channelArr.count==2)
//        {
//            CGFloat hight=self.view.frame.size.height/2;
//            
//            
//            CGFloat topSpace=hight-120;
//            self.topSpaceForColVw.constant=topSpace;
//        
//            
//        }
//        
//        
//        
//        if (!IS_IPAD)
//        {
//            imageview.frame=CGRectMake(0, 0, 120, 25);
//            self.navigationItem.titleView = imageview;
//            
//        }
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        orientation=@"Lanscape";
//        NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        
//        if (channelArr.count==2)
//        {
//            CGFloat hight=self.view.frame.size.height/2;
//            CGFloat topSpace=hight-140;
//            self.topSpaceForColVw.constant=topSpace;
//            
//            UICollectionViewFlowLayout *flow =(UICollectionViewFlowLayout*) self.channelsColVw.collectionViewLayout;
//            flow.sectionInset = UIEdgeInsetsMake(0  , 0, 0, 0);
//            
//        }
//        
//        if (!IS_IPAD)
//        {
//            imageview.frame=CGRectMake(0, 0, 100, 30);
//            self.navigationItem.titleView = imageview;
//            
//        }
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        orientation=@"Portrait";
//        
//        NSLog(@"UIDeviceOrientationPortrait");
//    }
//}
-(void)viewWillAppear:(BOOL)animated
{
    if (!IS_IPAD) {
        
        [appdelegate hideStatusBarAction];
    }
    
    
    self.bannerView.adUnitID = [defaults valueForKey:@"bannerCode"];
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[DFPRequest request]];
    
    
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//        
//        
//        if (channelArr.count==2)
//        {
//            CGFloat hight=self.view.frame.size.height/2;
//            CGFloat topSpace=hight-230;
//            self.topSpaceForColVw.constant=topSpace;
//            
//            UICollectionViewFlowLayout *flow =(UICollectionViewFlowLayout*) self.channelsColVw.collectionViewLayout;
//            flow.sectionInset = UIEdgeInsetsMake(0  , 0, 0, 0);
//            
//            
//        }
//        
//        if (!IS_IPAD)
//        {
//            imageview.frame=CGRectMake(0, 0, 120, 25);
//            self.navigationItem.titleView = imageview;
//            
//        }
//        
//        orientation=@"Lanscape";
//        NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        
//        if (channelArr.count==2)
//        {
//            CGFloat hight=self.view.frame.size.height/2;
//            
//            
//            CGFloat topSpace=hight-140;
//            self.topSpaceForColVw.constant=topSpace;
//            
//            UICollectionViewFlowLayout *flow =(UICollectionViewFlowLayout*) self.channelsColVw.collectionViewLayout;
//            flow.sectionInset = UIEdgeInsetsMake(0  , 0, 0, 0);
//            
//            
//        }
//        
//        if (!IS_IPAD)
//        {
//            imageview.frame=CGRectMake(0, 0, 100, 30);
//            self.navigationItem.titleView = imageview;
//            
//        }
//        
//        orientation=@"Portrait";
//        
//        NSLog(@"UIDeviceOrientationPortrait");
//            }
    self.navigationController.navigationBarHidden=YES;

    
}
-(void)viewDidAppear:(BOOL)animated
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [customIndicator stopAnimating];
            [customIndicator removeFromSuperview];
            
        });
    });
    
}



@end
