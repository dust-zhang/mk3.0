//
//  OtherCenterViewController.h
//  supercinema
//
//  Created by mapollo91 on 8/12/16.
//
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "MyAttentionViewController.h"
#import "MyFansViewController.h"
#import "WantLookViewController.h"
#import "MyDynamicTableViewCell.h"
#import "DynamicDetailViewController.h"

@interface OtherCenterViewController : HideTabBarViewController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,MyDynamicTableViewCellDelegate,FDActionSheetDelegate,UIAlertViewDelegate>
{
    //顶部背景
    UIView          *_topView;
    UIButton        *_btnBack;
    UILabel         *_labelTopTitle;
    UILabel         *_labelTopLine;
    
    UIImageView     *_imageTopBG;
    //蒙层
    UIView          *_viewHazy;
    
    //整体
    UIScrollView    *_scrollViewUserSet;
    
    //签名View
    UIView          *_userSignature;
    //曲线背景
    UIImageView     *_imageCurveBG;
    
    UIButton        *_imageUserIcon;    //用户头像
    UIButton        *_btnFocus;         //关注按钮
    UILabel         *_labelUserName;    //用户昵称
    UIImageView     *_imageSex;         //性别
    
    UILabel         *_labelUserSignature;       //正文提示文字
    
    //关注；粉丝；想看；看过
    UIView          *_viewUserBtnsBG;
    UILabel         *_labelNumber[4];
    
    //动态的TabView
    UITableView             *_tabelDynamic;
    UserUnReadDataModel     *_userUnReadDataModel;
    
    
    UserDynamicModel    *_dynModel;
    NSString            *_pageIndex;
    NSInteger           _curIndex;
    NSMutableArray      *_muArrType;
    FeedListModel       *_curModel;
    UIView              *_viewBigHead;
    UserModel           *_userModel;
    
    UIImageView     *_imageViewBigHead;
    CGRect          _oldFrame;    //保存图片原来的大小
    CGRect          _largeFrame;  //确定图片放大最大的程度
}


@property (nonatomic,strong) NSString *_strUserId;

@end




