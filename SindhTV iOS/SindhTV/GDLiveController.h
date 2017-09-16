//
//  GDLiveController.h
//  SindhTV
//
//  Created by intellisense on 14/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDWebLiveController.h"

@interface GDLiveController : UIViewController
- (IBAction)watchLiveBtnAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *watchLiveBtn;
@property (strong, nonatomic) IBOutlet UIImageView *bgImageForView;
@property(nonatomic)NSInteger topHeight;
@property(strong,nonatomic)NSString *urlString;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightForWatchLiveBtn;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthForWatchLiveBtn;
@property (strong, nonatomic) IBOutlet UILabel *watchLiveLbl;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthForLbl;
@property (weak, nonatomic) IBOutlet DFPBannerView *bannerView;
@property (strong, nonatomic) IBOutlet UIButton *ListenLiveBtn;
- (IBAction)listenLiveBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *liveLblButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightForListenLive;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *widthForListenLive;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpaceForListenLive;

@end
