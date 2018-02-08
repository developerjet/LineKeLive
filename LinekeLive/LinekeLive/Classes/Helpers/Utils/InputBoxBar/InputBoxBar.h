//
//  InputBoxBar.h
//  LinekeLive
//
//  Created by CODER_TJ on 2018/2/6.
//  Copyright © 2018年 CODER_TJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKEmojiKeyBoard.h"

typedef void(^EditFinishedBlock)(NSString *text);

typedef enum {
    kInputBarDidStatus_Emoji,
    kInputBarDidStatus_keyboard
}kInputBarDidStatus;

@class InputBoxBar;
@protocol InputBoxBarDelegate<NSObject>
@required
/// 区分键盘类型
- (void)inputBoxBar:(InputBoxBar *)boxBar DidKeyBoardStatus:(kInputBarDidStatus)status;
@optional
/// 获取当前输入的值
- (void)inputBoxBar:(InputBoxBar *)boxBar DidEditingAtText:(NSString *)text;
/// 获取当前输入完成的值
- (void)inputBoxBar:(InputBoxBar *)boxBar DidEndEditingAtText:(NSString *)text;

@end

@interface InputBoxBar : UIView

/** 输入字体大小 */
@property (nonatomic, assign) CGFloat fontSize;

/** 可展示最大行数(默认3行) */
@property (nonatomic, assign) NSInteger maxLine;

/** 代理设置 */
@property (nonatomic, weak) id<InputBoxBarDelegate> delegate;

/** 编辑完成时回调 */
@property (nonatomic, copy) EditFinishedBlock editFinishedBlock;

/** 当前编辑的信息 */
@property (nonatomic, copy) NSString *content;

/** 弹出键盘 */
- (void)become;

/** 手动回收键盘 */
- (void)recovery;



@end
