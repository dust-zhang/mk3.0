//
//  MemberBenefitsInfoTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 25/11/16.
//
//

#import <UIKit/UIKit.h>
#import "CardPackModel.h"

typedef enum : NSUInteger
{
    Valid = 0,
    PastDue = 1,
} TableType;

@protocol MemberBenefitsInfoCellDelegate <NSObject>
-(void)buyCardMemberBenefitsInfoCellSkip:(UIButton*)btn tableType:(TableType)tableType index:(NSInteger)row;
-(void)cardInfoMemberBenefitsInfoCellSkip:(UIButton*)btn delBtn:(UIButton *)delBtn tableType:(TableType)tableType index:(NSInteger)row;
-(void)deleteCardCellDataId:(NSNumber *)cellDataId isSelected:(BOOL)isSelected;
-(void)onButtonChangeCinema:(CinemaModel *)cinemaModel;

@end

@interface MemberBenefitsInfoTableViewCell : UITableViewCell
{
    UIView          *_viewWhiteBg;
    
    //影院地址
    UILabel         *_labelCinemaAddress;
    
    UIImageView     *_imageArrow;       //箭头
    UIButton        *_btnCinemaAddress; //跳转到影院的透明Button
    UILabel         *_labelRightsCount; //权利个数
    UILabel         *_labelLine;        //纵向分割线
    UIImageView     *_imageLine;        //分割线

    //失效的蒙版
    UIView          *_viewMask;
    
    //cell的indexPath.row
    NSInteger       _index;
    
    CinemaModel     *_cinemaModel;
}

//@property(nonatomic, strong)cinemaAndCardRelationshipListModel     *_cinemaAndCardRelationshipListModel;
@property(nonatomic, weak)id <MemberBenefitsInfoCellDelegate>      memberBenefitsInfoDelegate;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
//有效 基本信息&详情
-(void)setAllValidBasicInformationCellFrameData:(CinemaModel *)cinemaModel arrayCardList:(NSArray *)arrayCardList;
-(void)setAllValidDetailsCellFrameData:(NSArray *)arrayCardList index:(NSInteger)indexPath;

//失效 基本信息&详情
-(void)setAllPastDueBasicInformationCellFrameData:(CinemaModel *)cinemaModel arrayCardList:(NSArray *)arrayCardList;
-(void)setAllPastDueDetailsCellFrameData:(NSArray *)arrayCardList index:(NSInteger)indexPath boolDeleteButtonShow:(BOOL)boolDeleteButtonShow;

@end
