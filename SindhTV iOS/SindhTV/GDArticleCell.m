//
//  GDArticleCell.m
//  SindhTV
//
//  Created by intellisense on 24/05/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDArticleCell.h"
#import "GDColVwCell.h"
@implementation GDArticleCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    //    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    ////        layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
    //    layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    //    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    //    [self.collectionView registerClass:[SHHomeCollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    //    self.collectionView.backgroundColor = [UIColor clearColor];
    //    self.collectionView.showsHorizontalScrollIndicator = NO;
    //    [self.contentView addSubview:self.collectionView];
    
    [self.articlesColVw registerClass:[GDColVwCell class] forCellWithReuseIdentifier:cell];
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    //    layout.sectionInset = UIEdgeInsetsMake(30.f, 30.f, 8.f, 8.f);
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    self.articlesColVw.showsHorizontalScrollIndicator=NO;
    //     self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.contentView addSubview:self.articlesColVw];
    //    layout.itemSize=CGSizeMake(172, 161);
    //    layout.minimumLineSpacing=2;
    //    layout.minimumInteritemSpacing=2;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionview) name:@"ReloadCollectionView" object:nil];
    
    return self;
}

-(void)reloadCollectionview
{
    [self.articlesColVw reloadData];
    
}




- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    
    GDColVwCell *cell=[[GDColVwCell alloc] init];
    cell.integerForCollectionCell1=indexPath.row;
    self.articlesColVw.tag=indexPath.section;
    self.articlesColVw.dataSource = dataSourceDelegate;
    self.articlesColVw.delegate = dataSourceDelegate;
    [self.articlesColVw reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadCollectionView" object:self];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
