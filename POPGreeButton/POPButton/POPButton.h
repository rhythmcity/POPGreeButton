//
//  POPButton.h
//  POPGreeButton
//
//  Created by 李言 on 16/3/31.
//  Copyright © 2016年 李言. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^POPButtonClick)(_Nullable id);

@interface POPButton : UIView

@property (nonnull,nonatomic,strong,readonly)UIImage *nomalImage;

@property (nonnull,nonatomic,strong,readonly)UIImage *selectImage;

@property (nonnull,nonatomic,strong,readonly)UIImage *sparkImage;


+ (nullable instancetype)buttonWithNomalImage:(UIImage * _Nullable )nomalImage
                         selectImage:(UIImage * _Nullable)selectImage
                          sparkImage:(UIImage * _Nullable)sparkImage
                      popButtonClick:(POPButtonClick _Nullable)popBuutonClickBlock;




@end
