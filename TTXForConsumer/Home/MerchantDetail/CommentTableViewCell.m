//
//  CommentTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/20.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "CommentTableViewCell.h"


@implementation BussessComment

+ (id)modelWithDic:(NSDictionary *)dic
{
    BussessComment *model = [[BussessComment alloc]init];
    model.commentId = NullToNumber(dic[@"commentId"]);
    model.consumeTime = NullToNumber(dic[@"consumeTime"]);
    model.createTime = NullToNumber(dic[@"createTime"]);
    model.mchCode = NullToNumber(dic[@"mchCode"]);
    model.mchName = NullToNumber(dic[@"mchName"]);
    model.pic = NullToNumber(dic[@"pic"]);
    model.content = NullToNumber(dic[@"content"]);
    model.userId = NullToNumber(dic[@"userId"]);
    model.userNickName = NullToNumber(dic[@"userNickName"]);
    if ([NullToNumber(dic[@"replyFlag"]) isEqualToString:@"1"]) {
        model.replyFlag = YES;
    }else{
        model.replyFlag = NO;
    }
    model.replyContent = NullToSpace(dic[@"replyContent"]);
    return model;
}

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.time_label.textColor = MacoIntrodouceColor;
    self.detail_label.textColor = MacoTitleColor;
    self.user_name.textColor = MacoDetailColor;
    self.contentView.backgroundColor = [UIColor whiteColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataModel:(BussessComment *)dataModel
{
    _dataModel = dataModel;
    self.user_name.text = [NSString stringWithFormat:@"by %@",_dataModel.userNickName];
    if ([_dataModel.userNickName isEqualToString:@""]) {
        self.user_name.text = @"by 天添薪用户";
    }
    self.detail_label.text = _dataModel.content;
    self.time_label.text = _dataModel.createTime;
    self.repalyView.hidden = !_dataModel.replyFlag;
    self.replayLabel.text = [NSString stringWithFormat:@"商家回复：%@",_dataModel.replyContent];
}

@end
