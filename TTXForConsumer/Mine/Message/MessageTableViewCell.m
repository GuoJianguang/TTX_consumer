//
//  MessageTableViewCell.m
//  TTXForConsumer
//
//  Created by ttx on 16/6/29.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessafeModel

+ (id)modelWithDic:(NSDictionary *)dic
{
    MessafeModel *model = [[MessafeModel alloc]init];
    model.messageid = NullToSpace(dic[@"id"]);
    model.title = NullToSpace(dic[@"title"]);
    model.content = NullToSpace(dic[@"content"]);
    model.createTime = NullToSpace(dic[@"createTime"]);
    model.type = NullToSpace(dic[@"type"]);
    model.state = NullToNumber(dic[@"state"]);
    
    return model;
}

@end

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.time_label.textColor = MacoIntrodouceColor;
    self.detail_label.textColor = MacoDetailColor;
    self.titel_label.textColor = MacoTitleColor;
    self.markView.layer.cornerRadius = 4;
    self.markView.layer.masksToBounds = YES;
    
    self.contentView.backgroundColor = [UIColor whiteColor];
}


- (void)setDataModel:(MessafeModel *)dataModel
{
    _dataModel = dataModel;
    self.titel_label.text = _dataModel.title;
    self.detail_label.text = _dataModel.content;
    self.time_label.text = [NSString stringWithFormat:@"%@", _dataModel.createTime];
    switch ([_dataModel.state integerValue]) {
        case 0:
            self.markView.hidden = NO;
            self.time_label.textColor = MacoIntrodouceColor;
            self.detail_label.textColor = MacoDetailColor;
            self.titel_label.textColor = MacoTitleColor;
            break;
        case 1:
            self.time_label.textColor = MacoIntrodouceColor;
            self.detail_label.textColor = MacoIntrodouceColor;
            self.titel_label.textColor = MacoDetailColor;
            self.markView.hidden = YES;
            break;
            
        default:
            break;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
