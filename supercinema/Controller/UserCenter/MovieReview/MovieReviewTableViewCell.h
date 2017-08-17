//
//  MovieReviewTableViewCell.h
//  supercinema
//
//  Created by mapollo91 on 9/12/16.
//
//

#import <UIKit/UIKit.h>

@interface MovieReviewTableViewCell : UITableViewCell
{
    UIImageView     *_imageLogo;
    UILabel         *_labelName;
    UILabel         *_labelScore;
    UILabel         *_labelMyScore;
    UILabel         *_labelMovieReview;
    UILabel         *_labelDate;
    UILabel         *_labelMovieType;
}

-(void)setMovieReviewCellFrameAndData:(MyMovieModel *)myMovieModel sysTime:(NSNumber*)systemTime;

@end
