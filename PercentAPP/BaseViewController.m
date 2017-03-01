//
//  BaseViewController.m
//  GoldenMapApp
//
//  Created by LiuChanghong on 16/2/25.
//  Copyright © 2016年 GuanYiHengXin. All rights reserved.
//

#import "BaseViewController.h"
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

//-(void)makeCehua{
//    id target = self.navigationController.interactivePopGestureRecognizer.delegate;
//    
//    // handleNavigationTransition:为系统私有API,即系统自带侧滑手势的回调方法，我们在自己的手势上直接用它的回调方法
//    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
//    panGesture.delegate = self; // 设置手势代理，拦截手势触发
//    [self.view addGestureRecognizer:panGesture];
//    
//    // 一定要禁止系统自带的滑动手势
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//}
//
//// 什么时候调用，每次触发手势之前都会询问下代理方法，是否触发
//// 作用：拦截手势触发
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    // 当当前控制器是根控制器时，不可以侧滑返回，所以不能使其触发手势
//    if(self.navigationController.childViewControllers.count == 1)
//    {
//        return NO;
//    }
//    
//    if ([self.navigationController.viewControllers[0] isKindOfClass:[BaiduMapViewController class]]) {
//        return NO;
//    }
//    
//    return YES;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
