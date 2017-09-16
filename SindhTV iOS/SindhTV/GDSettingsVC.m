//
//  GDSettingsVC.m
//  SindhTV
//
//  Created by intellisense on 12/05/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDSettingsVC.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
@interface GDSettingsVC ()
{
    
    NSUserDefaults *defaults;
    UIImageView *imageview1;
    AppDelegate *appdelegate;
}

@end

@implementation GDSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults=[NSUserDefaults standardUserDefaults];
    
    appdelegate=[[UIApplication sharedApplication] delegate];
    
    NSObject *value=[defaults valueForKey:@"swithAction"];
    
    UIImage *image = [UIImage imageNamed:[defaults valueForKey:@"applogo"]];
    
    imageview1 = [[UIImageView alloc] initWithImage:image];
    
    imageview1.frame=CGRectMake(0, 0, 200, 40);
    imageview1.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.titleView = imageview1;
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    
    if ([[defaults valueForKey:@"swithAction"] isEqualToString:@"clicked"]|| value==nil)
        
    {
        [self.notificationSwitch setOn:YES];
    }
    else if ([[defaults valueForKey:@"swithAction"] isEqualToString:@"unclicked"])
    {
        
        [self.notificationSwitch setOn:NO];
    }
    
    
    UIImage *bgimage=[UIImage imageWithData:[defaults valueForKey:@"bgImg"]];
    
    self.imgVwForBg.image=bgimage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"forArticles" object:self];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)notificationSwitchAction:(UISwitch *)sender {
    
    NSString *post;
    NSURL *url;
    if ([self.notificationSwitch isOn])
    {
        post=[NSString stringWithFormat:@""];
        url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://poovee.net/webservices/editgcm/2?acmid=%@&status=%d",[defaults valueForKey:@"deviceToken"],1]];
        [defaults setValue:@"clicked" forKey:@"swithAction"];
    }
    else{
        
        post=[NSString stringWithFormat:@""];
        url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://poovee.net/webservices/editgcm/2?acmid=%@&status=%d",[defaults valueForKey:@"deviceToken"],0]];
        [defaults setValue:@"unclicked" forKey:@"swithAction"];
    }
    [defaults synchronize];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSLog(@"Response code: %ld", (long)[response statusCode]);
    NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSLog(@"Response ==> %@", responseData);
    //        dispatch_async(dispatch_get_main_queue(), ^{
    
    NSDictionary *jsonData = [NSJSONSerialization
                              JSONObjectWithData:urlData
                              options:NSJSONReadingMutableContainers
                              error:nil];
    NSLog(@"responce===========%@",jsonData);
    NSLog(@"responceDefaults  ===========%@",[defaults valueForKey:@"swithAction"]);
}
-(void)viewWillAppear:(BOOL)animated
{
    NSObject *value=[defaults valueForKey:@"swithAction"];
    
    if (!IS_IPAD) {
    
    [appdelegate hideStatusBarAction];
    }
    
    
    if ([[defaults valueForKey:@"swithAction"] isEqualToString:@"clicked"]|| value==nil)
        
    {
        [self.notificationSwitch setOn:YES];
    }
    else if ([[defaults valueForKey:@"swithAction"] isEqualToString:@"unclicked"])
    {
        
        [self.notificationSwitch setOn:NO];
        
        
//        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//        {
//            
//            
//            if (!IS_IPAD)
//            {
//                imageview1.frame=CGRectMake(0, 0, 120, 25);
//            }
//            else
//            {
//                imageview1.frame=CGRectMake(0, 0, 120, 30);
//            }
//            NSLog(@"Lanscapse");
//        }
//        if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//        {
//            //        if (!IS_IPAD)
//            //        {
//            imageview1.frame=CGRectMake(0, 0, 100, 30);
//            
//            //  }
//            NSLog(@"UIDeviceOrientationPortrait");
//        }
    }
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
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        if (!IS_IPAD)
//        {
//            imageview1.frame=CGRectMake(0, 0, 120, 25);
//        }
//        
//        NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        
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


@end
