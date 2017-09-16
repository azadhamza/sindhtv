//
//  GDArticleCell.h
//  SindhTV
//
//  Created by intellisense on 24/05/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDArticleCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imgVw;
@property (strong, nonatomic) IBOutlet UILabel *titleHeader;
@property (strong, nonatomic) IBOutlet UICollectionView *articlesColVw;
@property (strong, nonatomic) IBOutlet UIButton *moreBtn;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;
@end
static NSString *cell = @"CVCell";