//
//  GDChannelsViewController.h
//  SindhTV
//
//  Created by intellisense on 16/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDChannelsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *channelsColVw;
- (IBAction)ChannelAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *backGroundVw;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpaceForColVw;
@property (weak, nonatomic) IBOutlet DFPBannerView *bannerView;

@end
