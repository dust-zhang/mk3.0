//
//  ChangeShareImageViewController.h
//  supercinema
//
//  Created by mapollo91 on 28/3/17.
//
//

#import <UIKit/UIKit.h>
#import "PhotoPickerView.h"
#import "PhotoViewItem.h"

#import "CutImageView.h"

@protocol ChangeShareImageDelegate <NSObject>
-(void)ChangeShareImageDelegate:(UIImage *)imageShareImage;
@end

@interface ChangeShareImageViewController : HideTabBarViewController <UIScrollViewDelegate, PhotoPickerViewDelegate,CutImageDelegate>
{
    PhotoPickerView *_pickerView;
    
    NSMutableArray         *_arrStillsImage;    //剧照数组
    NSMutableArray  *_arrNewStillsImage;
    
    /***异常状态控件***/
    UIImageView     *_imageFailure;      //加载失败
    UILabel         *_labelFailure;      //加载失败标签
    UIButton        *_btnTryAgain;       //重新加载按钮
    NSInteger       _indexImage;         //重新加载按钮
}
@property (nonatomic, weak) id <ChangeShareImageDelegate> delegate;
@property (nonatomic, strong)NSNumber   *_movidId;
@property (nonatomic, assign)BOOL       _isPosters;
@end
