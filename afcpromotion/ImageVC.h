//
//  ImageVC.h
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iCarousel.h>

#import "MailManager.h"
#import "DataManager.h"
#import "Config.h"

@interface ImageVC : UIViewController <iCarouselDataSource, iCarouselDelegate>
@property (strong, nonatomic) ProgramData *program;

@end
