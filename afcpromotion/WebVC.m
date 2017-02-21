//
//  WebVC.m
//  afcpromotion
//
//  Created by Olivier on 21/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()
@property (weak, nonatomic) IBOutlet UIWebView *wvWeb;

@end

@implementation WebVC

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [[[self navigationController] navigationItem] setTitle:@"Retour"];
    

    
    [[self wvWeb] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[self url]]]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// =================================================================================================
#pragma mark - NJKWebViewProgressDelegate
// =================================================================================================
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:[error description]];
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
