//
//  LifeView.h
//  PercentAPP
//
//  Created by LiuChanghong on 2017/3/3.
//  Copyright © 2017年 LiuChanghong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STLoopProgressView.h"

@interface LifeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *percentLabel;
@property (weak, nonatomic) IBOutlet STLoopProgressView *loopProgressView;
@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

@end
