//
//  ContactVC.m
//  afcpromotion
//
//  Created by Olivier on 17/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "ContactVC.h"

#define JSHOOK_SCHEME   @"afcpromoapp"

@interface ContactVC ()
@property (weak, nonatomic) IBOutlet UIWebView *wvContact;
@property (weak, nonatomic) IBOutlet UIButton *btClose;

@end

@implementation ContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSData * data = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@/contact/%@", [DataManager dataPath], @"index.html"]];
    [[self wvContact] loadHTMLString:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] baseURL:[NSURL URLWithString:[DataManager dataPath]]];
    [[[self wvContact] scrollView] setScrollEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)onReloadClicked:(id)sender {
    [[self wvContact] reload];
}


- (IBAction)onCloseClicked:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}



// ==========================================================================
#pragma mark - UIWebViewDelegate
// ==========================================================================
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}
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
