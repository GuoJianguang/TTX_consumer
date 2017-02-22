//
//  SecondActivityTableViewCell.h
//  TTXForConsumer
//
//  Created by Guo on 2017/2/22.
//  Copyright © 2017年 ttx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondACtivityModel : BaseModel

/**
 * 活动id
 */

@property (nonatomic, copy)NSString *seqId;
/**
 * 活动名称
 */

@property (nonatomic, copy)NSString *name;
/**
 * 图片
 */

@property (nonatomic, copy)NSString *coverImg;
/**
 * 跳转方式 3：网页
 */

@property (nonatomic, copy)NSString *jumpWay;

/**
 * 跳转参数值，url
 */
@property (nonatomic, copy)NSString *jumpValue;
/**
* 为空则没有店铺，否则为商家mchCode
*/

@property (nonatomic, copy)NSString *remark;


@end


@interface SecondActivityTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;

@property (weak, nonatomic) IBOutlet UILabel *goodsName;


@property (nonatomic, strong)SecondACtivityModel *dataModel;


@end
