//
//  TTXPageContrl.m
//  TTXForConsumer
//
//  Created by ttx on 16/7/6.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "TTXPageContrl.h"

@implementation TTXPageContrl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    [super setCurrentPage:currentPage];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size = CGSizeMake(10, 2);
       
        subview.layer.cornerRadius = 0;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        if (subviewIndex == currentPage)
            subview.backgroundColor = MacoColor;
//            [subview setImage:[UIImage imageNamed:@"icon_mall_asterisk"]];
        else
            subview.backgroundColor = MacoGrayColor;
//            [subview setImage:[UIImage imageNamed:@"icon_v4_white"]];
    }
}

@end
