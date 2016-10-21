//
//  ShakRecordView.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "ShakRecordView.h"

@implementation ShakRecordView


- (instancetype)init
{
    self =[super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"ShakRecordView" owner:nil options:nil][0];
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    [self bringSubviewToFront:self.itemView];
    self.itemView.layer.cornerRadius = 3;
    self.itemView.layer.masksToBounds = YES;
    self.textView.text = @"一个集新闻与娱乐于一体的iOS新闻客户端 。（为增加被搜索到的概率的关键词：News client,新浪新闻客户端，网易新闻，搜狐新闻，搜狐新闻，腾讯新闻，今日头条，百思不得姐，摇一摇夜间模式，视频播放，抓包）点Star，不迷路，项目是持续更新的哦！新手项目，多多包涵，谢谢！";
    
}



- (IBAction)deletBtn:(id)sender {
    
    [self removeFromSuperview];
}
@end
