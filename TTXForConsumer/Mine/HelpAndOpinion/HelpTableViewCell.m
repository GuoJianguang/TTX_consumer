//
//  HelpTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/24.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "HelpTableViewCell.h"

@implementation HelpModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    HelpModel *model = [[HelpModel alloc]init];
    model.question = NullToSpace(dic[@"content"]);
    model.answer = NullToSpace(dic[@"replyContent"]);
    return model;
}
@end


@implementation HelpTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.answerLabel.numberOfLines = 0;
    self.detailView.hidden = YES;
    
    self.answerLabel.textColor = MacoDetailColor;
    self.fengeView.backgroundColor = MacoGrayColor;
    self.name.textColor = MacoTitleColor;
}

- (void)setDataModel:(HelpModel *)dataModel
{
    _dataModel = dataModel;
    self.name.numberOfLines = 0;
    self.name.text = _dataModel.question;
    self.answerLabel.text = _dataModel.answer;
    self.itemViewHeight.constant = [self cellQuestionrHeight:_dataModel];

}

- (CGFloat)cellQuestionrHeight:(HelpModel *)model
{
    CGSize size = [model.question boundingRectWithSize:CGSizeMake(TWitdh  - 62, 0) font:[UIFont systemFontOfSize:15]] ;
    return size.height + 20;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



@end
