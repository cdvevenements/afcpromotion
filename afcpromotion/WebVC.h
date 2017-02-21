//
//  WebVC.h
//  afcpromotion
//
//  Created by Olivier on 21/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>

@interface WebVC : UIViewController <UIWebViewDelegate> {
}

@property(strong, nonatomic) NSString * url;
@property(strong, nonatomic) NSString * navTitle;
@end
