//
//  MovieTableViewCell.m
//  supercinema
//
//  Created by dust on 16/11/8.
//
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor] ];
        _index = 0;
        
        _imageViewMovie = [[UIImageView alloc ] initWithFrame:CGRectMake(15, 0, 90, 120)];
        [_imageViewMovie setBackgroundColor:[UIColor greenColor]];
        [self addSubview:_imageViewMovie];
        
        _labelMovieName = [[UILabel alloc ] initWithFrame:CGRectMake(_imageViewMovie.frame.origin.x+_imageViewMovie.frame.size.width+20, _imageViewMovie.frame.origin.y +9, 140, 15)];
        [_labelMovieName setFont:MKBOLDFONT(15)];
//        [_labelMovieName setBackgroundColor:[UIColor redColor]];
        [_labelMovieName setTextColor:RGBA(51, 51, 51, 1)];
        [self addSubview:_labelMovieName];
        
        _labelMovieShowDate = [[UILabel alloc ] initWithFrame:CGRectMake(_labelMovieName.frame.origin.x, _labelMovieName.frame.origin.y +_labelMovieName.frame.size.height +10, SCREEN_WIDTH-140, 12)];
        [_labelMovieShowDate setFont:MKFONT(12)];
        [_labelMovieShowDate setTextColor:RGBA(51, 51, 51, 1)];
        [self addSubview:_labelMovieShowDate];

        _labelMovieActorName = [[UILabel alloc ] initWithFrame:CGRectMake(_labelMovieName.frame.origin.x, _labelMovieShowDate.frame.origin.y+_labelMovieShowDate.frame.size.height +10, SCREEN_WIDTH-140, 12)];
        [_labelMovieActorName setFont:MKFONT(12)];
        [_labelMovieActorName setTextColor:RGBA(51, 51, 51, 1)];
        [self addSubview:_labelMovieActorName];
        
        _labelMovieCountry = [[UILabel alloc ] initWithFrame:CGRectMake(_labelMovieName.frame.origin.x, _imageViewMovie.frame.origin.y +_imageViewMovie.frame.size.height-12, SCREEN_WIDTH-140, 12)];
        [_labelMovieCountry setFont:MKFONT(12)];
        [_labelMovieCountry setTextColor:RGBA(123, 122, 152, 1)];
        [self addSubview:_labelMovieCountry];

        _btnBuy = [[UIButton alloc ] initWithFrame:CGRectMake(SCREEN_WIDTH-60-15,_imageViewMovie.frame.size.height/2-12 , 60, 24)];
        [_btnBuy.layer setCornerRadius:12];
        [_btnBuy.layer setMasksToBounds:YES];
        [_btnBuy setTitle:@"购票" forState:UIControlStateNormal];
        [_btnBuy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnBuy.titleLabel setFont:MKFONT(12) ];
        [_btnBuy setBackgroundColor:RGBA(253, 189, 34, 1)];
        [_btnBuy addTarget:self action:@selector(onButtonBuy:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnBuy];
        [_btnBuy setHidden:YES];

    }
    return self;
}

-(void) setMovieText:(MovieModel *)model index:(NSInteger)index  key:(NSString *)strKey
{
    [_imageViewMovie sd_setImageWithURL:[NSURL URLWithString:[Tool urlIsNull:model.logoUrl]] placeholderImage:[UIImage imageNamed:@"img_homelogo_default.png"] ];
   
    [_labelMovieName setText:model.movieTitle];
    //设置关键字
    [_labelMovieName setAttributedText:[Tool setKeyAttributed:model.movieTitle key:strKey fontSize:MKBOLDFONT(15)]];
    
    [_labelMovieShowDate setText:[NSString stringWithFormat:@"%@  上映",model.releaseDate] ];
    //设置关键字
    [_labelMovieShowDate setAttributedText:[Tool setKeyAttributed:model.releaseDate key:strKey fontSize:MKFONT(12)]];
    
    NSString *str=@"";
    for(int i = 0;i< [model.actorList count]; i++)
    {
        str = [str stringByAppendingString: model.actorList[i]];
        if ([model.actorList count] > 1 && i< [model.actorList count]-1)
        {
             str = [str stringByAppendingString:@" / " ];
        }
        [_labelMovieActorName setText:str];
        //设置关键字
        [_labelMovieActorName setAttributedText:[Tool setKeyAttributed:str key:strKey fontSize:MKFONT(12)]];
    }

    [_labelMovieCountry setText:model.originName];
    //设置关键字
    [_labelMovieCountry setAttributedText:[Tool setKeyAttributed:model.originName key:strKey fontSize:MKFONT(12)]];
    
    //购票按钮状态  0：不能购票,1：正常购票,2：超前预售
    if([model.buyTicketStatus intValue] == 1 || [model.buyTicketStatus intValue] == 2)
    {
        [_btnBuy setHidden:NO];
    }
    _btnBuy.tag = index;
}

-(void)onButtonBuy:(UIButton*)sender
{
     if ([self._buyTicketDelegate respondsToSelector:@selector(onButtonBuy:)])
    {
        [self._buyTicketDelegate onButtonBuy:sender.tag ];
    }
   
}


@end
