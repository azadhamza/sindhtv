//
//  GDLiveTableViewCell.m
//  SindhTV
//
//  Created by intellisense on 11/04/16.
//  Copyright © 2016 intellisense. All rights reserved.
//

#import "GDLiveTableViewCell.h"
#import "GDLiveCollectionViewCell.h"
@implementation GDLiveTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    
    [self.LiveCollectionVw registerClass:[GDLiveCollectionViewCell class] forCellWithReuseIdentifier:cell];
    UICollectionViewFlowLayout*layout=[[UICollectionViewFlowLayout alloc]init];
    //    layout.sectionInset = UIEdgeInsetsMake(30.f, 30.f, 8.f, 8.f);
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    self.LiveCollectionVw.showsHorizontalScrollIndicator=NO;
    //     self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.contentView addSubview:self.LiveCollectionVw];
    //    layout.itemSize=CGSizeMake(172, 161);
    //    layout.minimumLineSpacing=2;
    //    layout.minimumInteritemSpacing=2;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionview) name:@"ReloadCollectionView" object:nil];
    
    return self;
}

-(void)reloadCollectionview
{
    [self.LiveCollectionVw reloadData];
    
}




- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    
    GDLiveCollectionViewCell *cell=[[GDLiveCollectionViewCell alloc] init];
    cell.integerForCollectionCell1=indexPath.row;
    self.LiveCollectionVw.tag=indexPath.section;
    self.LiveCollectionVw.dataSource = dataSourceDelegate;
    self.LiveCollectionVw.delegate = dataSourceDelegate;
    [self.LiveCollectionVw reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadCollectionView" object:self];
}

@end
