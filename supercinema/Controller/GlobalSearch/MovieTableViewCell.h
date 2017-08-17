//
//  MovieTableViewCell.h
//  supercinema
//
//  Created by dust on 16/11/8.
//
//

#import <UIKit/UIKit.h>
#import "HotMovieListModel.h"

@protocol  buyTicketDelegate<NSObject>
-(void)onButtonBuy:(NSInteger)index;
@end

@interface MovieTableViewCell : UITableViewCell
{
    UIImageView         *_imageViewMovie;
    UILabel             *_labelMovieName;
    UILabel             *_labelMovieShowDate;
    UILabel             *_labelMovieActorName;
    UILabel             *_labelMovieCountry;
    UIButton            *_btnBuy;
    NSInteger            _index;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
-(void) setMovieText:(MovieModel *)model index:(NSInteger)index  key:(NSString *)strKey;

@property(nonatomic,assign) id <buyTicketDelegate> _buyTicketDelegate;

@end
