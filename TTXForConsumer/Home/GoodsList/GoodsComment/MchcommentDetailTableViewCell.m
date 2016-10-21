//
//  BussesscommentDetailTableViewCell.m
//  天添薪
//
//  Created by ttx on 16/1/6.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MchcommentDetailTableViewCell.h"


@implementation MchComment

+ (id)modelWithDic:(NSDictionary *)dic
{
    MchComment *model = [[MchComment alloc]init];
    model.commentId = NullToNumber(dic[@"id"]);
    model.goodsId = NullToNumber(dic[@"goodsId"]);
    model.commentTime = NullToSpace(dic[@"commentTime"]);
    model.content = NullToSpace(dic[@"content"]);
    model.userNickName = NullToSpace(dic[@"userNickName"]);

    model.specStr = NullToSpace(dic[@"specStr"]);
    return model;
}

@end

@implementation MchcommentDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.time_label.textColor = MacoIntrodouceColor;
    self.guigeLabel.textColor = MacoIntrodouceColor;
    self.user_name.textColor = MacoDetailColor;
    self.detail_label.textColor = MacoTitleColor;
    self.contentView.backgroundColor = [UIColor whiteColor];

}

- (void)setDataModel:(MchComment *)dataModel
{
    _dataModel = dataModel;
    self.user_name.text = [NSString stringWithFormat:@"by %@",_dataModel.userNickName];

    if ([_dataModel.userNickName isEqualToString:@""]) {
       self.user_name.text = @"by 天添薪用户";
    }
    self.detail_label.text = _dataModel.content;
    self.time_label.text = _dataModel.commentTime;
    
    self.guigeLabel.text = _dataModel.specStr;
}


@end
