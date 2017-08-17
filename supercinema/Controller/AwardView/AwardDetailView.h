//
//  AwardDetailView.h
//  supercinema
//
//  Created by mapollo91 on 22/11/16.
//
//

#import <UIKit/UIKit.h>
#import "ActivityAwardModel.h"

@interface AwardDetailView : UIView
{
    activityGrantListModel  *_modelActivityGrantList;
    NSArray                 *_arrGrantList;
}
-(instancetype)initWithFrame:(CGRect)frame orderModel:(activityGrantListModel *)model hiddenLine:(BOOL)hiddenLine;
@end
