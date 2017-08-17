//
//  MapViewController.h
//  supercinema
//
//  Created by dust on 16/12/27.
//
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAPointAnnotation.h>
#import "CustomAnnotationView.h"

@interface MapViewController : HideTabBarViewController<MAMapViewDelegate,navigationDelegate>
{
    CLLocationCoordinate2D    _coordinate2D;
    
}

@property (nonatomic, strong) MAMapView                 *mapView;
@property (nonatomic, strong) MAAnnotationView          *userLocationAnnotationView;
@property (nonatomic, strong) CinemaModel               *_cinemaModel;
@property (nonatomic, strong) NSMutableArray            *annotations;

@property(nonatomic,strong) NSMutableArray              *_arrayMap;
@end
