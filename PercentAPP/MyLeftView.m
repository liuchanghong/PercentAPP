//
//  MyLeftView.m
//  PercentAPP
//
//  Created by LiuChanghong on 2017/3/3.
//  Copyright © 2017年 LiuChanghong. All rights reserved.
//

#import "MyLeftView.h"
#import "BaseViewController.h"
#import "PSDrawerManager.h"
#import "LifeView.h"
#import "SetView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
// 自定义分享菜单栏需要导入的头文件
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//自定义分享编辑界面所需要导入的头文件
#import <ShareSDKUI/SSUIEditorViewStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import "MozTopAlertView.h"


#define kAppDelegate [[UIApplication sharedApplication] delegate]
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface MyLeftView () <UIPickerViewDelegate,UIPickerViewDataSource>
{
    int m;
}
@property (nonatomic,strong) LifeView *lifeView;
@property (nonatomic,strong) SetView *setView;
@property (nonatomic) NSInteger endAge;
@property (nonatomic) NSInteger nowAge;


@end

@implementation MyLeftView

- (instancetype)init
{
    self = [super init];
    if (self) {
        m = 0;
    }
    return self;
}

//日常button
- (IBAction)richangButtonClick:(id)sender {
    [[PSDrawerManager instance] resetShowType:PSDrawerManagerShowCenter];
    if (m == 2) {
        [_lifeView setHidden:YES];
        m = 1;
    }
}

//人生button
- (IBAction)renshengButtonClick:(id)sender {
    [[PSDrawerManager instance] resetShowType:PSDrawerManagerShowCenter];
    if (m == 0) {
        _lifeView = [[NSBundle mainBundle]loadNibNamed:@"LifeView" owner:nil options:nil][0];
        _lifeView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self getPercent];
        [[PSDrawerManager instance].centerViewController.view addSubview:_lifeView];
        m = 1;
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSLog(@"%ld",(long)[userDefault integerForKey:@"endAge"]);
        _setView = [[NSBundle mainBundle]loadNibNamed:@"SetView" owner:nil options:nil][0];
        _setView.frame = CGRectMake(0, 0, 300, 300);
        _setView.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2);
        _setView.layer.cornerRadius = 10;
        _setView.layer.masksToBounds = YES;
        _setView.agePicker.dataSource = self;
        _setView.agePicker.delegate = self;
        if ([userDefault integerForKey:@"endAge"]) {
            _lifeView.topLabel.text = [NSString stringWithFormat:@"你的期望寿命为 %li 岁\n至今已经度过了大约",(long)[userDefault integerForKey:@"endAge"]];
            _endAge = [userDefault integerForKey:@"endAge"];
            _setView.hidden = YES;
        }else{
            _setView.hidden = NO;
            _lifeView.topLabel.text = @"你的期望寿命为 60 岁\n至今已经度过了大约";
            _endAge = 60;
        }
        [_setView.agePicker setValue:HexRGB(0xefe7d8) forKey:@"textColor"];
        [_setView.datePicker setValue:HexRGB(0xefe7d8) forKey:@"textColor"];
        [_lifeView addSubview:_setView];
        [_lifeView.menuButton addTarget:self action:@selector(menuButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_lifeView.setButton addTarget:self action:@selector(setButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_lifeView.shareButton addTarget:self action:@selector(shareButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_setView.okButton addTarget:self action:@selector(okButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_setView.nextPageButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_setView.previousButton addTarget:self action:@selector(prieviousButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    if (m == 1) {
        [_lifeView setHidden:NO];
        m = 2;
    }
}

//计算百分比
-(void)getPercent {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault integerForKey:@"endAge"]) {
        _endAge = [userDefault integerForKey:@"endAge"];
        
    }else{
        _endAge = 60;
    }
    _nowAge = [userDefault integerForKey:@"nowAge"];
    NSString *nowAgeStr = [NSString stringWithFormat:@"%li.0",(long)_nowAge];
    float nowFloatAge = nowAgeStr.floatValue;
    _lifeView.percentLabel.text = [NSString stringWithFormat:@"%.6f %%",nowFloatAge / _endAge * 100];
    _lifeView.loopProgressView.persentage = nowFloatAge / _endAge;
}

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

-(void)shareButtonClick {
    
    float percentage = _lifeView.loopProgressView.persentage;
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
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSInteger endAgeInteger = [userDefault integerForKey:@"endAge"];
    
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"year-1.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"若活到%li岁，我人生已经度过\n%@",endAgeInteger,percentStr]
                                         images:[self imageWithTitle:[NSString stringWithFormat:@"%ld岁",(long)endAgeInteger] fontSize:35]
                                            url:[NSURL URLWithString:@"https://liuchanghong.github.io/"]
                                          title:[NSString stringWithFormat:@"若活到%li岁，我人生已经度过\n%@",endAgeInteger,percentStr]
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
                                                                                                   UIGraphicsBeginImageContextWithOptions(_lifeView.frame.size, NO, 0);
                                                                                                   CGContextRef ctx = UIGraphicsGetCurrentContext();
                                                                                                   // 将要保存的view绘制到上下文中
                                                                                                   [_lifeView.layer renderInContext:ctx];
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
                                                                                            [[UIPasteboard generalPasteboard] setString:[NSString stringWithFormat:@"假如活到%li岁，我的人生已经度过了\n%@",endAgeInteger,percentStr]];
                                                                                            [MozTopAlertView showWithType:MozAlertTypeInfo
                                                                                                                     text:@"复制成功"
                                                                                                               parentView:_lifeView];
                                                                                            
                                                                                        }];
        //添加CopyToIMG
        SSUIShareActionSheetCustomItem *itemCopyToIMG = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"copyToImg.png"]
                                                                                               label:@"文字转图片"
                                                                                             onClick:^{
                                                                                                 //自定义item被点击的处理逻辑
                                                                                                 //                                                                                                   [[UIPasteboard generalPasteboard] setString:[NSString stringWithFormat:@"今年已经过去了\n%@",percentStr]];
                                                                                                 //                                                                                                   [MozTopAlertView showWithType:MozAlertTypeInfo
                                                                                                 //                                                                                                                            text:@"复制成功"
                                                                                                 //                                                                                                                      parentView:self.view];
                                                                                                 UIImage *img = [self imageWithTitle:[NSString stringWithFormat:@"假如活到%li岁，我的人生已经度过了\n%@",endAgeInteger,percentStr] fontSize:10];
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
                                                                                          parentView:self];
                                                                       break;
                                                                   case SSDKResponseStateFail:
                                                                       NSLog(@"分享失败%@",error);
                                                                       [MozTopAlertView showWithType:MozAlertTypeInfo
                                                                                                text:@"分享失败"
                                                                                          parentView:self];
                                                                       break;
                                                                   case SSDKResponseStateCancel:
                                                                       NSLog(@"分享已取消");
                                                                       [MozTopAlertView showWithType:MozAlertTypeInfo
                                                                                                text:@"分享已取消"
                                                                                          parentView:self];
                                                                       break;
                                                                   default:
                                                                       break;
                                                               }
                                                           }];
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    }

}

// 图片保存到相册掉用，固定写法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        NSLog(@"保存失败");
        [MozTopAlertView showWithType:MozAlertTypeInfo
                                 text:@"保存失败"
                           parentView:_lifeView];
    }else{
        NSLog(@"保存成功");
        [MozTopAlertView showWithType:MozAlertTypeInfo
                                 text:@"图片已保存至相册"
                           parentView:_lifeView];
    }
}

-(void)menuButtonClick {
    self.transform = CGAffineTransformTranslate(self.transform, 100, 0);
}

//上一页button
-(void)prieviousButtonClick {
    [_setView.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

//下一页button
-(void)nextButtonClick {
    NSDate *date = _setView.datePicker.date;
   _nowAge = [self ageWithDateOfBirth:date];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:_nowAge forKey:@"nowAge"];
    [userDefault synchronize];
    
    NSLog(@"%li",(long)[self ageWithDateOfBirth:date]);
    [_setView.scrollView setContentOffset:CGPointMake(300, 0) animated:YES];
}

//设置button
-(void)setButtonClick {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSLog(@"%li",[userDefault integerForKey:@"endAge"]);
    [_setView setHidden:NO];
}

//完成button
-(void)okButtonClick {
    [_setView setHidden:YES];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    if ([userDefault integerForKey:@"endAge"]) {
        _lifeView.topLabel.text = [NSString stringWithFormat:@"你的期望寿命为 %li 岁\n至今已经度过了大约",(long)[userDefault integerForKey:@"endAge"]];
        _endAge = [userDefault integerForKey:@"endAge"];
        [self getPercent];
    }else{
        [userDefault setInteger:60 forKey:@"endAge"];
        [userDefault synchronize];
        _lifeView.topLabel.text = @"你的期望寿命为 60 岁\n至今已经度过了大约";
        _endAge = 60;
        [self getPercent];
    }
}

//计算目前的年龄
- (NSInteger)ageWithDateOfBirth:(NSDate *)date;
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    
    return iAge;
}

#pragma mark delegate & datasource

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 61;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%li",(long)row+60];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setInteger:row+60 forKey:@"endAge"];
    [userDefault synchronize];
    NSLog(@"%ld",(long)[userDefault integerForKey:@"endAge"]);
}

//获取view的controller
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
