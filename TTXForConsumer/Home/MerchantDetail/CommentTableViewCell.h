//
//  CommentTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/20.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BussessComment : BaseModel

//评论id： id;
//消费时间: consumeTime;
//评论时间：createTime；
//商户号：mchCode;
//商户名称：mchName;
//商户头像：pic;
//评论内容：content;
//用户id：userId
@property (nonatomic, copy)NSString *commentId;
@property (nonatomic, copy)NSString *consumeTime;
@property (nonatomic, copy)NSString *createTime;
@property (nonatomic, copy)NSString *mchCode;
@property (nonatomic, copy)NSString *mchName;
@property (nonatomic, copy)NSString *pic;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *userId;
@property (nonatomic, copy)NSString *userNickName;

//是否已经回复
@property (nonatomic, assign)BOOL replyFlag;
//回复详细内容
@property (nonatomic,copy)NSString *replyContent;

@end

@interface CommentTableViewCell : BaseTableViewCell

@property (nonatomic, strong)BussessComment *dataModel;

@property (weak, nonatomic) IBOutlet UILabel *user_name;

@property (weak, nonatomic) IBOutlet UILabel *time_label;

@property (weak, nonatomic) IBOutlet UILabel *detail_label;


@property (weak, nonatomic) IBOutlet UIView *repalyView;

@property (weak, nonatomic) IBOutlet UILabel *replayLabel;

@end
