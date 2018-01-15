//
//  ScrollViewCollectionViewCell.h
//  KeyBoardTest
//
//  Created by LY on 2018/1/12.
//  Copyright © 2018年 SongXueqian. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define emotionHeight (SCREEN_WIDTH - 8 * 10) / 7

@interface ScrollViewCollectionViewCell : UICollectionViewCell<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *emotionsArray;

@end
