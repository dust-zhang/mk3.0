//
//  SettingsTableViewCell.m
//  supercinema
//
//  Created by mapollo91 on 28/9/16.
//
//

#import "SettingsTableViewCell.h"

@implementation SettingsTableViewCell

//初始化控件
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //标签背景 & 头像
        self._imageIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self._imageIcon setBackgroundColor:[UIColor orangeColor]];
        [self addSubview:self._imageIcon];
        
        //标签名字
        _labelName = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelName setBackgroundColor:[UIColor clearColor]];
        [_labelName setTextColor:RGBA(51, 51, 51, 1)];
        //文字向左对齐
        [_labelName setTextAlignment:NSTextAlignmentLeft];
        [_labelName setFont:MKFONT(15)];
        [self addSubview:_labelName];
        
        //标签内容
        _labelContent = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelContent setBackgroundColor:[UIColor clearColor]];
        [_labelContent setTextColor:RGBA(102, 102, 102, 1)];
        //文字向右对齐
        [_labelContent setTextAlignment:NSTextAlignmentRight];
        [_labelContent setFont:MKFONT(14)];
        [self addSubview:_labelContent];
        
        //指示箭头
        _imageArrow = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageArrow setImage:[UIImage imageNamed:@"btn_rightArrow.png"]];
        [self addSubview:_imageArrow];
        
        //分割线
        _labelLine = [[UILabel alloc] initWithFrame:CGRectZero];
        [_labelLine setBackgroundColor:RGBA(242, 242, 242, 1)];
        [self addSubview:_labelLine];
        
        //退出按钮
        _btnExit = [[BFPaperButton alloc] initWithFrame:CGRectZero];
        [_btnExit setBackgroundColor:RGBA(249, 81, 81, 1)];
        [_btnExit setTitle:@"退出" forState:UIControlStateNormal];
        [_btnExit.titleLabel setFont:MKFONT(15)];
        _btnExit.shadowColor = [UIColor clearColor];
        _btnExit.tapCircleColor = RGBA(248, 159, 159, 1);
        _btnExit.cornerRadius = 3.f;
        [_btnExit addTarget:self action:@selector(onButtonExit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnExit];
    }
    return self;
}

//Cell的Text
-(void)setSettingsTableCellDataAndRowAtIndexPath:(NSIndexPath *)indexPath cell:(UserModel *)cellModel
{
    switch (indexPath.row)
    {
        case 1:
        {
            [_labelName setText:@"头像"];
            [self._imageIcon sd_setImageWithURL:[NSURL URLWithString:[Tool urlIsNull:cellModel.portrait_url] ] placeholderImage:[UIImage imageNamed:@"image_defaultHead1.png"]];
        }
            break;
        case 2:
            [_labelName setText:@"主页背景"];
            break;
        case 3:
            [_labelName setText:@"昵称"];
            [_labelContent setText:cellModel.nickname];
            break;
        case 4:
        {
            [_labelName setText:@"性别"];
            if ([cellModel.gender intValue] == 1)
            {
                [_labelContent setText:@"男"];
            }
            else if ([cellModel.gender intValue] == 2)
            {
                [_labelContent setText:@"女"];
            }
            else
            {
                [_labelContent setText:@""];
            }
        }
            break;
        case 5:
        {
            [_labelName setText:@"生日"];        
            [_labelContent setText:cellModel.birthday];
        }
            break;
        case 7:
            [_labelName setText:@"密码"];
            break;
        case 8:
        {
            if([cellModel.mobileno length]>0)
            {
                 [_labelName setText:@"修改手机号"];
            }
            else
            {
                 [_labelName setText:@"绑定手机号"];
            }
        }
            break;
//        case 9:
//            [_labelName setText:@"通知设置"];
//            break;
        case 10:
        {
            [_labelName setText:@"清理缓存"];
            [_labelContent setText:[NSString stringWithFormat:@"%.1f MB",[[SDImageCache sharedImageCache] getSize]/ 1024.0 / 1024.0 ] ];
        }
            break;
        case 11:
            [_labelName setText:@"意见反馈"];
            break;
        case 12:
            [_labelName setText:@"关于"];
            break;
            
        default:
            break;
    }
}


//Cell的Frame
-(void)setSettingsTableCellFrameAndRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 ||
        indexPath.row == 6 ||
        indexPath.row == 9 )//10
    {
        //分割区域的背景颜色
        self.backgroundColor = RGBA(246, 246, 251,1);
    }
    else if (indexPath.row == 1)
    {
        //头像按钮
        _labelName.frame = CGRectMake(15, 25.5, 90, 15);
        _imageArrow.frame = CGRectMake(SCREEN_WIDTH-15-13, 26.5, 7.5, 13);
        self._imageIcon.frame = CGRectMake(_imageArrow.frame.origin.x-35-56/2, 15.5, 35, 35);
        [self._imageIcon.layer setMasksToBounds:YES];
        //弧度(边角范围)
        [self._imageIcon.layer setCornerRadius:35/2];
        _labelLine.frame = CGRectMake(15, 65, SCREEN_WIDTH-15, 1);
    }
    else if (indexPath.row == 13)
    {
        //设置退出按钮
        self.backgroundColor = RGBA(246, 246, 251,1);
        _btnExit.frame = CGRectMake(15, 30, SCREEN_WIDTH-30, 40);
        [_btnExit.layer setCornerRadius:20];
    }
    else
    {
        //设置其他常规行
        _labelName.frame = CGRectMake(15, 15, 90, 15);
        _imageArrow.frame = CGRectMake(SCREEN_WIDTH-15-13, 15, 7.5, 13);
        _labelContent.frame = CGRectMake(_imageArrow.frame.origin.x-(56/2)-190, 15.5, 190, 14);
        if (indexPath.row != 5 && indexPath.row != 9  && indexPath.row != 12)
        {
            _labelLine.frame = CGRectMake(15, 44, SCREEN_WIDTH-15, 1);
        }
        
    }
}

//点击退出(注销)
-(void)onButtonExit
{
    if ([self._delegete respondsToSelector:@selector(onButtonExit) ])
    {
        [self._delegete onButtonExit];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
