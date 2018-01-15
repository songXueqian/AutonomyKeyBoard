//
//  emotionTextView.m
//  KeyBoardTest
//
//  Created by LY on 2018/1/11.
//  Copyright © 2018年 SongXueqian. All rights reserved.
//

#import "emotionTextView.h"

@implementation emotionTextView

- (void)deleteBackward {
    if ([self.emotionDelegate respondsToSelector:@selector(emotionTextViewDeleteBackward:)]) {
        [self.emotionDelegate emotionTextViewDeleteBackward:self];
    }
    [super deleteBackward];
}


@end
