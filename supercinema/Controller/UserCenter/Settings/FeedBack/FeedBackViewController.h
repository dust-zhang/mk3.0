//
//  FeedBackViewController.h
//  supercinema
//
//  Created by mapollo91 on 29/9/16.
//
//

#import <UIKit/UIKit.h>
#import "PhotoImagePickerController.h"
#import "JKPhotoBrowser.h"
#import "PhotoBrowser.h"


#define LeftPosX                15
#define imagewidth              (SCREEN_WIDTH-30)/4

@interface FeedBackViewController : HideTabBarViewController <PhotoImagePickerControllerDelegate, PhotoBrowserDelegate, UITextFieldDelegate, UITextViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
{
    //确认按钮
    UIButton            *_btnFeedBackConfirm;
    
    UIScrollView        *_wholeScrollView;
    UIView              *_viewAllBG;
    
    //圆圈按钮图片
    UIImageView         *_imageRound[4];
    
    //意见类型 整体背景
    UIView              *_viewFeedBackType;
    //邮箱 & 意见内容 背景的View
    UIView              *_viewControlsBG;
    //文本的输入框
    UITextView          *_textViewContent;
    //正文提示文字
    UILabel             *_labelPlaceContent;
    //放照片的View
    UIView              *_viewImage;
    //添加图片的按钮
    UIButton            *_btnSelect[4];
    //显示的图片
    UIImageView         *_imageviewTop[4];
    //添加遮罩图
    UILabel             *_labelBlack[4];
    //删除图片按钮
    UIButton            *_btnDelete[4];
    //编辑图片状态
    UIImageView         *_imageViewEditStatus[4];
    //已经选择的图片
    NSMutableArray      *_arrayImage;
    BOOL                _boolOnlyStills;
    //显示文字个数的标签
    UILabel             *_labelTextCount;
    //电子邮箱背景
    UIView              *_textViewEmailView;
    //电子邮箱输入框
    UITextField         *_textViewEmail;
    //电子邮箱提示文字
    UILabel             *_labelEmailContent;
    
    int                 _intImageCount;
    
    NSInteger           _btnTag;        //0:购票问题 1:会员卡问题 2:app问题 3:其它问题
    
    NSMutableArray      *_arrayUpload;
    
    UILabel             *_labelWordNum; //我想说文本框字数限制
}

@property (nonatomic, strong)   NSMutableArray  *_arrAssets;

@end

