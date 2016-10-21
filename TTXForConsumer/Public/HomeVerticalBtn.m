//
//  HomeVerticalBtn.m
//  天添薪
//
//  Created by ttx on 16/1/4.
//  Copyright © 2016年 ttx. All rights reserved.
//

#import "HomeVerticalBtn.h"

@implementation HomeVerticalBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initViewswithframe:TWitdh/3];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initViewswithframe:TWitdh/3];
    }
    return self;
}

- (UILabel *)alerLabel
{
    if (!_alerLabel) {
        _alerLabel = [[UILabel alloc]init];
    }
    return _alerLabel;
}

-(void) initViewswithframe:(CGFloat)width {
    self.backgroundColor = [UIColor clearColor];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.textLabel = [[UILabel alloc] init];
    
    self.textLabel.textColor = MacoDetailColor;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.font = [UIFont boldSystemFontOfSize:13];
    
    self.alerLabel = [[UILabel alloc]init];
    self.alerLabel.backgroundColor = [UIColor whiteColor];

    self.alerLabel.textAlignment = NSTextAlignmentCenter;
    self.alerLabel.adjustsFontSizeToFitWidth = YES;
    self.alerLabel.font = [UIFont systemFontOfSize:11];
    self.alerLabel.textColor = MacoColor;
    self.alerLabel.hidden = YES;
    
    [self addSubview:self.imageView];
    [self addSubview:self.textLabel];
    [self addSubview:self.alerLabel];



    CGFloat imageWidth = 40.;
    self.imageView.frame = CGRectMake((width-imageWidth)/2, 5, imageWidth, imageWidth);
    self.textLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), width, 21);
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.alerLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) - 13, self.imageView.frame.origin.y + 5, 17, 17);

    self.alerLabel.layer.cornerRadius = 17/2.;
    self.alerLabel.layer.masksToBounds = YES;
    self.alerLabel.layer.borderWidth = 1;
    self.alerLabel.layer.borderColor = MacoColor.CGColor;
    [self bringSubviewToFront:self.alerLabel];
}



- (void)setAlerTitle:(NSString *)alerTitle
{
    _alerTitle = alerTitle;
    self.alerLabel.text = _alerTitle;
    self.showAlerLabel = ![self.alerTitle isEqualToString:@"0"];
}


- (void)setShowAlerNumber:(BOOL)showAlerNumber
{
    _showAlerNumber = showAlerNumber;
    if (!_showAlerNumber){
        self.alerLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame) - 5, self.imageView.frame.origin.y + 12, 7, 7);
        self.alerLabel.layer.cornerRadius = 3.5;
        self.alerLabel.backgroundColor = MacoColor;
        self.alerLabel.text = @"";
        self.alerLabel.layer.masksToBounds = YES;
    }
}

- (void)setShowAlerLabel:(BOOL)showAlerLabel
{
    _showAlerLabel = showAlerLabel;
    self.alerLabel.hidden = !_showAlerLabel;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.textLabel.textColor = _textColor;
}
- (void)awakeFromNib {
}


@end
