//
//  EmotionCollectionViewCell.m
//  KeyBoardTest
//
//  Created by LY on 2018/1/10.
//  Copyright © 2018年 SongXueqian. All rights reserved.
//

#import "EmotionCollectionViewCell.h"

@implementation EmotionCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.myImage = [[UIImageView alloc] init];
        self.myImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.myImage];
        
 
        
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.myImage.frame = CGRectMake(0, 0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);

    
    
    
}

@end
