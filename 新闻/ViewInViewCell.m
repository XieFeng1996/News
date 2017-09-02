//
//  ViewInViewCell.m
//  不正经新闻
//
//  Created by 谢风 on 2017/8/31.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "ViewInViewCell.h"

@implementation ViewInViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundImage = [[UIImageView alloc]init];
        [self.contentView addSubview:self.backgroundImage];
        
        self.label = [[UILabel alloc]init];
        [self.contentView addSubview:self.label];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundImage.frame = CGRectMake(0, 0,100, 100);
    self.label.frame = CGRectMake(0, 80, 100,20);
    
    self.label.alpha =0.5;
    self.label.backgroundColor = [UIColor grayColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.textColor = [UIColor blackColor];
}
@end
