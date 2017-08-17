//
//  CinemaVideoTableViewCell.h
//  supercinema
//
//  Created by dust on 2017/4/13.
//
//

#import <UIKit/UIKit.h>

@interface CinemaVideoTableViewCell : UITableViewCell
{
    UIImageView         *_imageViewPlay;
    UIImageView         *_imageViewVideo;
    UILabel             *_labelVideoName;
    UILabel             *_labelVideoTime;
    
}
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;

-(void) setVideoUrl:(CinemaVideoModel *)model;

@end
