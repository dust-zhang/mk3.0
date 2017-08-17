//
//  BootAnimationView.h
//  supercinema
//
//  Created by dust on 16/11/23.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
@import MediaPlayer;

@interface BootAnimationView : UIView<CLLocationManagerDelegate>
{
    NSString            *_longitude;
    NSString            *_latitude;
}
-(instancetype)initWithFrame:(CGRect)frame;

@property (nonatomic,retain) CLLocationManager          *_locationMgr;
@property (nonatomic,assign) CLLocationCoordinate2D     _localCoordinate;
@property (nonatomic,strong) MPMoviePlayerController    *_startPlayer;

@end
