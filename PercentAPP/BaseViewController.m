//
//  BaseViewController.m
//  GoldenMapApp
//
//  Created by LiuChanghong on 16/2/25.
//  Copyright © 2016年 GuanYiHengXin. All rights reserved.
//

#import "BaseViewController.h"
#import "MozTopAlertView.h"
@interface BaseViewController ()<UIGestureRecognizerDelegate>
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self makeCehua];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  生成图片
 *
 *  @param color  图片颜色
 *  @param height 图片高度
 *
 *  @return 生成的图片
 */
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, height, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

//- (UIImage *)createShareImage:(NSString *)str name:(NSString *)name number:(NSString *)number grade:(NSString *)grade
//
//{
//    
//    UIImage *image = [self GetImageWithColor:[UIColor whiteColor] andHeight:100];
//    
//    CGSize size=CGSizeMake(image.size.width, image.size.height);//画布大小
//    
//    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
//    
//    [image drawAtPoint:CGPointMake(0, 0)];
//    
//    //获得一个位图图形上下文
//    
//    CGContextRef context=UIGraphicsGetCurrentContext();
//    
//    CGContextDrawPath(context, kCGPathStroke);
//    
//    
//    
//    //画 打败了多少用户
//    
//    [str drawAtPoint:CGPointMake(30, image.size.height*0.65) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:30],NSForegroundColorAttributeName:[UIColor blackColor]}];
//    
//    //画自己想画的内容。。。。。
//    
//    //返回绘制的新图形
//    
//    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//    
//}

- (UIImage *)imageWithTitle:(NSString *)title fontSize:(CGFloat)fontSize {
    UIImage *img = [self GetImageWithColor:[UIColor whiteColor] andHeight:200];
    //画布大小
    CGSize size=CGSizeMake(img.size.width,img.size.height);
    //创建一个基于位图的上下文
    UIGraphicsBeginImageContextWithOptions(size,NO,0.0);//opaque:NO  scale:0.0
    
    [img drawAtPoint:CGPointMake(0.0,0.0)];
    
    //文字居中显示在画布上
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment=NSTextAlignmentCenter;//文字居中
    
    //计算文字所占的size,文字居中显示在画布上
    CGSize sizeText=[title boundingRectWithSize:img.size options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}context:nil].size;
    CGFloat width = img.size.width;
    CGFloat height = img.size.height;
    
    CGRect rect = CGRectMake((width-sizeText.width)/2, (height-sizeText.height)/2, sizeText.width, sizeText.height);
    //绘制文字
    [title drawInRect:rect withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSForegroundColorAttributeName:[ UIColor blackColor],NSParagraphStyleAttributeName:paragraphStyle}];
    
    //返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

// 图片保存到相册掉用，固定写法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存失败");
        [MozTopAlertView showWithType:MozAlertTypeInfo
                                 text:@"保存失败"
                           parentView:self.view];
    }else{
        NSLog(@"保存成功");
        [MozTopAlertView showWithType:MozAlertTypeInfo
                                 text:@"图片已保存至相册"
                           parentView:self.view];
    }
}

// percentage 与 percentStr 的关系
- (NSString *)getPercentStrWithPercentage : (CGFloat)percentage {
    
    NSString *percentStr;
    
    if (percentage <= 0.1) {
        percentStr = [NSString stringWithFormat:@"■□□□□□□□□□ %.1f%%",percentage*100];
    }else if (percentage > 0.1 && percentage <= 0.2){
        percentStr = [NSString stringWithFormat:@"■■□□□□□□□□ %.1f%%",percentage*100];
    }else if (percentage > 0.2 && percentage <= 0.3){
        percentStr = [NSString stringWithFormat:@"■■■□□□□□□□ %.1f%%",percentage*100];
    }else if (percentage > 0.3 && percentage <= 0.4){
        percentStr = [NSString stringWithFormat:@"■■■■□□□□□□ %.1f%%",percentage*100];
    }else if (percentage > 0.4 && percentage <= 0.5){
        percentStr = [NSString stringWithFormat:@"■■■■■□□□□□ %.1f%%",percentage*100];
    }else if (percentage > 0.5 && percentage <= 0.6){
        percentStr = [NSString stringWithFormat:@"■■■■■■□□□□ %.1f%%",percentage*100];
    }else if (percentage > 0.6 && percentage <= 0.7){
        percentStr = [NSString stringWithFormat:@"■■■■■■■□□□ %.1f%%",percentage*100];
    }else if (percentage > 0.7 && percentage <= 0.8){
        percentStr = [NSString stringWithFormat:@"■■■■■■■■□□ %.1f%%",percentage*100];
    }else if (percentage > 0.8 && percentage <= 0.9){
        percentStr = [NSString stringWithFormat:@"■■■■■■■■■□ %.1f%%",percentage*100];
    }else{
        percentStr = [NSString stringWithFormat:@"■■■■■■■■■■ %.1f%%",percentage*100];
    }
    
    return percentStr;
    
}

- (NSString *)getBottomLabelWithPercentage : (CGFloat)percentage {
    
    NSString *bottomLabelText;
    
    if (percentage <= 0.1) {
        bottomLabelText = @"(¦3[▓▓]\n请抓紧，钻被窝睡觉吧";
    }else if (percentage > 0.1 && percentage <= 0.2){
        bottomLabelText = @"(¦3[▓▓]\n请抓紧，钻被窝睡觉吧，再不睡就该起床了";
    }else if (percentage > 0.2 && percentage <= 0.3){
        bottomLabelText = @"..._〆(°▽°*)\n请抓紧，准备准备起床吧";
    }else if (percentage > 0.3 && percentage <= 0.4){
        bottomLabelText = @"٩(｡・ω・｡)﻿و\n请抓紧，决定一下今天都要干什么吧";
    }else if (percentage > 0.4 && percentage <= 0.5){
        bottomLabelText = @"┬─┬ ノ( ' - 'ノ)\n请抓紧，想想午饭吃什么吧";
    }else if (percentage > 0.5 && percentage <= 0.6){
        bottomLabelText = @"(∩^o^)⊃━☆ﾟ.*･｡\n请不要总想着晚上去哪儿玩的事";
    }else if (percentage > 0.6 && percentage <= 0.7){
        bottomLabelText = @"(∩^o^)⊃━☆ﾟ.*･｡\n请不要总想着晚上去哪儿玩的事";
    }else if (percentage > 0.7 && percentage <= 0.8){
        bottomLabelText = @"｡:.ﾟヽ(*´∀`)ﾉﾟ.:｡\n请抓紧，该吃吃该喝喝该锻炼就去锻炼吧";
    }else if (percentage > 0.8 && percentage <= 0.9){
        bottomLabelText = @"（⺻▽⺻ ）\n请抓紧，洗澡上床读书吧\n长得好看就少读会儿，长得丑就多读会儿";
    }else{
        bottomLabelText = @"(¦3[▓▓]\n请抓紧，钻被窝睡觉吧";
    }
    
    return bottomLabelText;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
