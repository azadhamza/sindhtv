//
//  ViewController.m
//  SindhTV
//
//  Created by intellisense on 11/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "ViewController.h"
#import "GDCollectionViewCell.h"

#import "GDLiveViewController.h"
#import "GDLiveController.h"

#import "GDChannelsViewController.h"
#import "GDArticlesWebView.h"
#import "GDUserUploadsController.h"
#import "GDSettingsVC.h"
#import "GDChannelVideos.h"
#import "GDNewsArticlesVC.h"

@import GoogleMobileAds;

#define MAIN_VIEW_TAG 1
#define TITLE_LABLE_TAG 2
#define IMAGE_VIEW_TAG 3
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray * titleArr;
    UIView *viewForBg;
    BOOL firstTime,clicked;
    NSIndexPath *indPath,*reloadPath;
    GDCollectionViewCell *cellForDeselect;
    NSDictionary *jsonData;
    NSURL *getListUrl;
    NSMutableArray *titleNamesArr,*ArrayForColVw;
    CGFloat xAxis, yAxis,height, width;
    GDCollectionViewCell *cell1;
    NSUserDefaults *defaults;
    UIActivityIndicatorView *indicator;
    TSActivityIndicatorView *customIndicator;
    int count,countForArrElements;
    UIImageView *imageview1;
    bool isClicked,isCLickedForArticles,isClickedForVideos,isClickedForWebVw,forArticlewebVwRotation;
    NSMutableArray* indexArray ;
    NSInteger indexInteger;
    AppDelegate *appdelegate;
    GDNewsArticlesVC *lifelineViewController1;
}

@end

@implementation ViewController
@synthesize channelID,topMarginForColVw,value;

- (void)viewDidLoad {
    [super viewDidLoad];
    appdelegate=[[UIApplication sharedApplication]delegate];
    isClicked=NO;
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
    
    defaults=[NSUserDefaults standardUserDefaults];
    UIImage *bgimage=[UIImage imageWithData:[defaults valueForKey:@"bgImg"]];
    
    self.imgVwForBg.image=bgimage;
    firstTime=YES;
    NSLog(@"channelid=================> %@",channelID);
    _menuTable.hidden=YES;
    
    self.topMarginForColVw.constant=value ;
    self.topSpaceForTable.constant=value;
    [self.collectionVw setNeedsDisplay];
    [self.menuTable setNeedsDisplay ];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -7;
    
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,self.menuBtn, nil] animated:YES];
    
    //  UIImage *image = [UIImage imageWithData:[defaults valueForKey:@"applogo"]];
    
    imageview1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[defaults valueForKey:@"applogo"]]];
    
    imageview1.frame=CGRectMake(0, 0, 200, 40);
    imageview1.backgroundColor=[UIColor clearColor];
    
    self.navigationItem.titleView.backgroundColor=[UIColor clearColor];
    
    imageview1.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.titleView = imageview1;
    
    
    
    
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:(75/255.0) blue:(142/255.0) alpha:1.0]];
    
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
    statusBarView.backgroundColor = [UIColor darkGrayColor];
    [self.navigationController.navigationBar addSubview:statusBarView];
    
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 25, 25)];
    
    [button setImage:[UIImage imageNamed:@"backnew"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor=[UIColor whiteColor];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 20, 20)];
    
    [refreshButton setImage:[UIImage imageNamed:@"reload"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(refreshMenu) forControlEvents:UIControlEventTouchUpInside];
    button.tintColor=[UIColor whiteColor];
    UIBarButtonItem *buttonItem2 = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
    
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:buttonItem,buttonItem2, nil];
    
    
    count=1;
    
    countForArrElements=0;
    
    
    [_menuTable setBackgroundColor:[self colorWithHexString:[defaults valueForKey:@"sideMenuBg"]]];
    
    [self.collectionVw setBackgroundColor:[self colorWithHexString:[defaults valueForKey:@"colVwBgClr"]]];//colVwBgClr
    
    forArticlewebVwRotation=NO;
    
    self.menuTable.frame=CGRectMake(-width, -yAxis, width, height);
    self.menuTable.dataSource =self;
    self.menuTable.delegate=self;
    
    [self getDetails];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuOpen) name:@"MenuOpen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeMenu) name:@"MenuClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RotateView) name:@"forArticles" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBoolValue) name:@"setBoolValue" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBoolValueNo) name:@"setBoolValueNo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBoolForArticles) name:@"setForArticles" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBoolForArticlesNo) name:@"setBoolForArticlesNo" object:nil];
    //setForVideos  setBoolForVideosNo
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBoolValueForvideos) name:@"setForVideos" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBoolValueNoForvideos) name:@"setBoolForVideosNo" object:nil];
    //WebVw
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBoolValueForWebView) name:@"WebVw" object:nil];
    //setBoolNoForEpaper
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setBoolValueNoForWebView) name:@"setBoolNoForEpaper" object:nil];
    //reloadArticlesView
    
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    
}
-(void)swipeleft{
    if (!IS_IPAD) {
        
        [appdelegate hideStatusBarAction];
    }
    NSInteger myInt=indexInteger+1;
    if (myInt> ArrayForColVw.count-1) {
        myInt=4;
    }
    
    else{
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setDuration:0.50];
        [animation setTimingFunction:
         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.mainVw.layer addAnimation:animation forKey:kCATransition];
        
        GDCollectionViewCell *clearCell=[[GDCollectionViewCell alloc] init];
        [clearCell setCollectionViewDataSourceDelegate:cellForDeselect indexPath:indPath];
        
        NSIndexPath *indexpath2=[NSIndexPath indexPathForRow:myInt inSection:0];
        [self.collectionVw selectItemAtIndexPath:indexpath2 animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self collectionView:self.collectionVw didSelectItemAtIndexPath:indexpath2];
        
    }
}
-(void)swiperight
{
    if (!IS_IPAD) {
        
        [appdelegate hideStatusBarAction];
    }
    NSInteger myInt=indexInteger-1;
    if (myInt < 0) {
        myInt=0;
    }
    else{
        
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromLeft];
        [animation setDuration:0.50];
        [animation setTimingFunction:
         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.mainVw.layer addAnimation:animation forKey:kCATransition];
        
        
        GDCollectionViewCell *clearCell=[[GDCollectionViewCell alloc] init];
        [clearCell setCollectionViewDataSourceDelegate:cellForDeselect indexPath:indPath];
        NSIndexPath *indexpath2=[NSIndexPath indexPathForRow:myInt inSection:0];
        [self.collectionVw selectItemAtIndexPath:indexpath2 animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self collectionView:self.collectionVw didSelectItemAtIndexPath:indexpath2];
    }
}
// NotiFication Methods Start From Here




-(void)setBoolValueForWebView
{
    isClickedForWebVw=YES;
    
    
}
-(void)setBoolValueNoForWebView
{
    isClickedForWebVw=NO;
}

-(void)setBoolValueNo
{
    isClicked=NO;
}
-(void)setBoolValueForvideos
{
    isClickedForVideos=YES;
}

-(void)setBoolValueNoForvideos
{
    isClickedForVideos=NO;
}
-(void)setBoolForArticlesNo
{
    isCLickedForArticles=NO;
}
-(void)setBoolForArticles
{
    isCLickedForArticles=YES;
}
-(void)setBoolValue
{
    isClicked=YES;
}

-(void)menuOpen
{
    [viewForBg removeFromSuperview];
    viewForBg=[[UIView alloc] initWithFrame:CGRectMake(180,0,self.view.frame.size.width,self.view.frame.size.height)];
    viewForBg.backgroundColor=[UIColor clearColor] ;
    UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenuView)];
    [viewForBg addGestureRecognizer:gesture];
    viewForBg.userInteractionEnabled=YES;
    [self.view addSubview:viewForBg];
    count=0;
}

-(void)closeMenuView
{
    [self.menuTable setHidden:YES ];
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.50];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_menuTable.layer addAnimation:animation forKey:kCATransition];
    
    [viewForBg removeFromSuperview];
    count=1;
}
-(void)closeMenu
{
    [viewForBg removeFromSuperview];
}


// End Methods/////////////////////////////////////////////////////////////////



-(void)refreshMenu
{
    
    if (isCLickedForArticles==YES)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadView" object:self];
        // isCLickedForArticles=NO;
    }
    else if (isClickedForVideos==YES)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadVideos" object:self];
        //isClickedForVideos=NO;
        
    }
    else {
        
        if ([[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:reloadPath.row] isEqualToNumber:[NSNumber numberWithInt:1]])
            
        {
            firstTime=NO;
            
            
            GDLiveController *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"watchLive"];
            
            lifelineViewController.urlString=[NSString stringWithFormat:@"http://poovee.net/webservices/packagelist/%@/%@/?appid=%li",[defaults valueForKey:@"channelID"],[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:reloadPath.row],(long)[defaults integerForKey:@"appID"]];
            lifelineViewController.view.frame =self.mainVw.bounds;
            
            [lifelineViewController willMoveToParentViewController:self];
            [self.mainVw addSubview:lifelineViewController.view];
            [self addChildViewController:lifelineViewController];
            [lifelineViewController didMoveToParentViewController:self];
            indPath=reloadPath;
        }
        
        else if ([[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:reloadPath.row] isEqualToNumber:[NSNumber numberWithInt:3]])
            
        {
            firstTime=NO;
            GDLiveViewController *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"live"];
            lifelineViewController.fromHeadlines=@"headLines";
            
            lifelineViewController.urlString=[NSString stringWithFormat:@"http://poovee.net/webservices/packagelist/%@/%@/?appid=%li",[defaults valueForKey:@"channelID"],[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:reloadPath.row],(long)[defaults integerForKey:@"appID"]];
            
            lifelineViewController.view.frame =self.mainVw.bounds;
            [lifelineViewController willMoveToParentViewController:self];
            [self.mainVw addSubview:lifelineViewController.view];
            [self addChildViewController:lifelineViewController];
            [lifelineViewController didMoveToParentViewController:self];
            
        }
        
        else if ([[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:reloadPath.row] isEqualToNumber:[NSNumber numberWithInt:7]])
            
        {
            
            firstTime=NO;
            GDNewsArticlesVC *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"articlesTbl"];
            
            lifelineViewController.fromHeadlines=@"FROMARTICLES";
            lifelineViewController.urlString=[NSString stringWithFormat:@"http://poovee.net/webservices/packagelist/%@/%@/?appid=%li",[defaults valueForKey:@"channelID"],[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:reloadPath.row],(long)[defaults integerForKey:@"appID"]];
            
            lifelineViewController.view.frame =self.mainVw.bounds;
            [lifelineViewController willMoveToParentViewController:self];
            [self.mainVw addSubview:lifelineViewController.view];
            [self addChildViewController:lifelineViewController];
            [lifelineViewController didMoveToParentViewController:self];
        }
        
        //GDMyVideos
        else if ([[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:reloadPath.row] isEqualToNumber:[NSNumber numberWithInt:10]])
            
        {
            firstTime=NO;
            GDChannelVideos *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"GDMyVideos"];
            
            lifelineViewController.urlString=[NSString stringWithFormat:@"http://poovee.net/webservices/packagelist/%@/%@/?appid=%li",[defaults valueForKey:@"channelID"],[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:reloadPath.row],(long)[defaults integerForKey:@"appID"]];
            
            lifelineViewController.view.frame =self.mainVw.bounds;
            [lifelineViewController willMoveToParentViewController:self];
            [self.mainVw addSubview:lifelineViewController.view];
            [self addChildViewController:lifelineViewController];
            [lifelineViewController didMoveToParentViewController:self];
            
        }
        
        
        else if ([[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:reloadPath.row] isEqualToNumber:[NSNumber numberWithInt:11]])
            
        {
            firstTime=NO;
            GDArticlesWebView *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"articlesWebVw"];
            
            
            lifelineViewController.epaperUrl=[NSString stringWithFormat:@"http://poovee.net/webservices/packagelist/%@/%@/?appid=%li",[defaults valueForKey:@"channelID"],[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:reloadPath.row],(long)[defaults integerForKey:@"appID"]];
            
            
            
            lifelineViewController.fromEpaper=@"FROMEPAPER";
            lifelineViewController.view.frame =self.mainVw.bounds;
            [lifelineViewController willMoveToParentViewController:self];
            [self.mainVw addSubview:lifelineViewController.view];
            [self addChildViewController:lifelineViewController];
            [lifelineViewController didMoveToParentViewController:self];
            
        }
        else{
            
            // [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:self];
        }
        
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    ArrayForColVw=[[NSMutableArray alloc]init];
    
    for (int j=0; j<titleNamesArr.count; j++) {
        if ([[[titleNamesArr objectAtIndex:j] valueForKey:@"is_listmenu"]  isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            [ArrayForColVw addObject:[titleNamesArr objectAtIndex:j]];
        }
        else
        {
            countForArrElements++;
        }
    }
    
    
    return ArrayForColVw.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GDCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    cell.cellBtn.enabled=NO;
    cell.titleLbl.text=[[ArrayForColVw valueForKey:@"menu_name" ] objectAtIndex:indexPath.row];
    [cell.titleLbl setTextColor:[self colorWithHexString:[defaults valueForKey:@"colVwTextClr"]]];
    cell.titleLbl.textAlignment=NSTextAlignmentCenter;
    
    
    cell.separatorImage.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwSepearator"]];
    
    
    
    indPath=indexPath;
    if (cell.selected)
    {
        cell.imgClr.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwUnderLineClr"]];
        
        cell.contentView.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwSelectionClr"]];
    }
    else{
        cell.imgClr.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwBgClr"]];
        cell.contentView.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwBgClr"]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (!IS_IPAD) {
        
        [appdelegate hideStatusBarAction];
    }
    
    defaults = [NSUserDefaults standardUserDefaults];
    isCLickedForArticles=NO;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setBoolNoForEpaper" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolValueNo" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolForVideosNo" object:self];
    cell1=(GDCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cellForDeselect=(GDCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell1.contentView.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwSelectionClr"]];
    
    cell1.imgClr.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwUnderLineClr"]];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        
        NSLog(@"ArrayForColVw %@",ArrayForColVw);
        if ([[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:1]])
            
        {
            firstTime=NO;
            
            
            GDLiveController *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"watchLive"];
            
            lifelineViewController.urlString=[NSString stringWithFormat:@"http://poovee.net/webservices/packagelist/%@/%@/?appid=%li",[defaults valueForKey:@"channelID"],[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:indexPath.row],(long)[defaults integerForKey:@"appID"]];
            lifelineViewController.view.frame =self.mainVw.bounds;
            
            [lifelineViewController willMoveToParentViewController:self];
            [self.mainVw addSubview:lifelineViewController.view];
            [self addChildViewController:lifelineViewController];
            [lifelineViewController didMoveToParentViewController:self];
            indPath=indexPath;
            reloadPath=indexPath;
            
            indexInteger=indexPath.row;
        }
        
        else if ([[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:3]])
            
        {
            firstTime=NO;
            GDLiveViewController *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"live"];
            lifelineViewController.fromHeadlines=@"headLines";
            
            lifelineViewController.urlString=[NSString stringWithFormat:@"http://poovee.net/webservices/packagelist/%@/%@/?appid=%li",[defaults valueForKey:@"channelID"],[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:indexPath.row],(long)[defaults integerForKey:@"appID"]];
            
            lifelineViewController.view.frame =self.mainVw.bounds;
            [lifelineViewController willMoveToParentViewController:self];
            [self.mainVw addSubview:lifelineViewController.view];
            [self addChildViewController:lifelineViewController];
            [lifelineViewController didMoveToParentViewController:self];
            
            reloadPath=indexPath;
            indexInteger=indexPath.row;
        }
        
        else if ([[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:7]])
            
        {
            
            firstTime=NO;
            GDNewsArticlesVC *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"articlesTbl"];
            
            lifelineViewController.fromHeadlines=@"FROMARTICLES";
            lifelineViewController.urlString=[NSString stringWithFormat:@"http://poovee.net/webservices/packagelist/%@/%@/?appid=%li",[defaults valueForKey:@"channelID"],[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:indexPath.row],(long)[defaults integerForKey:@"appID"]];
            
            lifelineViewController.view.frame =self.mainVw.bounds;
            [lifelineViewController willMoveToParentViewController:self];
            [self.mainVw addSubview:lifelineViewController.view];
            [self addChildViewController:lifelineViewController];
            [lifelineViewController didMoveToParentViewController:self];
            reloadPath=indexPath;
            indexInteger=indexPath.row;
            
            
        }
        
        //GDVideos
        else if ([[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:10]])
            
        {
            firstTime=NO;
            GDChannelVideos *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"GDMyVideos"];
            
            lifelineViewController.urlString=[NSString stringWithFormat:@"http://poovee.net/webservices/packagelist/%@/%@/?appid=%li",[defaults valueForKey:@"channelID"],[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:indexPath.row],(long)[defaults integerForKey:@"appID"]];
            
            lifelineViewController.view.frame =self.mainVw.bounds;
            [lifelineViewController willMoveToParentViewController:self];
            [self.mainVw addSubview:lifelineViewController.view];
            [self addChildViewController:lifelineViewController];
            [lifelineViewController didMoveToParentViewController:self];
            reloadPath=indexPath;
            indexInteger=indexPath.row;
        }
        
        
        else if ([[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:11]])
            
        {
            firstTime=NO;
            GDArticlesWebView *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"articlesWebVw"];
            
            
            lifelineViewController.epaperUrl=[NSString stringWithFormat:@"http://poovee.net/webservices/packagelist/%@/%@/?appid=%li",[defaults valueForKey:@"channelID"],[[ArrayForColVw valueForKey:@"menu_id"] objectAtIndex:indexPath.row],(long)[defaults integerForKey:@"appID"]];
            
            
            
            lifelineViewController.fromEpaper=@"FROMEPAPER";
            lifelineViewController.view.frame =self.mainVw.bounds;
            [lifelineViewController willMoveToParentViewController:self];
            [self.mainVw addSubview:lifelineViewController.view];
            [self addChildViewController:lifelineViewController];
            [lifelineViewController didMoveToParentViewController:self];
            reloadPath=indexPath;
            indexInteger=indexPath.row;
        }
    });
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell1=(GDCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell1.imgClr.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwBgClr"]];
    cell1.contentView.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwBgClr"]];
    
}



- (IBAction)menuBtnAction:(id)sender {
    
    clicked=YES;
    
    
    if (count==0) {
        
        _menuTable.hidden=YES;
        
        CATransition *animation = [CATransition animation];
        [animation setDelegate:self];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromRight];
        [animation setDuration:0.50];
        [animation setTimingFunction:
         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [_menuTable.layer addAnimation:animation forKey:kCATransition];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuClose" object:self];
        count =1;
    }
    else if (count==1){
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.menuTable.frame = CGRectMake(0, 0, self.view.frame.size.width, 0 );
            
            
        } completion:^(BOOL finished) {
            
            
            NSLog(@"Finished1");
        }];
        
        //        CATransition *animation = [CATransition animation];
        //        [animation setDelegate:self];
        //        [animation setType:kCATransitionPush];
        //        [animation setSubtype:kCATransitionFromLeft];
        //        [animation setDuration:0.50];
        //        [animation setTimingFunction:
        //         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        //        [_menuTable.layer addAnimation:animation forKey:kCATransition];
        [_menuTable setHidden:NO];
        count=0;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuOpen" object:self];
        
    }
}



//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation duration:(NSTimeInterval)duration {
//
//    if (UIInterfaceOrientationIsPortrait(orientation)) {
//
//        self.topMarginForColVw.constant=64;
//        self.topSpaceForTable.constant=64;
//
//           } else {
//
//        self.topMarginForColVw.constant=32;
//        self.topSpaceForTable.constant=32;
//            }
//
//}
-(void)viewWillAppear:(BOOL)animated
{
    if (!IS_IPAD) {
        
        [appdelegate hideStatusBarAction];
    }
    
    if (firstTime)
    {
        
        NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.collectionVw selectItemAtIndexPath:indexPathForFirstRow animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        [self collectionView:self.collectionVw didSelectItemAtIndexPath:indexPathForFirstRow];
        UICollectionViewCell* cell = [self.collectionVw cellForItemAtIndexPath:indexPathForFirstRow];
        cell.contentView.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwSelectionClr"]];
        
    }
    
    
    //
    //    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
    //    {
    //
    //
    //
    //        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
    //        statusBarView.backgroundColor = [UIColor darkGrayColor];
    //        [self.navigationController.navigationBar addSubview:statusBarView];
    //
    //        //        if (forArticlewebVwRotation==YES) {
    //        //            self.topMarginForColVw.constant=64;
    //        //            self.topSpaceForTable.constant=64;
    //        //            forArticlewebVwRotation=NO;
    //        //
    //        //        }
    //        if (IS_IPAD) {
    //
    //        }else
    //        {
    //            imageview1.frame=CGRectMake(0, 0, 200, 25);
    //             imageview1.contentMode = UIViewContentModeScaleAspectFit;
    //            self.navigationItem.titleView = imageview1;
    //        }
    //
    //        NSLog(@"Lanscapse");
    //    }
    //    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
    //    {
    //          if (!IS_IPAD)
    //        {
    //            imageview1.frame=CGRectMake(0, 0, 200, 30);
    //             imageview1.contentMode = UIViewContentModeScaleAspectFit;
    //            self.navigationItem.titleView = imageview1;
    //
    //        }
    //
    //        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
    //        statusBarView.backgroundColor = [UIColor darkGrayColor];
    //        [self.navigationController.navigationBar addSubview:statusBarView];
    //           NSLog(@"UIDeviceOrientationPortrait");
    //    }
    //
    
    self.navigationController.navigationBarHidden=NO;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:(75/255.0) blue:(142/255.0) alpha:1.0]];
    
    
}
-(void)backAction
{
    if (isClicked)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeView" object:self];
        isClicked=NO;
        
    }
    else if (isClickedForWebVw)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"webViewBack" object:self];
        isClickedForWebVw=NO;
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)getDetails
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString * post=[NSString stringWithFormat:@""];
        
        
        
        getListUrl=[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://sindhtv.tv/index.php/api/menu_config"]];
        
        
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
        
        NSLog(@"Response : %@", response);
        
        
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
                    titleNamesArr=[jsonData objectForKey:@"items"];
                    
                    
                    
                    NSLog(@"Notification Data %@",jsonData);
                    
                    NSLog(@"%lu",(unsigned long)titleNamesArr.count);
                    
                    if (titleNamesArr )
                    {
                        
                        self.collectionVw.dataSource=self;
                        self.collectionVw.delegate=self;
                        
                        [self.collectionVw reloadData];
                        
                        
                        
                        NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:0 inSection:0];
                        [self.collectionVw selectItemAtIndexPath:indexPathForFirstRow animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                        [self collectionView:self.collectionVw didSelectItemAtIndexPath:indexPathForFirstRow];
                        UICollectionViewCell* cell = [self.collectionVw cellForItemAtIndexPath:indexPathForFirstRow];
                        cell.contentView.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwSelectionClr"]];
                        
                        [customIndicator stopAnimating];
                        [customIndicator removeFromSuperview];
                        
                        
                    }
                    else{
                        
                        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"No Menu in This Channel " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                        [alert show];
                    }
                    
                }
                
                
                else{
                    [NSThread sleepForTimeInterval:3.0];
                    
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:[jsonData objectForKey:@"items"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
                
            }
        });
        
        
    });
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    
    return titleNamesArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"cell";
    UIView *circleView;
    UILabel *titleLabel;
    UIImageView *imageView;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // cell.textLabel.text=[[titleNamesArr valueForKey:@"menu_name"] objectAtIndex:indexPath.row];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        //  if (!indexPath.row==0) {
        // cell.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"sideMenuBg"]];
        //}
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        circleView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, 45, 50)];
        circleView.tag = MAIN_VIEW_TAG;
        circleView.backgroundColor = [UIColor clearColor];
        circleView.layer.borderWidth = 0.5;
        circleView.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0].CGColor;
        circleView.layer.cornerRadius = circleView.bounds.size.height/2;
        circleView.clipsToBounds = YES;
        
        [cell.contentView addSubview:circleView];
        
        
        
        
        
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65,5,200, 45)];
        titleLabel.tag = TITLE_LABLE_TAG;
        [titleLabel setTextColor:[self colorWithHexString:[defaults valueForKey:@"sideMenuText"]]];
        
        
        titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:16];
        
        [cell.contentView addSubview:titleLabel];
        
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        imageView.tag = IMAGE_VIEW_TAG;
        imageView.center = circleView.center;
        [cell.contentView addSubview:imageView];
    }else {
        if ([indexArray containsObject:indexPath])
        {
            cell.contentView.backgroundColor = [UIColor purpleColor];
        }
        else{
            cell.contentView.backgroundColor = [UIColor clearColor];
        }
        
        
        circleView = (UIView *)[cell.contentView viewWithTag:MAIN_VIEW_TAG];
        titleLabel = (UILabel *)[cell.contentView viewWithTag:TITLE_LABLE_TAG];
        imageView = (UIImageView *)[cell.contentView viewWithTag:IMAGE_VIEW_TAG];
    }
    
    titleLabel.text = [[titleNamesArr valueForKey:@"menu_name"] objectAtIndex:indexPath.row];
    // imageView.image = [UIImage imageNamed:[[titleNamesArr valueForKey:@"menu_icon"] objectAtIndex:indexPath.row]];
    
    NSString *imgString=[[titleNamesArr valueForKey:@"menu_icon"] objectAtIndex:indexPath.row];
    NSURL * url=[NSURL URLWithString:imgString];
    
    
    [imageView sd_setImageWithURL:url placeholderImage:[ UIImage imageNamed:@"live"]];
    
    
    //    [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
    //        if (succeeded) {
    //
    //            if (image==nil) {
    //                //  imageView.image=[UIImage imageNamed:[[titleNamesArr valueForKey:@"menu_icon"] objectAtIndex:indexPath.row] ];
    //            }
    //            else{
    //                imageView.image =image ;
    //            }
    //            // save image in
    //        }
    //        else
    //        {
    //            imageView.image=[UIImage imageNamed:[[titleNamesArr valueForKey:@"menu_icon"] objectAtIndex:indexPath.row] ];
    //        }
    //
    //    }];
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    tableCell.contentView.backgroundColor=[UIColor clearColor];
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GDCollectionViewCell *clearCell=[[GDCollectionViewCell alloc] init];
    defaults = [NSUserDefaults standardUserDefaults];
    
    if (!IS_IPAD) {
        
        [appdelegate hideStatusBarAction];
    }
    
    NSLog(@"%li",(long)indexPath.row);
    isCLickedForArticles=NO;
    indexArray = [[NSMutableArray alloc] init];
    [indexArray addObject:indexPath];
    
    if (indexPath.row<titleNamesArr.count- countForArrElements)
    {
        [clearCell setCollectionViewDataSourceDelegate:cellForDeselect indexPath:indPath];
        
        [self.collectionVw selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self collectionView:self.collectionVw didSelectItemAtIndexPath:indexPath];
        
    }
    
    
    UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    tableCell.contentView.backgroundColor=[UIColor purpleColor];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setBoolValueNo" object:self];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setBoolNoForEpaper" object:self];
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setDuration:0.50];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [_menuTable.layer addAnimation:animation forKey:kCATransition];
    
    
    _menuTable.hidden=YES;
    count=1;
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuClose" object:self];
    
    
    if ([[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:1]])
        
    {
        
        
        
    }
    
    else if ([[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:3]])
        
    {
        
    }
    
    else if ([[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:7]])
        
    {
        
        
    }
    
    
    
    else if ([[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:10]])
        
    {
    }
    
    else if ([[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:11]])
        
    {
    }
    //userUploads
    
    else if ([[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:9]])
        
    {
        firstTime=NO;
        GDUserUploadsController *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"userUploads"];
        [self.navigationController pushViewController:lifelineViewController animated:YES];
        
    }
    
    else if ([[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:8]])
        
    {
        firstTime=NO;
        NSMutableArray *sharingItems = [NSMutableArray new];
        
        // NSData* imageData =[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [defaults objectForKey:@"channelImage"]]]];
        
        UIImage* image = [UIImage imageNamed:[defaults valueForKey:@"applogo"]];
        
        // UIImage *image1=[self   decodeBase64ToImage:[defaults objectForKey:@"channelImage"]];
        
        
        
        NSString *appurl=[NSString stringWithFormat:@"%@",[defaults valueForKey:@"playStoreLink"]];
        
        
        NSURL *imageUrl=[defaults objectForKey:@"channelImage"];
        
        // NSMutableArray *ShareArr=[[NSMutableArray alloc]initWithObjects:image,appurl, nil];
        
        
        [sharingItems addObject:appurl];
        [sharingItems addObject:image];
        [sharingItems addObject:imageUrl];
        
        NSLog(@"objects===>%@",sharingItems);
        
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];
        
        
        
        // [self presentViewController:activityController animated:YES completion:nil];
        
        
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            [self presentViewController:activityController animated:YES completion:nil];
        }
        //if iPad
        else {
            // Change Rect to position Popover
            UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
            [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        
        
    }
    
    else if ([[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:12]])
        
    {
        firstTime=NO;
        GDArticlesWebView *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"articlesWebVw"];
        
        
        lifelineViewController.epaperUrl=[NSString stringWithFormat:@"http://poovee.net/webservices/packagelist/%@/%@/?appid=%li",[defaults valueForKey:@"channelID"],[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row],(long)[defaults integerForKey:@"appID"]];
        lifelineViewController.fromEpaper=@"FROMEPAPER";
        lifelineViewController.about=@"ABOUT";
        
        
        [self.navigationController pushViewController:lifelineViewController animated:YES];
        
        
        
        
        
    }
    else if ([[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:13]])
        
    {
        
        firstTime=NO;
        
        GDSettingsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
        [self.navigationController  pushViewController:vc animated:YES];
        
    }
    
    //    contact us
    else if ([[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:15]])
        
    {
        
        firstTime=NO;
        GDArticlesWebView *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"articlesWebVw"];
        
        
        lifelineViewController.epaperUrl=[NSString stringWithFormat:@"http://www.thesindh.tv/entertainment/contact/appcontact.html"];
        lifelineViewController.contactusUrl=[NSString stringWithFormat:@"http://www.thesindh.tv/program.html"];
        lifelineViewController.isfromPrograms=YES;
        
        
        [self.navigationController pushViewController:lifelineViewController animated:YES];
        
    }
    //Programs
    else if ([[[titleNamesArr valueForKey:@"menu_id"] objectAtIndex:indexPath.row] isEqualToNumber:[NSNumber numberWithInt:16]])
        
    {
        
        firstTime=NO;
        GDArticlesWebView *lifelineViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"articlesWebVw"];
        
        
        lifelineViewController.contactusUrl=[NSString stringWithFormat:@"http://www.thesindh.tv/program.html"];
        lifelineViewController.isfromPrograms=YES;
        
        
        [self.navigationController pushViewController:lifelineViewController animated:YES];
    }
    
    
    
    
    
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
- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData {
    NSData *imageData = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:imageData];
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
//
//
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//
//        //        if (forArticlewebVwRotation==YES) {
//        //            self.topMarginForColVw.constant=55;
//        //            self.topSpaceForTable.constant=55;
//        //            forArticlewebVwRotation=NO;
//        //        }
//        //        else{
//
//        if (IS_IPAD) {
//            self.topMarginForColVw.constant=64;
//            self.topSpaceForTable.constant=64;
//
//        }
//      else  if ([UIScreen mainScreen].bounds.size.width==736) {
//            imageview1.frame=CGRectMake(0, 0, 200, 30);
//           imageview1.contentMode = UIViewContentModeScaleAspectFit;
//            self.topMarginForColVw.constant=44;
//            self.topSpaceForTable.constant=44;
//        }
//        else
//        {
//            imageview1.frame=CGRectMake(0, 0, 200, 25);
//             imageview1.contentMode = UIViewContentModeScaleAspectFit;
//            self.topMarginForColVw.constant=32;
//            self.topSpaceForTable.constant=32;
//        }
//
//
//        NSLog(@"Lanscapse");
//    }
//    if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
//    {
//
//        if (!IS_IPAD)
//        {
//            imageview1.frame=CGRectMake(0, 0, 200, 30);
//             imageview1.contentMode = UIViewContentModeScaleAspectFit;
//        }
//
//        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, self.view.frame.size.width, 22)];
//        statusBarView.backgroundColor = [UIColor darkGrayColor];
//        [self.navigationController.navigationBar addSubview:statusBarView];
//
//
//        self.topMarginForColVw.constant=64;
//        self.topSpaceForTable.constant=64;
//        NSLog(@"UIDeviceOrientationPortrait");
//    }
//}
-(void)viewDidAppear:(BOOL)animated
{
    
    
    
    if (firstTime)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *indexPathForFirstRow = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.collectionVw selectItemAtIndexPath:indexPathForFirstRow animated:NO scrollPosition:UICollectionViewScrollPositionNone];
                [self collectionView:self.collectionVw didSelectItemAtIndexPath:indexPathForFirstRow];
                UICollectionViewCell* cell = [self.collectionVw cellForItemAtIndexPath:indexPathForFirstRow];
                cell.contentView.backgroundColor=[self colorWithHexString:[defaults valueForKey:@"colVwSelectionClr"]];
                
                [customIndicator stopAnimating];
                [customIndicator removeFromSuperview];
                
            });
        });
        
        
        
        
    }
    
    
}


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6)
        return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
        
    }
    
    if (cString.length==8) {
        cString = [cString substringFromIndex:2];
    }
    
    if ([cString length] != 6)
        return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(void)RotateView

{
    //    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation ]== UIDeviceOrientationLandscapeRight)
    //    {
    //
    //
    //
    //
    //        if (IS_IPAD) {
    //            self.topMarginForColVw.constant=64;
    //            self.topSpaceForTable.constant=64;
    //
    //        }
    //        else  if ([UIScreen mainScreen].bounds.size.width==736) {
    //            imageview1.frame=CGRectMake(0, 0, 200, 40);
    //            imageview1.backgroundColor=[UIColor clearColor];
    //             imageview1.contentMode = UIViewContentModeScaleAspectFit;
    //            self.topMarginForColVw.constant=44;
    //            self.topSpaceForTable.constant=44;
    //        }
    //
    //
    //        else{
    //          imageview1.frame=CGRectMake(0, 0, 200, 40);
    //            imageview1.backgroundColor=[UIColor clearColor];
    //             imageview1.contentMode = UIViewContentModeScaleAspectFit;
    //            self.topMarginForColVw.constant=32;
    //            self.topSpaceForTable.constant=32;
    //            
    //            
    //        }
    //        
    //        NSLog(@"Lanscapse");
    //    }
    //    else if([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown )
    //    {
    //        
    //        if (!IS_IPAD)
    //        {
    //             imageview1.frame=CGRectMake(0, 0, 200, 40);
    //             imageview1.contentMode = UIViewContentModeScaleAspectFit;
    //            
    //        }
    //        self.topMarginForColVw.constant=64;
    //        self.topSpaceForTable.constant=64;
    //        
    //        NSLog(@"UIDeviceOrientationPortrait");
    //    }
    //    
    //    
    
}
//
@end

