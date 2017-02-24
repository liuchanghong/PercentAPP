//
//  BaseViewController.h
//  GoldenMapApp
//
//  Created by LiuChanghong on 16/2/25.
//  Copyright © 2016年 GuanYiHengXin. All rights reserved.
//

#import <UIKit/UIKit.h>

// 屏幕宽度
#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width

// 屏幕高度
#define SCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height

// 颜色
#define HexRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 字体
#define GHFont(a) [UIFont fontWithName:@"PingFangSC-UltraLight" size:a]


@interface BaseViewController : UIViewController
-(void)back;
-(UIImage*)GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height;
//毛玻璃
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize;
@end
