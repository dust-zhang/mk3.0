//
//  SettingsViewController.h
//  supercinema
//
//  Created by mapollo91 on 28/9/16.
//
//

#import <UIKit/UIKit.h>
#import "SettingsTableViewCell.h"
#import "ChangeNicknameViewController.h"
#import "ChangePwdViewController.h"
#import "ChangeMobileViewController.h"
#import "FeedBackViewController.h"
#import "AboutViewController.h"
#import "FSMediaPicker.h"
#import "UserModel.h"
#import "SettingsNoticeViewController.h"
#import "BindTelNumberViewController.h"

@interface SettingsViewController : HideTabBarViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, FSMediaPickerDelegate, ChangeNicknameDelegate,SettingsTableViewCellDelegate>
{
    UITableView             *_tabViewSettings;
    SettingsTableViewCell   *_currentCell;
    UIAlertView             *_mediaAlert;
    UIDatePicker            *_datePicker;
    UIButton                *_btnChangeSex;
    NSMutableArray          *_arrayUpload;
    SettingsTableViewCell   *_cellSet;
    NSString                *_strUploadType;
    NSMutableArray          *_arrHead;
}

@property(nonatomic,strong) UserModel                           *_userModel;
//@property(nonatomic,strong) NSString                            *_strBandUpdateTelNo;



@end
