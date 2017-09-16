//
//  GDViewAllController.h
//  SindhTV
//
//  Created by intellisense on 22/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDViewAllController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *viewAllTblVw;
@property(strong,nonatomic)NSArray *articlesArr;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwForBg;
@property(strong,nonatomic)NSString *headerTitle;
@property(nonatomic)NSInteger value;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topSpaceForTblVw;

@end
