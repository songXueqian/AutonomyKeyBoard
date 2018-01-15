//
//  ViewController.m
//  KeyBoardTest
//
//  Created by LY on 2018/1/10.
//  Copyright © 2018年 SongXueqian. All rights reserved.
//

/*
1.表情导入，做成bundle导入工程，本地文件夹改名.bundle即可。项目中对应建plist文件，数组和字典，数组为了取值，字典给后台传数据
2.表情UI,collectionView形式展示, collectionView.pagingEnabled = YES, collectionView.bounces = YES;本地表情数量是写死的
3.UITextView.根据内容改变高度，最多4行,textView点击发送时，内容中有表情的字符变成表情
4.删除textView输入内容，有字符表情直接删除. UITextView,UITextField删除按钮事件 UITextInput
 
 @protocol UIKeyInput <UITextInputTraits>
 
 #if UIKIT_DEFINE_AS_PROPERTIES
 @property(nonatomic, readonly) BOOL hasText;
 #else
 - (BOOL)hasText;
 #endif
 - (void)insertText:(NSString *)text;
 - (void)deleteBackward;
 
 @end
 
 需新建textView继承自UITextView,重写方法deleteBackward
*/

#import "ViewController.h"
#import "EmotionCollectionViewCell.h"

#define emotionHeight (SCREEN_WIDTH - 8 * 10) / 7
#define collectionViewHeight (emotionHeight * 3 + 40)
@interface ViewController ()

@end

@implementation ViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    self.keyBoardHeight = height;
    self.grayView.frame = CGRectMake(0, SCREEN_HEIGHT - self.grayHeight - height, SCREEN_WIDTH, self.grayHeight);
    self.grayY = self.grayView.frame.origin.y;
    self.grayHeight = self.grayView.frame.size.height;

    [self.emotionButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    self.num2 = 2;
    
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    if (1 == self.num2) {
        self.grayView.frame = CGRectMake(0, SCREEN_HEIGHT - self.grayHeight - collectionViewHeight, SCREEN_WIDTH, self.grayHeight);
        
    } else {
        [self.grayView setFrame:CGRectMake(0, SCREEN_HEIGHT - self.grayHeight, SCREEN_WIDTH, self.grayHeight)];
        
        
    }
    self.grayY = self.grayView.frame.origin.y;
    self.grayHeight = self.grayView.frame.size.height;
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.zhengArray = [NSMutableArray array];
    self.yuArray = [NSMutableArray array];

    
    self.dataArray = [NSMutableArray array];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emotion.plist" ofType:nil];
    
    self.emotionsArray = [NSMutableArray arrayWithContentsOfFile:path];
    for (NSString *string in self.emotionsArray) {
        [self.dataArray addObject:string];
    }
//    self.dataArray = (NSMutableArray *)[self.dataArray subarrayWithRange:NSMakeRange(21, 19)];
    
    self.zhengNum = self.dataArray.count / 21;
    self.yuNum = self.dataArray.count % 21;
    if (self.yuNum > 0) {
        
        self.yuNum = 1;
        
    }
    
    self.zhengArray = (NSMutableArray *)[self.dataArray subarrayWithRange:NSMakeRange(0, 21)];
    self.yuArray = (NSMutableArray *)[self.dataArray subarrayWithRange:NSMakeRange(21, 19)];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, SCREEN_WIDTH - 200, 30)];
    self.label.font = [UIFont systemFontOfSize:16];
    self.label.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.label];
    
    
    self.grayView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45)];
    self.grayView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.grayView];
    self.grayY = self.grayView.frame.origin.y;
    self.grayHeight = self.grayView.frame.size.height;
    
    self.textButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
    [self.textButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [self.textButton addTarget:self action:@selector(textAction) forControlEvents:UIControlEventTouchUpInside];
    [self.grayView addSubview:self.textButton];
    
    self.textView = [[emotionTextView alloc] initWithFrame:CGRectMake(self.textButton.frame.origin.y + self.textButton.frame.size.width + 5, 3.15, SCREEN_WIDTH - (self.textButton.frame.origin.y + self.textButton.frame.size.width + 5) - (self.textButton.frame.size.width * 2 + 15), 38.7)];
    self.textView.textColor = [UIColor blackColor];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.delegate = self;
    self.textView.emotionDelegate = self;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5;
    [self.textView setReturnKeyType:UIReturnKeySend];
    self.textView.enablesReturnKeyAutomatically = YES;
    [self.grayView addSubview:self.textView];
    
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - self.textButton.frame.size.width - 5, self.textButton.frame.origin.y, self.textButton.frame.size.width, self.textButton.frame.size.height)];
    [self.addButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    [self.grayView addSubview:self.addButton];
    
    self.emotionButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - self.textButton.frame.size.width * 2 - 10, self.textButton.frame.origin.y, self.textButton.frame.size.width, self.textButton.frame.size.height)];
    [self.emotionButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    [self.emotionButton addTarget:self action:@selector(emotionAction) forControlEvents:UIControlEventTouchUpInside];
    [self.grayView addSubview:self.emotionButton];
    
    
    
    
    //collectionView
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(emotionHeight, emotionHeight);
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 左右
    flowLayout.minimumInteritemSpacing = 10;
    // 上下
    flowLayout.minimumLineSpacing = 10;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 5);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, collectionViewHeight) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.collectionView];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = YES;
    
    [self.collectionView registerClass:[EmotionCollectionViewCell class] forCellWithReuseIdentifier:@"张三"];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view != self.view) {
        return NO;
    } else {
        return YES;
    }
}

- (void)click{
    [self.view endEditing:YES];
    [self.collectionView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, collectionViewHeight)];
    self.grayView.frame = CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45);
    
    [self.textButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    self.num = 2;
    
    [self.emotionButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
    self.num2 = 2;
}


- (void)textAction{
    if (1 == self.num) {
        [self.textButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        self.num = 2;
        [self.textView resignFirstResponder];
        [self.collectionView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, collectionViewHeight)];
        self.grayView.frame = CGRectMake(0, SCREEN_HEIGHT - self.grayHeight, SCREEN_WIDTH, self.grayHeight);
        self.grayY = self.grayView.frame.origin.y;
        self.grayHeight = self.grayView.frame.size.height;
        self.num2 = 2;
        [self.emotionButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        
        
    } else {
        [self.textButton setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
        self.num = 1;
        [self.textView becomeFirstResponder];
        [self.collectionView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, collectionViewHeight)];
    }
}

- (void)emotionAction{
    
    if (1 == self.num2) {
        [self.emotionButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        self.num2 = 2;
        [self.textView becomeFirstResponder];
        [self.collectionView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, collectionViewHeight)];
        
    } else {
        [self.emotionButton setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
        self.num2 = 1;
        [self.textView resignFirstResponder];
        [self.collectionView setFrame:CGRectMake(0, SCREEN_HEIGHT - collectionViewHeight, SCREEN_WIDTH, collectionViewHeight)];
        self.grayView.frame = CGRectMake(0, SCREEN_HEIGHT - self.grayHeight - collectionViewHeight, SCREEN_WIDTH, self.grayHeight);
        self.grayY = self.grayView.frame.origin.y;
        self.grayHeight = self.grayView.frame.size.height;
        [self.textButton setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
        self.num = 1;
        
    }
    
}

- (void)addAction{
    
}

//输入文字事件，自动改变高度
- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}
    
// textView.delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //输入文字事件，自动改变高度，最多4行
    CGRect frame = textView.frame;
    CGFloat numheight = frame.size.height;
    NSLog(@"numheight === %f", numheight);

    float height;
    if ([text isEqual:@""]) {

        if (![textView.text isEqualToString:@""]) {

            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];

        }else{

            height = [ self heightForTextView:textView WithText:textView.text];
        }
    }else{

        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }

    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        NSLog(@"frame.size.height === %f", frame.size.height);

        if (height >= 4 * 20) {
           
        } else {
            textView.frame = frame;
            if (numheight <= frame.size.height) {
                [self.grayView setFrame:CGRectMake(self.grayView.frame.origin.x, SCREEN_HEIGHT - 45 - self.keyBoardHeight - (frame.size.height - 38.7), self.grayView.frame.size.width, 45 + (frame.size.height - 38.7))];
               
                NSLog(@"grayView ==== %f", self.grayView.frame.size.height);
                self.grayY = self.grayView.frame.origin.y;
                self.grayHeight = self.grayView.frame.size.height;
            }
        }
        



    } completion:nil];


    NSLog(@"textView.frame.size.height === %f", textView.frame.size.height);
    //点击回车事件
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self.collectionView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, collectionViewHeight)];
        self.grayView.frame = CGRectMake(0, SCREEN_HEIGHT - 45, SCREEN_WIDTH, 45);
        
        [self.textButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        self.num = 2;
        
        [self.emotionButton setBackgroundImage:[UIImage imageNamed:@"1"] forState:UIControlStateNormal];
        self.num2 = 2;
        
        NSLog(@"self.textView.text === %@", self.textView.text);
        self.label.text = self.textView.text;
  
        //转成可变属性字符串
        NSMutableAttributedString *mAttributedString = [[NSMutableAttributedString alloc] initWithString:self.label.text];
        //创建匹配正则表达式的类型描述模板
        NSString *pattern = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        
        //创建匹配对象
        NSError *error;
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        //判断
        if (!regularExpression)//如果匹配规则对象为nil
        {
            NSLog(@"正则创建失败！");
            NSLog(@"error = %@",[error localizedDescription]);
            
        } else {
            
            NSArray *resultArray = [regularExpression matchesInString:mAttributedString.string options:NSMatchingReportCompletion range:NSMakeRange(0, mAttributedString.string.length)];

            //开始遍历 逆序遍历
            for (NSInteger i = resultArray.count - 1; i >= 0; i --)
            {
                //获取检查结果，里面有range
                NSTextCheckingResult *result = resultArray[i];
                
                //根据range获取字符串
                NSString *rangeString = [mAttributedString.string substringWithRange:result.range];
                
                //获取图片
                UIImage *image = [self imageToString:rangeString];//这是个自定义的方法
                
                if (image != nil)
                {
                    //创建附件对象
                    NSTextAttachment *imageTextAttachment = [[NSTextAttachment alloc]init];
                    //设置图片属性
                    imageTextAttachment.image = image;
                    
                    //根据图片创建属性字符串
                    NSAttributedString *imageAttributeString = [NSAttributedString attributedStringWithAttachment:imageTextAttachment];
                    
                    //开始替换
                    [mAttributedString replaceCharactersInRange:result.range withAttributedString:imageAttributeString];
                }
            }
        }
        //处理完毕后显示在label上
        self.label.attributedText = mAttributedString;

        return NO;
        
    }
    


    return YES;
}


//文字变图片
- (UIImage *)imageToString:(NSString *)string{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emotionKey.plist" ofType:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *keyString = @"";
    NSArray *array = [dic allValues];
    NSArray *array2 = [dic allKeys];
    
    for (int i = 0; i < array.count; i++) {
        NSString *valueString = [array objectAtIndex:i];
        if ([valueString isEqualToString:string]) {
            keyString = [array2 objectAtIndex:i];
        }
    }
    
    UIImage *emotionImage = [UIImage imageNamed:[NSString stringWithFormat:@"emotion.bundle/%@", keyString]];
    return emotionImage;
}

#pragma mark -- collectionView  的代理方法

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.zhengNum + self.yuNum;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (0 == section) {
        return 21;
    } else {
        return 19;
    }
//    return 19;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EmotionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"张三" forIndexPath:indexPath];
    
    if (0 == indexPath.section) {
        cell.myImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"emotion.bundle/%@", [self.zhengArray objectAtIndex:indexPath.item]]];
    } else {
        cell.myImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"emotion.bundle/%@", [self.yuArray objectAtIndex:indexPath.item]]];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPath.item === %ld", (long)indexPath.item);
    NSString *string = [self.dataArray objectAtIndex:indexPath.item];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"emotionKey.plist" ofType:nil];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString *valueString = @"";
    
    for (NSString *key in dic) {
        if ([string isEqualToString:key]) {
            valueString = [dic objectForKey:key];
        }
    }
    
    self.textView.text = [NSString stringWithFormat:@"%@%@", self.textView.text, valueString];
    
    
}


//键盘删除事件
- (void)emotionTextViewDeleteBackward:(UITextView *)textView{
    NSLog(@"删除");
    NSString *textViewString = self.textView.text;
    NSString *string = [textViewString substringWithRange:NSMakeRange([textViewString length] - 1,1)];
    
    if ([string isEqualToString:@"]"]) {
        textViewString = [textViewString substringToIndex:[textViewString length] - 3];
        textView.text = textViewString;
    } else {
        
    }
    
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
