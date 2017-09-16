//
//  GDCustomViewCell.h
//  SindhTV
//
//  Created by intellisense on 16/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDCustomViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *Channel;
@property (strong, nonatomic) IBOutlet UILabel *channelTitleName;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnLeftConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnRightConstant;

@end
