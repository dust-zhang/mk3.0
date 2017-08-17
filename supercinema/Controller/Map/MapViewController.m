//
//  MapViewController.m
//  supercinema
//
//  Created by dust on 16/12/27.
//
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self._labelTitle setText:@"影院位置"];
    _coordinate2D.longitude = [self._cinemaModel.dlongitude doubleValue];
    _coordinate2D.latitude = [self._cinemaModel.dlatitude doubleValue];
    self._arrayMap = [[NSMutableArray alloc] init];
    
    [self initController];
   
}

-(void)initController
{
    //返回按钮
    UIButton *btnOtherMap = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, self._btnBack.frame.origin.y, 85, self._btnBack.frame.size.height)];
    [btnOtherMap setTitle:@"其他地图" forState:UIControlStateNormal];
    [btnOtherMap setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [btnOtherMap.titleLabel setFont:MKFONT(15)];
    [btnOtherMap setTitleColor:RGBA(51, 51, 51, 1) forState:UIControlStateNormal];
    [btnOtherMap addTarget:self action:@selector(onButtonNavigation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOtherMap];
    
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, self._viewTop.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-self._viewTop.frame.size.height)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale= YES;
    self.mapView.rotateEnabled= NO;//NO表示禁用旋转手势，YES表示开启
    self.mapView.rotateCameraEnabled= NO;//NO表示禁用倾斜手势，YES表示开启
    [self.view addSubview:self.mapView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   //缩放到指定坐标点
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    CLLocationCoordinate2D dddd;
    dddd.longitude = _coordinate2D.longitude;
    dddd.latitude = _coordinate2D.latitude;
    self.mapView.centerCoordinate =dddd;
    [self.mapView setZoomLevel:16.1 animated:YES];
    //绘制📌
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate =dddd;
    [_mapView addAnnotation:pointAnnotation];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView._navigationDelegate = self;
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.centerOffset = CGPointMake(-10, - ((27+28+20+20+27)/2) );
        }
        
        [annotationView setText:self._cinemaModel];
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if (!updatingLocation && self.userLocationAnnotationView != nil)
    {
        [UIView animateWithDuration:0.1 animations:^{
            
            double degree = userLocation.heading.trueHeading;
            self.userLocationAnnotationView.transform = CGAffineTransformMakeRotation(degree * M_PI / 180.f );
            
        }];
    }
}
#pragma mark 导航
-(void)onButtonNavigation
{
    [self availableMapsApps];
    FDActionSheet *sheet = [[FDActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:self._arrayMap];
    [sheet show];
}

#pragma mark 判断是否安装地图，目前只判断百度、高德地图
- (void)availableMapsApps
{
    [self._arrayMap removeAllObjects];
    NSDictionary *dic = @{@"name":@"使用系统自带地图导航",
                          @"url":@""};
    [self._arrayMap addObject:dic];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
    {
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&destination=latlng:%f,%f|name:%@&mode=driving&src=超影科技|超级电影院",
                               self._cinemaModel.dlatitude.floatValue,
                               self._cinemaModel.dlongitude.floatValue,
                               self._cinemaModel.address];
        
        NSDictionary *dic = @{@"name": @"使用百度地图导航",
                              @"url": urlString};
        [self._arrayMap addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
    {
        //高德规划路线,传终点坐标
        NSString *urlString = [NSString stringWithFormat:@"iosamap://path?sourceApplication=超级电影院&sid=BGVIS1&slat=&slon=&sname=&did=BGVIS2&dlat=%f&dlon=%f&dname=%@B&dev=0&m=0&t=0",self._cinemaModel.latitude.floatValue,self._cinemaModel.longitude.floatValue,self._cinemaModel.address];
        
        NSDictionary *dic = @{@"name": @"使用高德地图导航",
                              @"url": urlString};
        [self._arrayMap addObject:dic];
    }
}


#pragma mark FDActionSheet Delegate
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    float lat = self._cinemaModel.latitude.floatValue;
    float lon = self._cinemaModel.longitude.floatValue;
    
    if(buttonIndex == 0)
    {
        CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(lat, lon);
        MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil]];
        toLocation.name = self._cinemaModel.address;
        [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
    }
    else
    {
        NSDictionary *obj = self._arrayMap[buttonIndex];
        NSString *urlStr = [obj objectForKey:@"url"];
        urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *mapUrl = [NSURL URLWithString:urlStr];
        [[UIApplication sharedApplication]openURL:mapUrl];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
