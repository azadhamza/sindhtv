//
//  GDMyVideoCustomCell.h
//  SindhTV
//
//  Created by intellisense on 22/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDMyVideoCustomCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIButton *videosBtn;
@property (strong, nonatomic) IBOutlet UILabel *videosTitleName;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnLeftConstant;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *btnRightConstant;

@end
