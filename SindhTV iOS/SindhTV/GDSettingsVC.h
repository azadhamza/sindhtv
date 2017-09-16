//
//  GDSettingsVC.h
//  SindhTV
//
//  Created by intellisense on 12/05/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDSettingsVC : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgVwForBg;
@property (strong, nonatomic) IBOutlet UISwitch *notificationSwitch;
- (IBAction)notificationSwitchAction:(UISwitch *)sender;

@end
