//
//  MYCollectionViewCell.m
//  不正经新闻
//
//  Created by 谢风 on 2017/8/27.
//  Copyright © 2017年 Pyrrha. All rights reserved.
//

#import "MYCollectionViewCell.h"

@implementation MYCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.bgImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.bgImageView];
        
        self.titleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.bgImageView.frame = CGRectMake(0, 0,160, 200);
    self.titleLabel.frame = CGRectMake(0, 170, 200, 30);
    
    self.titleLabel.alpha =0.5;
    self.titleLabel.backgroundColor = [UIColor grayColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor blackColor];
    
}
@end
