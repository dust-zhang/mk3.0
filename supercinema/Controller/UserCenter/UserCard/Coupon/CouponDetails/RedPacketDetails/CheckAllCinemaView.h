//
//  CheckAllCinemaView.h
//  supercinema
//
//  Created by mapollo91 on 25/4/17.
//
//

#import "PopMessageView.h"
#import "SpreadListTableView.h"

@interface CheckAllCinemaView : PopMessageView
{
    NSMutableArray      *_arrData;
    
    //加载失败
    UIImageView             *_imageFailure;
    UILabel                 *_labelFailure;
    UIButton                *_btnTryAgain;
    NSNumber                *_redPacketId;
    BOOL                    isRemoveFromSuperview;      //是否清掉缓存
}
@property (nonatomic, strong) SpreadListTableView  *_viewContent;    //View内容

//初始化控件
-(id)initWithFrame:(CGRect)frame redPacketId:(NSNumber *) Id;
////画View
//-(void)drawCheckAllCinemaView;

@end
