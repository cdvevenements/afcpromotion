//
//  FormVC.h
//  afcpromotion
//
//  Created by Olivier on 20/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DLRadioButton.h>
#import <SVProgressHUD.h>
#import "MailManager.h"

@interface FormVC : UIViewController <UITextFieldDelegate, MailManagerDelegate>
@property (strong, nonatomic) ProgramData *program;
@end
