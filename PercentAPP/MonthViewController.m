//
//  MonthViewController.m
//  PercentAPP
//
//  Created by LiuChanghong on 2017/2/23.
//  Copyright © 2017年 LiuChanghong. All rights reserved.
//

#import "MonthViewController.h"
#import "STLoopProgressView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//自定义分享编辑界面所需要导入的头文件
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import "UICountingLabel.h"
#import "MozTopAlertView.h"
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>


@interface MonthViewController ()
@property (weak, nonatomic) IBOutlet STLoopProgressView *loopProgressView;
@property (nonatomic)BOOL isLeapYear;//YES 为闰年，NO 为平年
@property (nonatomic,strong)NSArray *monthArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelToTop;
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (nonatomic) CGFloat percentage;
@property (nonatomic,strong) NSString *percentStr;
@property (nonatomic,strong) NSString *whichMonthString;
@end

@implementation MonthViewController
- (IBAction)infoButtonClick:(id)sender {
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
    _isLeapYear = NO;
    _percentage = [self whichDayIsToday_percent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dataInit];
    _labelToTop.constant = (SCREEN_HEIGHT/2 - 150) / 2 - 20;
    self.loopProgressView.persentage = _percentage;
    UICountingLabel *countingLabel = [[UICountingLabel alloc]initWithFrame:CGRectMake(0, 0, 200, 46)];
    countingLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-25);
    countingLabel.textAlignment = NSTextAlignmentCenter;
    countingLabel.textColor = HexRGB(0xefe7d8);
    countingLabel.font = GHFont(30);
    [self.view addSubview:countingLabel];
    countingLabel.format = @"%.6f %%";
    [countingLabel countFrom:0.000000 to: _percentage*100 withDuration:2.0f];
    
    //_percentStr 为分享时显示的 @"■□□□□□□□□□ %.1f%%" 内容
    _percentStr = [self getPercentStrWithPercentage:_percentage];
    
}
- (IBAction)shareButtonClick:(id)sender {
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"month-1.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"本月已经过去了\n%@",_percentStr]
                                         images:[self imageWithTitle:_whichMonthString fontSize:35]
                                            url:[NSURL URLWithString:@"https://liuchanghong.github.io/"]
                                          title:[NSString stringWithFormat:@"本月已经过去了\n%@",_percentStr]
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
                                                                                            [[UIPasteboard generalPasteboard] setString:[NSString stringWithFormat:@"本月已经过去了\n%@",_percentStr]];
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
                                                                                                 UIImage *img = [self imageWithTitle:[NSString stringWithFormat:@"本月已经过去了\n%@",_percentStr] fontSize:10];
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
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *cTime = [df stringFromDate:currentDate];
    NSArray *timeArray = [NSArray array];
    timeArray = [cTime componentsSeparatedByString:@"-"];
    return  timeArray;
    
}

//判断是否为闰年
-(BOOL)isLeapYearOrNot:(NSInteger)year{
    //判断是否闰年
    if (year % 400 == 0) {
        return YES;
    }else if (year % 4 == 0 && year % 100 != 0){
        return YES;
    }else {
        return NO;
    }
}

//计算今日是本月的第几天
- (float)whichDayIsToday_percent{
    NSArray *timeArray = [self getSystemTime];
    NSString *yearStr = timeArray[0];
    int yearInt = yearStr.intValue;
    NSString *monthStr = timeArray[1];
    int monthInt = monthStr.intValue;
    NSString *dayStr = timeArray[2];
    int dayInt = dayStr.intValue;
    
    _whichMonthString = [NSString stringWithFormat:@"%@月%@日",monthStr,dayStr];
    
    _isLeapYear = [self isLeapYearOrNot:yearInt];
    
    int whichDay = 0;
    
    if (_isLeapYear) {
        _monthArray = @[@"31",@"29",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];
        whichDay = dayInt;
        NSString *mStr = _monthArray[monthInt-1];
        float m = mStr.floatValue;
        return whichDay/m;
    }else{
        _monthArray = @[@"31",@"28",@"31",@"30",@"31",@"30",@"31",@"31",@"30",@"31",@"30",@"31"];
        whichDay = dayInt;
        NSString *mStr = _monthArray[monthInt-1];
        float m = mStr.floatValue;
        return whichDay/m;
    }
    
}

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
