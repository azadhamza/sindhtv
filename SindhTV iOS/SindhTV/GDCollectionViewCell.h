//
//  GDCollectionViewCell.h
//  SindhTV
//
//  Created by intellisense on 11/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property (strong, nonatomic) IBOutlet UIImageView *imgClr;
@property (strong, nonatomic) IBOutlet UIButton *cellBtn;
- (void)setCollectionViewDataSourceDelegate:(GDCollectionViewCell *)colVw indexPath:(NSIndexPath *)indexPath;

@property (strong, nonatomic) IBOutlet UIImageView *separatorImage;


@end
