//
//  DownloadVC.h
//  afcpromotion
//
//  Created by Olivier on 16/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>
#import <SSZipArchive.h>
#import <SVProgressHUD.h>
#import "Config.h"
#import "DataManager.h"

@interface DownloadVC : UIViewController {
    BOOL mBlock;
}

@end
