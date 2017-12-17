//
//  AppDelegate.m
//  SindhTV
//
//  Created by intellisense on 11/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIImage *splashImage = [UIImage imageNamed:@"bgforLive"];
    UIImageView *splashImageView = [[UIImageView alloc] initWithImage:splashImage];
    splashImageView.frame=[[UIScreen mainScreen] bounds];
    UILabel *lbl=[[UILabel alloc]initWithFrame:CGRectMake(0 , splashImageView.frame.size.height-50, splashImageView.frame.size.width, 35)];
    
    lbl.text=@"Designed by Hanif Iqbal Manjothi";
    lbl.textColor=[UIColor whiteColor];
    lbl.textAlignment=NSTextAlignmentCenter;
    [splashImageView addSubview:lbl];
    
    [self.window.rootViewController.view addSubview:splashImageView];
    [self.window.rootViewController.view bringSubviewToFront:splashImageView];
    [UIView animateWithDuration:1.5f
                          delay:2.0f
                        options:UIViewAnimationOptionTransitionNone
                     animations:^{
                         splashImageView.alpha = .0f;
//                         CGFloat x = -60.0f;
//                         CGFloat y = -120.0f;
                         CGFloat x = 0.0f;
                         CGFloat y = 0.0f;
                         splashImageView.frame = CGRectMake(x,
                                                            y,
                                                            splashImageView.frame.size.width-2*x,
                                                            splashImageView.frame.size.height-2*y);
                     } completion:^(BOOL finished){
                         if (finished) {
   
                             [splashImageView removeFromSuperview];
                         }
                     }];
    
    
    
    
    
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setInteger:2 forKey:@"appID" ];
    [defaults synchronize];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeNewsstandContentAvailability| UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    [application registerForRemoteNotifications];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSLog(@"My token is: %@", deviceToken);
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", newToken);
    
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    [defaults setValue:newToken  forKey:@"deviceToken" ];
    [defaults synchronize];
    
    //    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Token" message:token delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    
    NSString *post=[NSString stringWithFormat:@""];
    NSURL *url=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://poovee.net/webservices/appgcm/2?acmid=%@",newToken]];
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
}

//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
//{
//    if(self.restrictRotation)
//        return UIInterfaceOrientationMaskLandscape;
//    else
//        return UIInterfaceOrientationMaskAll;
//}
-(void)hideStatusBarAction
{
   
    
 
//
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//          [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//        
//           NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    }
}
@end
