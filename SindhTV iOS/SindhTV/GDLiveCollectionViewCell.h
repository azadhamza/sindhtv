//
//  GDLiveCollectionViewCell.h
//  SindhTV
//
//  Created by intellisense on 11/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDLiveCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgVw;
@property (strong, nonatomic) IBOutlet UILabel *titleName;
@property(nonatomic,assign) NSInteger integerForCollectionCell1;
@end
