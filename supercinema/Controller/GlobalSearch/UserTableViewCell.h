//
//  UserTableViewCell.h
//  supercinema
//
//  Created by dust on 16/11/8.
//
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@protocol  attentionDelegate<NSObject>
-(void)onButtonAttentionDelegte:(UIButton *)btn userId:(NSNumber *)userId isCancel:(BOOL)isCancel;
@end

@interface UserTableViewCell : UITableViewCell
{
    UIImageView         *_imageViewHead;
    UILabel             *_labelUserNane;
    FollowPersonListModel *_followPersonListModel;
}

@property (nonatomic,strong)    UIButton            *_btnAttention;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void) setUserText:(FollowPersonListModel *)model key:(NSString *)strKey;
//关注用户
-(void) setAttentionUserText:(FollowPersonListModel *)model;
@property(nonatomic,assign) id <attentionDelegate> _attentionDelegate;

@end
