//
//  ExUISearchBar.h
//  supercinema
//
//  Created by dust on 16/11/10.
//
//

#import <UIKit/UIKit.h>

@protocol ExUISearchBarDelegate <NSObject>
-(void)searchCinema:(NSString *)inputContent;
-(void)textFieldReturn;
@end


@interface ExUISearchBar : UIView<UITextFieldDelegate>

@property (nonatomic,strong)    UIButton     *_btnClear;
@property (nonatomic,strong)    UITextField  *_textFieldSearchInput;;
@property (nonatomic,strong)    UIImageView  *_imageViewSearch;
@property (nonatomic,strong)    UILabel      *_labelSearch;
@property (nonatomic,strong) id<ExUISearchBarDelegate> seatchBarDelegate;


//-(void)imageMoveAnnimation;
-(void)hideLabelAndClearbutton;
-(void)onButtonClear;

@end
