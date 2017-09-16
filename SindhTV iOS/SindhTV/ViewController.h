//
//  ViewController.h
//  SindhTV
//
//  Created by intellisense on 11/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UICollectionView *collectionVw;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuBtn;
@property(strong,nonatomic)IBOutlet UIView *mainVw;
@property(strong,nonatomic)IBOutlet UITableView *menuTable;

- (IBAction)menuBtnAction:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topMarginForColVw;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwForBg;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpaceForTable;
@property(strong,nonatomic)NSString *channelID;
@property(nonatomic)NSInteger value;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topspaceForMainVw;


@end

