//
//  GDChannelVideos.h
//  SindhTV
//
//  Created by intellisense on 22/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDChannelVideos : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgVwForBgVw;
- (IBAction)videosBtnAction:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *videosColVw;

@property(strong,nonatomic)NSString *urlString;

@property (strong, nonatomic) IBOutlet UIView *mainVw;
@property (weak, nonatomic) IBOutlet DFPBannerView *bannerView;

@end
