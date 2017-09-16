//
//  GDViewAllController.m
//  SindhTV
//
//  Created by intellisense on 22/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDViewAllController.h"
#import "GDViewAllCustomCell.h"
#import "GDWebLiveController.h"

#import "TSActivityIndicatorView.h"
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)

@interface GDViewAllController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *imageview1;
    NSUserDefaults *defaults;
    UIActivityIndicatorView *indicator;
     TSActivityIndicatorView *customIndicator;
}
@end

@implementation GDViewAllController
@synthesize articlesArr,headerTitle,value;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.topSpaceForTblVw.constant=value;
    defaults=[NSUserDefaults standardUserDefaults];
    UIImage *image = [UIImage imageNamed:[defaults valueForKey:@"applogo"]];
    
    
    
    imageview1 = [[UIImageView alloc] initWithImage:image];
    self.navigationItem.titleView = imageview1;
    
    UIImage *bgimage=[UIImage imageWithData:[defaults valueForKey:@"bgImg"]];
    
    self.imgVwForBg.image=bgimage;
    
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    //UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0 , 0, 0, 0)];
   
//    UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(self.viewAllTblVw.frame.size.width/2-25, 20, 50, 30)];
//    labelView.textAlignment = NSTextAlignmentCenter;
//    labelView.text=headerTitle;
//   // [headerView addSubview:labelView];
//    self.viewAllTblVw.tableHeaderView = labelView;
    
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
    
    self.viewAllTblVw.delegate=self;
    self.viewAllTblVw.dataSource=self;
    self.viewAllTblVw.backgroundColor=[UIColor clearColor];
    [self.viewAllTblVw reloadData];
    
    NSLog(@"count is====== %lu",(unsigned long)articlesArr.count);
    // Do any additional setup after loading the view.
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger) section
{
    //section text as a label
    UILabel *lbl = [[UILabel alloc] init];
    lbl.textAlignment = NSTextAlignmentCenter;
    
    lbl.text = headerTitle;
    lbl.textColor=[UIColor whiteColor];
    lbl.font=[UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
    [lbl setBackgroundColor:[UIColor clearColor]];
    
    return lbl;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return articlesArr.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDViewAllCustomCell *cell=[tableView dequeueReusableCellWithIdentifier:@"articleCell"];
    if (cell==nil) {
        cell=[[GDViewAllCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    cell.durationLbl.text=[[articlesArr objectAtIndex:indexPath.row] valueForKey:@"duration"];
    cell.durationLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
    
    cell.durationLbl.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    
    cell.titleLbl.text=[[articlesArr objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.viewsLbl.text=[NSString stringWithFormat:@"Views %@", [[articlesArr objectAtIndex:indexPath.row] valueForKey:@"views"]];
    
     NSString *imageString=[NSString stringWithFormat:@"%@", [[articlesArr objectAtIndex:indexPath.row] valueForKey:@"thumb"]];
     NSURL *url=[NSURL URLWithString:imageString];
    
    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
        if (succeeded) {
            
            if (image==nil)
            {
                cell.articleImageVw.image=[UIImage imageNamed:@"sindhTv"];
            }
            else{
                
                cell.articleImageVw.image=image;
                
                
            }
            // save image in
        }
        else
        {
           cell.articleImageVw.image=[UIImage imageNamed:@"sindhTv"];
        }
        
    }];
    


    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//webLive
    
    GDWebLiveController *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"webLive"];
    vc.urlString=[[articlesArr objectAtIndex:indexPath.row ] valueForKey:@"webview_url"];
    [self.navigationController pushViewController:vc animated:YES];

}


- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock
{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                              [customIndicator stopAnimating];
                                                              [customIndicator removeFromSuperview];
                               
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
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//        
//        
//        self.topSpaceForTblVw.constant=32;
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//        if (!IS_IPAD) {
//            imageview1.frame=CGRectMake(0, 0, 120, 30);
//        }
//        if (IS_IPAD)
//        {
//            self.topSpaceForTblVw.constant=64;
//            
//        }
//        
//        NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        self.topSpaceForTblVw.constant=64;
//        
//        if (!IS_IPAD)
//        {
//            imageview1.frame=CGRectMake(0, 0, 100, 40);
//            
//        }
//        if (IS_IPAD)
//        {
//            self.topSpaceForTblVw.constant=64;
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
-(void)viewWillAppear:(BOOL)animated
{
//    [customIndicator stopAnimating];
//    [customIndicator removeFromSuperview];
    if (IS_IPAD)
    {
        self.topSpaceForTblVw.constant=64;
   
    }
    
   
    self.navigationController.navigationBarHidden=NO;
    
// [self restrictRotation:NO];
//    
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
//    {
//        
//        
//              if (!IS_IPAD) {
//            imageview1.frame=CGRectMake(0, 0, 120, 30);
//        }
//        
//        NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//        
//        if (!IS_IPAD)
//        {
//            imageview1.frame=CGRectMake(0, 0, 100, 40);
//            
//        }
//        
//        
//        NSLog(@"UIDeviceOrientationPortrait");
//    }


}
-(void)viewWillDisappear:(BOOL)animated
{
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"forArticles" object:self];


}
//-(void) restrictRotation:(BOOL) restriction
//{
//    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    appDelegate.restrictRotation = restriction;
//}

@end
