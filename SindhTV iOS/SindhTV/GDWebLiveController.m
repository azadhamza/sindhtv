//
//  GDWebLiveController.m
//  SindhTV
//
//  Created by intellisense on 19/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDWebLiveController.h"
#import "GDLiveController.h"
#import "TSActivityIndicatorView.h"
@interface GDWebLiveController ()<UIWebViewDelegate,GADInterstitialDelegate>
{
UIActivityIndicatorView *indicator;
       TSActivityIndicatorView *customIndicator;
    NSUserDefaults *defaults;
}
- (IBAction)closeAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIWebView *liveWebView;
@property(nonatomic, strong) DFPInterstitial *interstitial;
@end

@implementation GDWebLiveController
@synthesize urlString;
- (void)viewDidLoad {
    [super viewDidLoad];
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//
    
    defaults=[NSUserDefaults standardUserDefaults];
self.navigationController.navigationBarHidden=YES;
   self.interstitial = [self createAndLoadInterstitial];
    
    
 self.navigationController.navigationBar.translucent = YES;
    customIndicator =
    [[TSActivityIndicatorView alloc] initWithFrame:CGRectMake(160-17, 100, 40, 40)];
    customIndicator.frames = @[@"activity-indicator-1",
                               @"activity-indicator-2",
                               @"activity-indicator-3",
                               @"activity-indicator-4",
                               @"activity-indicator-5",
                               @"activity-indicator-6"];
    
    self.liveWebView.delegate=self;
   
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self selector:@selector(orientationChanged:)
//     name:UIDeviceOrientationDidChangeNotification
//     object:[UIDevice currentDevice]];

    
    NSURL *url = [NSURL URLWithString:urlString];
    
       NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    
    self.liveWebView.opaque = NO;
    
    
    
    [self.liveWebView loadRequest:requestObj];

    
   
}

- (DFPInterstitial *)createAndLoadInterstitial {
    DFPInterstitial *interstitial =
    [[DFPInterstitial alloc] initWithAdUnitID:[defaults valueForKey:@"interestitialsCode"]];
    interstitial.delegate = self;
    [interstitial loadRequest:[DFPRequest request]];
    self.navigationController.navigationBarHidden=YES;
    return interstitial;
}
- (void)interstitialDidReceiveAd:(DFPInterstitial *)ad
{
    self.navigationController.navigationBarHidden=YES;
    [_interstitial presentFromRootViewController:self];
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

- (IBAction)closeAction:(UIButton *)sender {
    
    self.navigationController.navigationBarHidden=NO;
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
   
    customIndicator.duration = 0.5f;
    customIndicator.hidesWhenStopped = YES;
    customIndicator.center=self.view.center;
    [self.view addSubview:customIndicator];
    
    [customIndicator startAnimating];

    

}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [customIndicator stopAnimating];
    [customIndicator removeFromSuperview];
    self.navigationController.navigationBarHidden=YES;
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
  //  NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    //[[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//[self restrictRotation:YES];
    
}

//-(void) restrictRotation:(BOOL) restriction
//{
//    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.restrictRotation = restriction;
//}
//- (void) orientationChanged:(NSNotification *)note
//{
//    UIDevice * device = note.object;
//    switch(device.orientation)
//    {
//        case UIDeviceOrientationPortrait:
//            /* start special animation */
//            
//            break;
//            
//        case UIDeviceOrientationLandscapeLeft:
//            
//            
//            break;
//        case UIDeviceOrientationLandscapeRight:
//            
//            
//            break;
//            
//        default:
//            break;
//    };
//}
//-(NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskLandscape;
//}
//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//}
//
//-(BOOL)shouldAutorotate
//{
//    return NO;
//}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=NO;
}
@end
