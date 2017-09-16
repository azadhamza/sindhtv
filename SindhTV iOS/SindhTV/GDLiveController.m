//
//  GDLiveController.m
//  SindhTV
//
//  Created by intellisense on 14/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDLiveController.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#import "TSActivityIndicatorView.h"
@interface GDLiveController ()
{
    NSMutableDictionary *jsonData;
    NSURL *getListUrl;
    NSMutableArray *titleNamesArr;
    NSNumber *value;
    NSUserDefaults *defaults;
    TSActivityIndicatorView *customIndicator;
    NSURL *videoUrl,*audioUrl;

}
@end

@implementation GDLiveController
@synthesize topHeight,urlString;
- (void)viewDidLoad {
    
     [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];
    
    
   self.bannerView.adUnitID = [defaults valueForKey:@"bannerCode"];
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[DFPRequest request]];

    self.liveLblButton.layer.cornerRadius=4;
    self.liveLblButton.layer.masksToBounds=YES;
    self.liveLblButton.enabled=NO;
    
    
    UIImage *bgImg=[UIImage imageWithData:[defaults valueForKey:@"bgImg"]];
    self.bgImageForView.image=bgImg;
    
    
    if (IS_IPAD) {
        self.heightForWatchLiveBtn.constant=200;
        self.widthForWatchLiveBtn.constant=200;
//        self.widthForLbl.constant=150;
//        self.watchLiveLbl.font=[UIFont fontWithName:@"Arial-BoldMT" size:23];
//        self.topSpaceForListenLive.constant=30;
        self.widthForListenLive.constant=200;
        self.heightForListenLive.constant=200;
       // self.listenLiveBtn.font=[UIFont fontWithName:@"Arial-BoldMT" size:23];
    }
    
    [self getData];
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

- (IBAction)watchLiveBtnAction:(UIButton *)sender
{
    
    
    
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft )
    {
        value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        
        
        NSLog(@"Lanscapse");
    }
    
    else if([[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
    {
        value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
        
    }
    else if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
    {
        value = [NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown];
        NSLog(@"UIDeviceOrientationPortrait");
    }
    else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait)
    {
        value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    }
    
    

    
    GDWebLiveController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"webLive"];
    vc.urlString=(NSString *)videoUrl;
    [self.navigationController pushViewController:vc animated:YES];


    
  
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
  self.navigationController.navigationBarHidden=NO;
}
-(void)viewWillAppear:(BOOL)animated
{
     self.navigationController.navigationBarHidden=NO;
    
   // [self restrictRotation:NO];

       // dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//    if (value)
//    {
//      
//    
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//    
//    }
         //});
    
}
//-(void) restrictRotation:(BOOL) restriction
//{
//    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.restrictRotation = restriction;
//}

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
                    
                    //isEqualToString:@"No Record Found"]
                    NSLog(@"%lu",(unsigned long)titleNamesArr.count);
                    
                    if (titleNamesArr )
                    {
                        videoUrl=[[titleNamesArr valueForKey:@"webview_url"]objectAtIndex:0];
                        audioUrl=[[titleNamesArr valueForKey:@"audio_url"]objectAtIndex:0];

                        
                        
                        
                        
                        
                    }
                    else{
                        
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"No Menu in This Channel " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                    
                }
                else{
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[jsonData objectForKey:@"items"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    // [self.navigationController popViewControllerAnimated:YES];
                }
                
                
            }
        });
        
        
    });
    


}
- (IBAction)listenLiveBtnAction:(id)sender {
    
    if ([[[titleNamesArr valueForKey:@"audio_url"]objectAtIndex:0] length]==0) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Audio Link Not Available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
    GDWebLiveController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"webLive"];
    vc.urlString=(NSString *)audioUrl;
    [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
