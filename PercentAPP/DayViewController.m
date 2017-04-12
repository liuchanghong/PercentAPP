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
#import "MozTopAlertView.h"
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>


@interface DayViewController ()
@property (weak, nonatomic) IBOutlet STLoopProgressView *loopProgressView;
@property (nonatomic,strong)NSArray *monthArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelToTop;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (nonatomic) CGFloat percentage;
@property (nonatomic,strong) NSString *percentStr;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (nonatomic,strong) NSString *whichTimeStr;
@end

@implementation DayViewController

- (IBAction)infoButton:(id)sender {
    [MozTopAlertView showWithType:MozAlertTypeInfo
                             text:@"要不要加我微信?"
                           doText:@"复制到剪贴板"
                          doBlock:^{
                              [[UIPasteboard generalPasteboard] setString:@"HOMGEEK"];
                              [MozTopAlertView showWithType:MozAlertTypeInfo
                                                       text:@"复制成功，去粘贴吧"
                                                 parentView:self.view];
                              
                          }
                       parentView:self.view];
}

-(void)dataInit{
    
    _percentage = [self whichDayIsToday_percent];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _labelToTop.constant = (SCREEN_HEIGHT / 2 - 150) / 2 - 20;
    
    [self dataInit];
    
    self.loopProgressView.persentage = _percentage;
    
    _percentLabel.text = [NSString stringWithFormat:@"%.6f %%",_percentage*100];
    
    //_percentStr 为分享时显示的 @"■□□□□□□□□□ %.1f%%" 内容
    _percentStr = [self getPercentStrWithPercentage:_percentage];
    
    _bottomLabel.text = [self getBottomLabelWithPercentage:_percentage];
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(everySecond) userInfo:nil repeats:YES];
    
    //更改模式
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
}

-(void)everySecond{
    
    [self dataInit];
    
    self.loopProgressView.persentage = _percentage;
    
    _percentLabel.text = [NSString stringWithFormat:@"%.6f %%",_percentage*100];
    
    //_percentStr 为分享时显示的 @"■□□□□□□□□□ %.1f%%" 内容
    _percentStr = [self getPercentStrWithPercentage:_percentage];
    
    _bottomLabel.text = [self getBottomLabelWithPercentage:_percentage];
    
}

- (IBAction)shareButtonClick:(id)sender {
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"day-1.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"今天已经过去了\n%@",_percentStr]
                                         images:[self imageWithTitle:_whichTimeStr fontSize:35]
                                            url:[NSURL URLWithString:@"https://liuchanghong.github.io/"]
                                          title:[NSString stringWithFormat:@"今天已经过去了\n%@",_percentStr]
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        // 设置分享菜单的背景颜色
        //        [SSUIShareActionSheetStyle setActionSheetBackgroundColor:[UIColor colorWithRed:249/255.0 green:0/255.0 blue:12/255.0 alpha:0.5]];//大背景
        // 设置分享菜单颜色
        [SSUIShareActionSheetStyle setActionSheetColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
        // 设置分享菜单－取消按钮背景颜色
        [SSUIShareActionSheetStyle setCancelButtonBackgroundColor:[UIColor colorWithRed:21.0/255.0 green:21.0/255.0 blue:21.0/255.0 alpha:1.0]];
        // 设置分享菜单－取消按钮的文本颜色
        [SSUIShareActionSheetStyle setCancelButtonLabelColor:HexRGB(0xefe7d8)];
        // 设置分享菜单－社交平台文本颜色
        [SSUIShareActionSheetStyle setItemNameColor:HexRGB(0xefe7d8)];
        //设置分享编辑界面的导航栏颜色
        [SSUIEditorViewStyle setiPhoneNavigationBarBackgroundColor:[UIColor blackColor]];
        //设置编辑界面标题颜色
        [SSUIEditorViewStyle setTitleColor:HexRGB(0xefe7d8)];
        //设置取消发布标签文本颜色
        [SSUIEditorViewStyle setCancelButtonLabelColor:HexRGB(0xefe7d8)];
        [SSUIEditorViewStyle setShareButtonLabelColor:HexRGB(0xefe7d8)];
        //添加屏幕截图
        SSUIShareActionSheetCustomItem *itemScreenShoot = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"shootScreen2.png"]
                                                                                                 label:@"截屏保存"
                                                                                               onClick:^{
                                                                                                   //自定义item被点击的处理逻辑
                                                                                                   NSLog(@"=== 自定义item被点击 ===");
                                                                                                   UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0);
                                                                                                   CGContextRef ctx = UIGraphicsGetCurrentContext();
                                                                                                   // 将要保存的view绘制到上下文中
                                                                                                   [self.view.layer renderInContext:ctx];
                                                                                                   UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
                                                                                                   UIGraphicsEndImageContext();
                                                                                                   // 将图片保存到相册
                                                                                                   UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                                                                               }];
        //添加Copy
        SSUIShareActionSheetCustomItem *itemCopy = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"copy.png"]
                                                                                          label:@"复制文字"
                                                                                        onClick:^{
                                                                                            //                                                                                                   自定义item被点击的处理逻辑
                                                                                            [[UIPasteboard generalPasteboard] setString:[NSString stringWithFormat:@"今天已经过去了\n%@",_percentStr]];
                                                                                            [MozTopAlertView showWithType:MozAlertTypeInfo
                                                                                                                     text:@"复制成功"
                                                                                                               parentView:self.view];
                                                                                            
                                                                                        }];
        //添加CopyToIMG
        SSUIShareActionSheetCustomItem *itemCopyToIMG = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"copyToImg.png"]
                                                                                               label:@"文字转图片"
                                                                                             onClick:^{
                                                                                                 //自定义item被点击的处理逻辑
                                                                                                 //                                                                                                   [[UIPasteboard generalPasteboard] setString:[NSString stringWithFormat:@"今年已经过去了\n%@",_percentStr]];
                                                                                                 //                                                                                                   [MozTopAlertView showWithType:MozAlertTypeInfo
                                                                                                 //                                                                                                                            text:@"复制成功"
                                                                                                 //                                                                                                                      parentView:self.view];
                                                                                                 UIImage *img = [self imageWithTitle:[NSString stringWithFormat:@"今天已经过去了\n%@",_percentStr] fontSize:10];
                                                                                                 UIImageWriteToSavedPhotosAlbum(img, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
                                                                                             }];
        //调用分享的方法
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:nil
                                                                         items:@[
                                                                                 @(SSDKPlatformSubTypeWechatSession),
                                                                                 @(SSDKPlatformSubTypeWechatTimeline),
                                                                                 @(SSDKPlatformTypeSinaWeibo),
                                                                                 @(SSDKPlatformTypeQQ),
                                                                                 itemScreenShoot,
                                                                                 itemCopy,
                                                                                 itemCopyToIMG
                                                                                 ]
                                                                   shareParams:shareParams
                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                               switch (state) {
                                                                   case SSDKResponseStateSuccess:
                                                                       NSLog(@"分享成功!");
                                                                       [MozTopAlertView showWithType:MozAlertTypeInfo
                                                                                                text:@"分享成功"
                                                                                          parentView:self.view];
                                                                       break;
                                                                   case SSDKResponseStateFail:
                                                                       NSLog(@"分享失败%@",error);
                                                                       [MozTopAlertView showWithType:MozAlertTypeInfo
                                                                                                text:@"分享失败"
                                                                                          parentView:self.view];
                                                                       break;
                                                                   case SSDKResponseStateCancel:
                                                                       NSLog(@"分享已取消");
                                                                       [MozTopAlertView showWithType:MozAlertTypeInfo
                                                                                                text:@"分享已取消"
                                                                                          parentView:self.view];
                                                                       break;
                                                                   default:
                                                                       break;
                                                               }
                                                           }];
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
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
    _whichTimeStr = [NSString stringWithFormat:@"%@点%@分",hourStr,minuteStr];
    //现在是第几秒
    int howMucSecond = hourInt * 3600 + minuteInt *60 + secondInt;
    return howMucSecond/86400.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
