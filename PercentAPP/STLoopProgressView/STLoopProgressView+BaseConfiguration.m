//
//  STLoopProgressView+BaseConfiguration.m
//  STLoopProgressView
//
//  Created by TangJR on 7/1/15.
//  Copyright (c) 2015 tangjr. All rights reserved.
//

#import "STLoopProgressView+BaseConfiguration.h"
#import "BaseViewController.h"

#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度

@implementation STLoopProgressView (BaseConfiguration)

+ (UIColor *)startColor {
    
    return HexRGB(0xEFFEDBC);
}

+ (UIColor *)centerColor {
    
    return HexRGB(0xf5928d);
}

+ (UIColor *)endColor {
    
    return HexRGB(0xED4264);
}

+ (UIColor *)backgroundColor {
    
    return [UIColor colorWithRed:38.0 / 255.0 green:130.0 / 255.0 blue:213.0 / 255.0 alpha:0.5];
}

+ (CGFloat)lineWidth {
    
    return 20;
}

+ (CGFloat)startAngle {
    
    return DEGREES_TO_RADOANS(-240);
}

+ (CGFloat)endAngle {
    
    return DEGREES_TO_RADOANS(60);
}

+ (STClockWiseType)clockWiseType {
    return STClockWiseNo;
}

@end
