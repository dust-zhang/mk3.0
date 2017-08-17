//
//  ChangeCinemaImageViewController.h
//  supercinema
//
//  Created by mapollo91 on 12/4/17.
//
//

#import <UIKit/UIKit.h>
#import "PhotoPickerView.h"
#import "PhotoViewItem.h"
#import "CutImageView.h"


@protocol ChangeCinemaImageDelegate <NSObject>
-(void)ChangeCinemaImageDelegate:(UIImage *)imageSelectedCinema;
@end

@interface ChangeCinemaImageViewController : HideTabBarViewController <UIScrollViewDelegate, PhotoPickerViewDelegate>
{
    PhotoPickerView *_pickerView;
    
    //确认按钮
    UIButton        *_btnEnsure;
    
    NSMutableArray  *_arrStillsImage;    //剧照数组
    NSMutableArray  *_arrNewStillsImage;
    
    /***异常状态控件***/
    UIImageView     *_imageFailure;      //加载失败
    UILabel         *_labelFailure;      //加载失败标签
    UIButton        *_btnTryAgain;       //重新加载按钮
    NSInteger       _indexImage;         //重新加载按钮
    NSString        *_imageURL;
    UIImage         *_imageSelectedCinema;
}
@property (nonatomic, weak) id <ChangeCinemaImageDelegate> delegate;
@property (nonatomic, strong)NSNumber   *_movidId;
@property (nonatomic, assign)BOOL       _isPosters;
@property (nonatomic, strong)NSArray    *_arrImages;
@property (nonatomic, strong)NSString   *_strViewName;

@end
