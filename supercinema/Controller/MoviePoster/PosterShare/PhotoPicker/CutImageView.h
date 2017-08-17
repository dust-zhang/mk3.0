//
//  CutImageView.h
//  supercinema
//
//  Created by mapollo91 on 30/3/17.
//
//

#import <UIKit/UIKit.h>

//获取屏幕宽度
#define     BottomHeight 50

@protocol CutImageDelegate <NSObject>
-(void)CutImageDelegate:(UIImage *)imageCut;
@end

@interface CutImageView : UIView <UIScrollViewDelegate>
{
    UINavigationController  *navigationController;
    
    UIScrollView    *_scrollBG;         //整体滑动
    UIImageView     *_imageCut;         //整体image
    
    UIView          *_viewTop;          //顶部遮盖图
    UILabel         *_labelMid;         //中间遮盖图
    UIView          *_viewBottom;       //下方遮盖图
    
    UIButton        *_btnCancel;        //取消按钮
    UIButton        *_btnCutImage;      //裁剪按钮
    
    UIImage         *_imageIn;          //需要裁剪的image
    
    NSString        *_imageInBigURL;         //图片地址
    NSString        *_imageInSmallURL;         //图片地址
    
    float           _fClipControl;      //裁剪尺寸
    CGSize          _midSize;           //中间显示框
}
@property (nonatomic, weak) id <CutImageDelegate> delegate;
-(id)initWithFrame:(CGRect)frame imageURL:(NSString *)imageBigUrl smallUrl:(NSString *)smallUrl control:(float)control nav:(UINavigationController *)nav;

@end
