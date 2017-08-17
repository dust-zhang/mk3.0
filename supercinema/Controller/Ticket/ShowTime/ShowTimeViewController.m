//
//  ShowTimeViewController.m
//  supercinema
//
//  Created by Mapollo28 on 2017/3/23.
//
//

#import "ShowTimeViewController.h"

@interface ShowTimeViewController ()

@end

@implementation ShowTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self._labelTitle.text = self.hotMovieModel.movieTitle;
    self.view.backgroundColor = [UIColor clearColor];
    [self initControl];
}

-(void)initControl
{
    __weak __typeof__(self) weakSelf = self;
    [ServicesMovie getMovieDetail:[self.hotMovieModel.movieId stringValue] cinemaId:[Config getCinemaId] model:^(MovieModel *movieDetail) {
        weakSelf._labelTitle.text = movieDetail.movieTitle;
    } failure:^(NSError *error) {
        
    }];
    
    ShowTimeView* showTime = [[ShowTimeView alloc]initWithFrame:CGRectMake(0, self._viewTop.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-self._viewTop.frame.size.height) movieListModel:self.hotMovieModel navigation:self.navigationController];
    [self.view addSubview:showTime];
    [showTime loadShowtimeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
