//
//  AppDelegate.m
//  PercentAPP
//
//  Created by LiuChanghong on 2017/2/21.
//  Copyright © 2017年 LiuChanghong. All rights reserved.
//
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
#import "WeiboSDK.h"
#import "MyLeftView.h"
#import "UIView+leoAdd.h"
#import "PSDrawerManager.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    //初始化 leftView
    MyLeftView *leftView = [[NSBundle mainBundle] loadNibNamed:@"MyLeftView" owner:nil options:nil][0];
    
    //设置 leftView 的 frame
    leftView.frame = CGRectMake(-self.window.width * (1 - kLeftWidthScale), 0, self.window.width, self.window.height);
    
    //获取 mainStoryboard
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //获取 sb 中的 MyTabbarController
    UITabBarController *tabBarVC = [sb instantiateViewControllerWithIdentifier:@"MyTabbarController"];
    
    //PSDrawerManager 单例，install 主视图和左视图
    [[PSDrawerManager instance] installCenterViewController:tabBarVC leftView:leftView];
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    [ShareSDK registerApp:@"1b857e0e7994d"
     
          activePlatforms:@[
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy)
                            ]
     
                 onImport:^(SSDKPlatformType platformType)
     
     {
         
         switch (platformType)
         
         {
                 
             case SSDKPlatformTypeWechat:
                 
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 
                 break;
                 
             case SSDKPlatformTypeSinaWeibo:
                 
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 
                 break;
                 
             case SSDKPlatformTypeQQ:
                 
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 
                 break;
                 
             default:
                 
                 break;
                 
         }
         
     }
     
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     
     {
         
         switch (platformType)
         
         {
                 
            case SSDKPlatformTypeWechat:
                 
                 [appInfo SSDKSetupWeChatByAppId:@"wxd3750c0ff3ec574d"
                                       appSecret:@"7235a6c2a5b46b8846272f313b43ac3d"];
                 
                 break;
                 
             case SSDKPlatformTypeSinaWeibo:
                 
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"1793527049"
                                           appSecret:@"82a315c6c25f698291b8a62e2914bc42"
                                         redirectUri:@"https://liuchanghong.github.io"
                                            authType:SSDKAuthTypeBoth];
                 
                 break;
                 
             case SSDKPlatformTypeQQ:
                 
                 [appInfo SSDKSetupQQByAppId:@"1106008938"
                                      appKey:@"aRbSvpJhXq2EjrQY"
                                    authType:SSDKAuthTypeBoth];
                 
                 break;
                 
            default:
                 
                 break;
                 
         }
         
     }];
    
    return YES;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
