//
//  VideoVC.h
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VIMVideoPlayerView.h>
#import <VIMVideoPlayer.h>
#import <SVProgressHUD.h>
#import <iCarousel.h>
#import "DataManager.h"
#import "MailManager.h"
#import "ContactVC.h"
#import "FormVC.h"

@interface VideoVC : UIViewController <VIMVideoPlayerDelegate, MailManagerDelegate, iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) ProgramData *program;
@property BOOL isVideo;
@end
