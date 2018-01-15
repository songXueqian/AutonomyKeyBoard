//
//  emotionTextView.h
//  KeyBoardTest
//
//  Created by LY on 2018/1/11.
//  Copyright © 2018年 SongXueqian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class emotionTextView;

@protocol emotionTextViewDelegate <NSObject>
- (void)emotionTextViewDeleteBackward:(emotionTextView *)textView;
@end

@interface emotionTextView : UITextView
@property (nonatomic, weak) id <emotionTextViewDelegate> emotionDelegate;

@end
