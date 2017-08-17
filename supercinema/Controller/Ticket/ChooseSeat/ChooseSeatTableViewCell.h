//
//  ChooseSeatTableViewCell.h
//  supercinema
//
//  Created by Mapollo28 on 2016/11/10.
//
//

#import <UIKit/UIKit.h>
#import "ShowTimeModel.h"
#import "LPLabel.h"

@interface ChooseSeatTableViewCell : UITableViewCell
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
}
-(void)setData:(ShowTimesModel*)showTModel;
-(void)layoutFrame:(BOOL)isLastCell;
@end
