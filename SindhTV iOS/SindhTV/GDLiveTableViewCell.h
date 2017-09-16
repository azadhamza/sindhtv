//
//  GDLiveTableViewCell.h
//  SindhTV
//
//  Created by intellisense on 11/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDLiveTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UICollectionView *LiveCollectionVw;
@property (strong, nonatomic) IBOutlet UILabel *titleHeader;
@property (strong, nonatomic) IBOutlet UIButton *viewAllBtn;
@property (strong, nonatomic) IBOutlet UIButton *viewAll2;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end
static NSString *cell = @"cell";