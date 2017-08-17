//
//  SearchHistoryTableViewCell.h
//  supercinema
//
//  Created by dust on 16/11/7.
//
//

#import <UIKit/UIKit.h>

@protocol  clearHistoryDelegate<NSObject>
-(void)onButtonClear:(UIButton*)sender;
-(void)onButtonHistory:(NSString *)strHistory;
@end


@interface SearchHistoryTableViewCell : UITableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void)setHistory:(NSMutableArray *)arrHistory;
-(void)setReommmedCinema:(NSString *)name showHideBtn:(BOOL) showHide cityName:(NSString*)cityName;

@property(nonatomic,assign) id <clearHistoryDelegate> clearHistoryDelegate;
@property (nonatomic, retain) UILabel       *_labelName;
@property (nonatomic, retain) UIImageView   *_imageView;
@property (nonatomic, retain) UIButton      *_btnClearOrLocation;
@property (nonatomic, retain) UILabel       *_labelClearOrLocation;


@end
