//
//  SettingsTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 28/9/16.
//
//

#import <UIKit/UIKit.h>
#import "BFPaperButton.h"
#import "UserModel.h"

//定义协议
@protocol SettingsTableViewCellDelegate <NSObject>
//-(void)changeHead;
-(void)onButtonExit;
@end

@interface SettingsTableViewCell : UITableViewCell
{
    UILabel             *_labelName;
    UILabel             *_labelContent;
    //标签背景 & 头像

    UIImageView         *_imageArrow;
    UILabel             *_labelLine;
    //退出按钮
    BFPaperButton       *_btnExit;
}

@property(nonatomic,weak) id <SettingsTableViewCellDelegate> _delegete;
@property(nonatomic,strong) UIImageView                     *_imageIcon;
//初始化控件
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
-(void)setSettingsTableCellDataAndRowAtIndexPath:(NSIndexPath *)indexPath cell:(UserModel *)cellModel;
-(void)setSettingsTableCellFrameAndRowAtIndexPath:(NSIndexPath *)indexPath;

@end
