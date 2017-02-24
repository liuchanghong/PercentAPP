//
//  DayViewController.m
//  PercentAPP
//
//  Created by LiuChanghong on 2017/2/23.
//  Copyright © 2017年 LiuChanghong. All rights reserved.
//

#import "DayViewController.h"
#import "STLoopProgressView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//自定义分享编辑界面所需要导入的头文件
#import <ShareSDKUI/SSUIEditorViewStyle.h>
//#import "UICountingLabel.h"


@interface DayViewController ()
@property (weak, nonatomic) IBOutlet STLoopProgressView *loopProgressView;
@property (nonatomic,strong)NSArray *monthArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelToTop;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (nonatomic) CGFloat percentage;
@property (nonatomic,strong) NSString *percentStr;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@end

@implementation DayViewController

- (IBAction)infoButton:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"要不要加我微信" message:@"HOMGEEK" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"复制到剪贴板" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIPasteboard generalPasteboard] setString:@"homgeek"];
    }];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)dataInit{
    _percentage = [self whichDayIsToday_percent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _labelToTop.constant = (SCREEN_HEIGHT/2 - 150) / 2 - 20;
    
//    UICountingLabel *countingLabel = [[UICountingLabel alloc]initWithFrame:CGRectMake(0, 0, 200, 46)];
//    countingLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-25);
//    countingLabel.textAlignment = NSTextAlignmentCenter;
//    countingLabel.textColor = [UIColor whiteColor];
//    countingLabel.font = GHFont(30);
//    [self.view addSubview:countingLabel];
//    countingLabel.format = @"%.6f %%";
//    [countingLabel countFrom:0.000000 to: _percentage*100 withDuration:2.0f];
    
    [self dataInit];
    self.loopProgressView.persentage = _percentage;
    _percentLabel.text = [NSString stringWithFormat:@"%.6f %%",_percentage*100];
    if (_percentage <= 0.1) {
        _percentStr = [NSString stringWithFormat:@"■□□□□□□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"(¦3[▓▓]\n请抓紧，钻被窝睡觉吧";
    }else if (_percentage > 0.1 && _percentage <= 0.2){
        _percentStr = [NSString stringWithFormat:@"■■□□□□□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"(¦3[▓▓]\n请抓紧，钻被窝睡觉吧";
    }else if (_percentage > 0.2 && _percentage <= 0.3){
        _percentStr = [NSString stringWithFormat:@"■■■□□□□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"..._〆(°▽°*)\n请抓紧，准备准备起床吧";
    }else if (_percentage > 0.3 && _percentage <= 0.4){
        _percentStr = [NSString stringWithFormat:@"■■■■□□□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"٩(｡・ω・｡)﻿و\n请抓紧，决定一下今天都要干什么吧";
    }else if (_percentage > 0.4 && _percentage <= 0.5){
        _percentStr = [NSString stringWithFormat:@"■■■■■□□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"┬─┬ ノ( ' - 'ノ)\n请抓紧，想想午饭吃什么吧";
    }else if (_percentage > 0.5 && _percentage <= 0.6){
        _percentStr = [NSString stringWithFormat:@"■■■■■■□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"┌(ㆆ㉨ㆆ)ʃ\n请抓紧，精神一下继续努力吧";
    }else if (_percentage > 0.6 && _percentage <= 0.7){
        _percentStr = [NSString stringWithFormat:@"■■■■■■■□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"(∩^o^)⊃━☆ﾟ.*･｡\n请不要总想着晚上去哪儿玩的事";
    }else if (_percentage > 0.7 && _percentage <= 0.8){
        _percentStr = [NSString stringWithFormat:@"■■■■■■■■□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"｡:.ﾟヽ(*´∀`)ﾉﾟ.:｡\n请抓紧，该吃吃该喝喝该锻炼就去锻炼吧";
    }else if (_percentage > 0.8 && _percentage <= 0.9){
        _percentStr = [NSString stringWithFormat:@"■■■■■■■■■□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"（⺻▽⺻ ）\n请抓紧，洗澡上床读书吧\n长得好看就少读会儿，长得丑就多读会儿";
    }else{
        _percentStr = [NSString stringWithFormat:@"■■■■■■■■■■ %.2f%%",_percentage*100];
        _bottomLabel.text = @"(¦3[▓▓]\n请抓紧，钻被窝睡觉吧";
    }
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(everySecond) userInfo:nil repeats:YES];
    //更改模式
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void)everySecond{
    [self dataInit];
    self.loopProgressView.persentage = _percentage;
    _percentLabel.text = [NSString stringWithFormat:@"%.6f %%",_percentage*100];
    if (_percentage <= 0.1) {
        _percentStr = [NSString stringWithFormat:@"■□□□□□□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"(¦3[▓▓]\n请抓紧，钻被窝睡觉吧";

    }else if (_percentage > 0.1 && _percentage <= 0.2){
        _percentStr = [NSString stringWithFormat:@"■■□□□□□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"(¦3[▓▓]\n请抓紧，钻被窝睡觉吧";

    }else if (_percentage > 0.2 && _percentage <= 0.3){
        _percentStr = [NSString stringWithFormat:@"■■■□□□□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"..._〆(°▽°*)\n请抓紧，准备准备起床吧";

    }else if (_percentage > 0.3 && _percentage <= 0.4){
        _percentStr = [NSString stringWithFormat:@"■■■■□□□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"٩(｡・ω・｡)﻿و\n请抓紧，决定一下今天都要干什么吧";

    }else if (_percentage > 0.4 && _percentage <= 0.5){
        _percentStr = [NSString stringWithFormat:@"■■■■■□□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"┬─┬ ノ( ' - 'ノ)\n请抓紧，想想午饭吃什么吧";

    }else if (_percentage > 0.5 && _percentage <= 0.6){
        _percentStr = [NSString stringWithFormat:@"■■■■■■□□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"┌(ㆆ㉨ㆆ)ʃ\n请抓紧，精神一下继续努力吧";

    }else if (_percentage > 0.6 && _percentage <= 0.7){
        _percentStr = [NSString stringWithFormat:@"■■■■■■■□□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"(∩^o^)⊃━☆ﾟ.*･｡\n请不要总想着晚上去哪儿玩的事";

    }else if (_percentage > 0.7 && _percentage <= 0.8){
        _percentStr = [NSString stringWithFormat:@"■■■■■■■■□□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"｡:.ﾟヽ(*´∀`)ﾉﾟ.:｡\n请抓紧，该吃吃该喝喝该锻炼就去锻炼吧";

    }else if (_percentage > 0.8 && _percentage <= 0.9){
        _percentStr = [NSString stringWithFormat:@"■■■■■■■■■□ %.2f%%",_percentage*100];
        _bottomLabel.text = @"（⺻▽⺻ ）\n请抓紧，洗澡上床读书吧\n长得好看就少读会儿，长得丑就多读会儿";

    }else{
        _percentStr = [NSString stringWithFormat:@"■■■■■■■■■■ %.2f%%",_percentage*100];
        _bottomLabel.text = @"(¦3[▓▓]\n请抓紧，钻被窝睡觉吧";

    }
}

- (IBAction)shareButtonClick:(id)sender {
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"day-black.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"‵(*∩_∩*)′ 獻上我最可愛的笑容"]
                                         images:imageArray
                                            url:[NSURL URLWithString:@"https://liuchanghong.github.io/"]
                                          title:[NSString stringWithFormat:@"今天已经过去了\n%@",_percentStr]
                                           type:SSDKContentTypeApp];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        
        // 设置分享菜单的背景颜色
        //        [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];//大背景
        // 设置分享菜单颜色
        [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
        // 设置分享菜单－取消按钮背景颜色
        [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
        // 设置分享菜单－取消按钮的文本颜色
        [SSUIShareActionSheetStyle setCancelButtonLabelColor:[UIColor whiteColor]];
        // 设置分享菜单－社交平台文本颜色
        [SSUIShareActionSheetStyle setItemNameColor:[UIColor whiteColor]];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:@[
                                         @(SSDKPlatformSubTypeWechatSession),
                                         @(SSDKPlatformSubTypeWechatTimeline)
                                         ]
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];
    }
}

//获取系统年月日时分秒
- (NSArray *)getSystemTime {
    //获取当前时间
    NSDate *date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:sec];
    //设置时间输出格式
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"HH-mm-ss"];
    NSString *cTime = [df stringFromDate:currentDate];
    NSArray *timeArray = [NSArray array];
    timeArray = [cTime componentsSeparatedByString:@"-"];
    return  timeArray;
    
}

//判断是否为闰年
//-(BOOL)isLeapYearOrNot:(NSInteger)year{
//    //判断是否闰年
//    if (year % 400 == 0) {
//        return YES;
//    }else if (year % 4 == 0 && year % 100 != 0){
//        return YES;
//    }else {
//        return NO;
//    }
//}

//计算此时是今日的啥时候
- (float)whichDayIsToday_percent{
    NSArray *timeArray = [self getSystemTime];
    NSString *hourStr = timeArray[0];
    int hourInt = hourStr.intValue;
    NSString *minuteStr = timeArray[1];
    int minuteInt = minuteStr.intValue;
    NSString *secondStr = timeArray[2];
    int secondInt = secondStr.intValue;
    NSLog(@"%@-%@-%@",hourStr,minuteStr,secondStr);
    //现在是第几秒
    int howMucSecond = hourInt * 3600 + minuteInt *60 + secondInt;
    
    return howMucSecond/86400.0;
    
}

//- (IBAction)sliderValueChanged:(UISlider *)sender {
////    NSLog(@"%f",sender.value);
//    self.loopProgressView.persentage = sender.value;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
