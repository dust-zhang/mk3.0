//
//  ShowTimeCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/8.
//
//

#import <UIKit/UIKit.h>
#import "ShowTimeModel.h"
#import "LPLabel.h"

@interface ShowTimeCell : UITableViewCell
{
    UIImageView* _imageShowTimeType; //早晚场图
    UILabel*    _labelShowTimeType; //早晚场label
    UIImageView* _imageTimeLine; //时间轴
    UILabel*    _labelStartTime;    //开始时间
    UILabel*    _labelEndTime;  //散场时间
    UILabel*    _labelLanguage; //语言
    UILabel*    _labelHall; //厅
    UILabel*    _labelFirst;   //第一行
    UILabel*    _labelSecond;  //第二行
    UILabel*    _labelFirstPrice;   //第一行价格
    LPLabel*    _labelSecondPrice;  //第二行价格
    UIImageView*    _imageLastPic;
    
    UIImageView*    _imgActivity;
    UIImageView* _imgActivityLeft;
    UIImageView* _imgActivityCenter;
    UIImageView* _imgActivityRight;
    UILabel*        _labelActivity;
}
-(void)setData:(ShowTimesModel*)showTModel;// str:(NSString*)str;
-(void)layoutFrame:(int)isLastCell; // isLastCell  0 第一个cell   1 最后一个cell 2 唯一cell
@end
