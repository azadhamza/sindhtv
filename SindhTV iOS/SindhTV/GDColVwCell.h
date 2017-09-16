//
//  GDColVwCell.h
//  SindhTV
//
//  Created by intellisense on 24/05/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDColVwCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageVw;
@property (strong, nonatomic) IBOutlet UILabel *titleLbl;
@property(nonatomic,assign) NSInteger integerForCollectionCell1;

@end
