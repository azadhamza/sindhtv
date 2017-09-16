//
//  GDLiveVieeController.h
//  SindhTV
//
//  Created by intellisense on 11/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;
@interface GDLiveViewController : UIViewController
@property(strong,nonatomic)IBOutlet UITableView *tblVw;
- (IBAction)viewAllBtnAction:(UIButton *)sender;
@property(strong,nonatomic)NSString *fromHeadlines,*urlString;
@property(strong,nonatomic)NSArray *headLinesArr,*videosArr;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwForBg;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpaceForTblVw;
@property(nonatomic)NSInteger value;
@property(strong,nonatomic)IBOutlet UIView *mainVw;
@property (weak, nonatomic) IBOutlet DFPBannerView *bannerView;

@end
