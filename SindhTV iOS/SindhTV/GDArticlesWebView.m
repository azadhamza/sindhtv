//
//  GDArticlesWebView.m
//  SindhTV
//
//  Created by intellisense on 23/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDArticlesWebView.h"
#import "AppDelegate.h"
#import "TSActivityIndicatorView.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)


@interface GDArticlesWebView ()<UIWebViewDelegate,GADInterstitialDelegate>
{
    UIImageView *imageview1;
    NSUserDefaults *defaults;
    NSURL *ChannelUrl;
    NSDictionary *jsonData;
    NSArray *epaperArr;
    UIActivityIndicatorView *indicator;
    TSActivityIndicatorView *customIndicator;
    NSURL *Finalurl,*urlCompare;
    bool isFirstTime;
    int c,r,d;
}
@property(nonatomic, strong) DFPInterstitial *interstitial;
@end

@implementation GDArticlesWebView
@synthesize urlString,epaperUrl,fromEpaper,about,isfromPrograms,contactusUrl;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    defaults=[NSUserDefaults standardUserDefaults];
    
    isFirstTime=YES;
    c=0;
    r=0;
    self.bannerView.adUnitID = [defaults valueForKey:@"bannerCode"];
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[DFPRequest request]];
    
    UIImage *image = [UIImage imageNamed:[defaults valueForKey:@"applogo"]];
    
    imageview1 = [[UIImageView alloc] initWithImage:image];
    imageview1.frame=CGRectMake(0, 0, 200, 40);
    imageview1.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = imageview1;
    self.ArticlesWebVw.delegate=self;
    customIndicator =
    [[TSActivityIndicatorView alloc] initWithFrame:CGRectMake(160-17, 100, 40, 40)];
    if (IS_IPAD) {
        customIndicator =
        [[TSActivityIndicatorView alloc] initWithFrame:CGRectMake(160-17, 100, 60, 60)];
        
    }
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
    if (isfromPrograms)
    {
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.topSpaceForWebVw.constant=64;
        [self loadWebviewWithUrlFromPrograms];
    }
    else
    {
    if ([about isEqualToString:@"ABOUT"])
    {
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.topSpaceForWebVw.constant=64;
    }
    
    
    if ([fromEpaper isEqualToString:@"FROMEPAPER"]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self performSelectorOnMainThread:@selector(getUrlData) withObject:nil waitUntilDone:YES];
            dispatch_async(dispatch_get_main_queue(), ^{
                //[hud hide:YES];
            });
        });
    }
    
    
    else{
        
        self.interstitial = [self createAndLoadInterstitial];
        
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
         self.ArticlesWebVw.scalesPageToFit=YES;
        
        //[self.ArticlesWebVw stringByEvaluatingJavaScriptFromString: js];
        
        
        
        // self.ArticlesWebVw.opaque = NO;
        
        [self.ArticlesWebVw loadRequest:requestObj];
    }
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goBackWebView) name:@"webViewBack" object:nil];
    
    
 }


- (DFPInterstitial *)createAndLoadInterstitial {
    DFPInterstitial *interstitial =
    [[DFPInterstitial alloc] initWithAdUnitID:[defaults valueForKey:@"interestitialsCode"]];
    interstitial.delegate = self;
    [interstitial loadRequest:[DFPRequest request]];
    return interstitial;
}
- (void)interstitialDidReceiveAd:(DFPInterstitial *)ad
{
    [_interstitial presentFromRootViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)goBackWebView
{
    
    [self.ArticlesWebVw goBack];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setBoolNoForEpaper" object:self];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



-(void)viewWillAppear:(BOOL)animated
{
    
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//        if (!IS_IPAD) {
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//            
//            
//        }
//        
//        if (!IS_IPAD) {
//            imageview1.frame=CGRectMake(0, 0, 120, 25);
//        }
//        else{
//            imageview1.frame=CGRectMake(0, 0, 120, 30);
//            
//        }
//        NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        if (!IS_IPAD) {
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//            
//            
//        }
//        
//        
//        //        if (!IS_IPAD)
//        //        {
//        imageview1.frame=CGRectMake(0, 0, 100, 30);
//        
//        //  }
//        
//        
//        NSLog(@"UIDeviceOrientationPortrait");
//    }
//    
    
}

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//        if (!IS_IPAD) {
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//            
//            
//        }
//        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//        
//        
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        
//        if (!IS_IPAD)
//        {
//            imageview1.frame=CGRectMake(0, 0, 120, 25);
//            if ([about isEqualToString:@"ABOUT"])
//            {
//                self.topSpaceForWebVw.constant=40;
//            }
//        }
//        else{
//            if ([about isEqualToString:@"ABOUT"])
//            {
//                self.topSpaceForWebVw.constant=64;
//            }
//        }
//        
//        NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        if (!IS_IPAD) {
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//            
//            
//        }
//        
//        if ([about isEqualToString:@"ABOUT"])
//        {
//            self.topSpaceForWebVw.constant=64;
//        }
//        if (!IS_IPAD)
//        {
//            imageview1.frame=CGRectMake(0, 0, 100, 30);
//            
//        }
//        
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        
//        NSLog(@"UIDeviceOrientationPortrait");
//    }
//}
-(void)viewWillDisappear:(BOOL)animated
{
    if ([about isEqualToString:@"ABOUT"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"forArticles" object:self];
    }
    
}

-(void)getUrlData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString * post=[NSString stringWithFormat:@""];
        
        
        
        ChannelUrl=[[NSURL alloc] initWithString:epaperUrl];
        
        
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
        
        //        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        //        NSLog(@"Response ==> %@", responseData);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (urlData)
            {
                jsonData=[[NSDictionary alloc] init];
                jsonData = [NSJSONSerialization
                            JSONObjectWithData:urlData
                            options:NSJSONReadingMutableContainers
                            error:nil];
                
                epaperArr=[jsonData objectForKey:@"items"];
                
                
                
                
                NSLog(@"Notification Data %@",jsonData);
                
                if ([epaperArr count]>=1)
                    
                {
                    urlString=[[epaperArr objectAtIndex:0] valueForKey:@"webview_url"];
                    
                    if ([urlString isEqualToString:@""])
                    {
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Nothing to show here" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                        [customIndicator stopAnimating];
                        
                        [customIndicator removeFromSuperview];
                    }
                    else
                    {
                        
                        
                        Finalurl = [NSURL URLWithString:urlString];
                        
                        NSURLRequest *requestObj = [NSURLRequest requestWithURL:Finalurl];
                        
                        
                        
                        self.ArticlesWebVw.delegate=self;
                        self.ArticlesWebVw.scalesPageToFit=YES;
                        
                        self.ArticlesWebVw.opaque = NO;
                        
                        [self.ArticlesWebVw loadRequest:requestObj];
                    }
                }
            }
        });
    });
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    
    
    
    if (webView.isLoading) {
        
        NSLog(@"isLoading--------->%i",r);
        
    }
    else{
        
        c++;
        
        NSLog(@"count=======================>>>>>>>>>>>>>>>> %i",c);
        [customIndicator stopAnimating];
        [customIndicator removeFromSuperview];
    }
    // self.ArticlesWebVw.scalesPageToFit=YES;
    
    _ArticlesWebVw.frame=self.view.bounds;
    
    self.ArticlesWebVw.autoresizesSubviews = YES;
    self.ArticlesWebVw.contentMode = UIViewContentModeScaleAspectFit;
    
    
    //
    if (c>1&&[fromEpaper isEqualToString:@"FROMEPAPER"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WebVw" object:self];
        
        c=0;
        
    }
    //    NSString *jsCommand = [NSString stringWithFormat:@"document.body.style.zoom = 2.5;"];
    //    [self.ArticlesWebVw stringByEvaluatingJavaScriptFromString:jsCommand];
    
    
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    
    urlCompare=request.URL;
    
    
    
    NSLog(@"countURl=======================>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> %@",urlCompare);
    
    return YES;
}
-(void)loadWebviewWithUrlFromPrograms
{

    NSURL *contactUrl=[NSURL URLWithString:contactusUrl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:contactUrl];
    
    
    
    self.ArticlesWebVw.delegate=self;
    self.ArticlesWebVw.scalesPageToFit=YES;
    
    self.ArticlesWebVw.opaque = NO;
    
    [self.ArticlesWebVw loadRequest:requestObj];
}
@end
