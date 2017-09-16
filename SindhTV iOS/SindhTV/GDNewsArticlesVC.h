//
//  GDNewsArticlesVC.h
//  SindhTV
//
//  Created by intellisense on 24/05/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDNewsArticlesVC : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *articlesTblVw;
@property(strong,nonatomic) NSString *urlString,*fromHeadlines;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwForBg;
@property (strong, nonatomic) IBOutlet DFPBannerView *bannerView;

@property (strong, nonatomic) IBOutlet UIView *mainVw;
@end
