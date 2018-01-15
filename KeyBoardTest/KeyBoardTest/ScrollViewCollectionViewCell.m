//
//  ScrollViewCollectionViewCell.m
//  KeyBoardTest
//
//  Created by LY on 2018/1/12.
//  Copyright © 2018年 SongXueqian. All rights reserved.
//

#import "ScrollViewCollectionViewCell.h"
#import "EmotionCollectionViewCell.h"

@implementation ScrollViewCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.dataArray = [NSMutableArray array];
        self.emotionsArray = [NSMutableArray array];

        NSString *path = [[NSBundle mainBundle] pathForResource:@"emotion.plist" ofType:nil];
        
        self.emotionsArray = [NSMutableArray arrayWithContentsOfFile:path];
        for (NSString *string in self.emotionsArray) {
            [self.dataArray addObject:string];
        }
        
        //collectionView
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        
        flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 8 * 10) / 7, (SCREEN_WIDTH - 8 * 10) / 7);
        
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        // 左右
        flowLayout.minimumInteritemSpacing = 10;
        // 上下
        flowLayout.minimumLineSpacing = 10;
        
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 5);
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, (emotionHeight * 3 + 50) + 40) collectionViewLayout:flowLayout];
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.collectionView];
        
        [self.collectionView registerClass:[EmotionCollectionViewCell class] forCellWithReuseIdentifier:@"张三"];

    }
    return self;
}


//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//}

#pragma mark -- collectionView  的代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 21;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmotionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"张三" forIndexPath:indexPath];
    
//    cell.myImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"emotion.bundle/%@", [self.dataArray objectAtIndex:indexPath.item]]];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"indexPath.item === %ld", (long)indexPath.item);
//    NSString *string = [self.dataArray objectAtIndex:indexPath.item];
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"emotionKey.plist" ofType:nil];
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
//    
//    NSString *valueString = @"";
//    
//    for (NSString *key in dic) {
//        if ([string isEqualToString:key]) {
//            valueString = [dic objectForKey:key];
//        }
//    }
//    
//    self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text, valueString];
    
    
}


@end
