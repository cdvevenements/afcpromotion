//
//  ContactVC.h
//  afcpromotion
//
//  Created by Olivier on 17/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>
#import "DataManager.h"
#import "MailManager.h"

@interface ContactVC : UIViewController <UIWebViewDelegate>
@property (strong, nonatomic) ProgramData *program;
@end
