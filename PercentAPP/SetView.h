//
//  SetView.h
//  PercentAPP
//
//  Created by LiuChanghong on 2017/3/8.
//  Copyright © 2017年 LiuChanghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *agePicker;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
