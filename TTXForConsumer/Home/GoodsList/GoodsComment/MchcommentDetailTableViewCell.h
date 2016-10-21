//
//  BussesscommentDetailTableViewCell.h
//  天添薪
//
//  Created by ttx on 16/1/6.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MchComment : BaseModel

/**
 * 评论id
 */
@property (nonatomic, copy)NSString *commentId;
/**
 * 商品id
 */
@property (nonatomic, copy)NSString *goodsId;
/**
 * 用户昵称
 */
@property (nonatomic, copy)NSString *userNickName;
/**
 * 评论内容
 */
@property (nonatomic, copy)NSString *content;
/**
 * 评论时间 yyyy.MM.dd
 */
@property (nonatomic, copy)NSString *commentTime;

@property (nonatomic, copy)NSString *specStr;





@end

@interface MchcommentDetailTableViewCell : BaseTableViewCell



@property (nonatomic, strong)MchComment *dataModel;

@property (weak, nonatomic) IBOutlet UILabel *user_name;

@property (weak, nonatomic) IBOutlet UILabel *time_label;

@property (weak, nonatomic) IBOutlet UILabel *detail_label;
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;




@end
