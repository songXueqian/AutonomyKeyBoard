//
//  ViewController.h
//  KeyBoardTest
//
//  Created by LY on 2018/1/10.
//  Copyright © 2018年 SongXueqian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "emotionTextView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController : UIViewController<UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate, emotionTextViewDelegate>

@property (nonatomic, strong)UIScrollView *backScrollView;

@property (nonatomic, strong)UIView *grayView;
@property (nonatomic, strong)UIButton *textButton;
@property (nonatomic, strong)emotionTextView *textView;
@property (nonatomic, strong)UIButton *emotionButton;
@property (nonatomic, strong)UIButton *addButton;
@property (nonatomic, assign)NSInteger num;
@property (nonatomic, assign)NSInteger num2;
@property (nonatomic, assign)NSInteger status;

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)NSMutableArray *emotionsArray;
@property (nonatomic, strong)UILabel *label;
@property (nonatomic, assign)CGFloat grayHeight;
@property (nonatomic, assign)CGFloat grayY;
@property (nonatomic, assign)CGFloat keyBoardHeight;

@property (nonatomic, assign)NSInteger zhengNum;
@property (nonatomic, assign)NSInteger yuNum;
@property (nonatomic, strong)NSMutableArray *zhengArray;
@property (nonatomic, strong)NSMutableArray *yuArray;

@end

