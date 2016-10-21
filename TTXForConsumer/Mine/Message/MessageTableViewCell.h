//
//  MessageTableViewCell.h
//  TTXForConsumer
//
//  Created by ttx on 16/6/29.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessafeModel : BaseModel

/**
 * 消息id
 */
@property (nonatomic, copy)NSString *messageid;
/**
 * 标题
 */
@property (nonatomic, copy)NSString *title;
/**
 * 内容
 */
@property (nonatomic, copy)NSString *content;
/**
 * 创建时间
 */
@property (nonatomic, copy)NSString *createTime;
/**
 * 类型
 */
@property (nonatomic, copy)NSString *type;

/**
 * 消息是否已读
 */
@property (nonatomic, copy)NSString *state;


@end

@interface MessageTableViewCell : BaseTableViewCell

@property (nonatomic, strong)MessafeModel *dataModel;

@property (weak, nonatomic) IBOutlet UILabel *titel_label;
@property (weak, nonatomic) IBOutlet UILabel *detail_label;

@property (weak, nonatomic) IBOutlet UILabel *time_label;

@property (weak, nonatomic) IBOutlet UIView *item_view;
@property (weak, nonatomic) IBOutlet UIView *markView;

@end
