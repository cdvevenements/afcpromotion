//
//  ContactVC.m
//  afcpromotion
//
//  Created by Olivier on 17/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "ContactVC.h"

#define JSHOOK_SCHEME   @"afcpromoapp"
#define ID_FIRSTNAME    @"id_firstname"
#define ID_LASTNAME     @"id_lastname"
#define ID_FIRSTNAME    @"id_firstname"
#define ID_FIRSTNAME    @"id_firstname"
#define ID_FIRSTNAME    @"id_firstname"



@interface ContactVC ()
@property (weak, nonatomic) IBOutlet UIWebView *wvContact;
@property (weak, nonatomic) IBOutlet UIButton *btClose;

@end

@implementation ContactVC


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSData * data = [[NSFileManager defaultManager] contentsAtPath:[NSString stringWithFormat:@"%@/contact/%@", [DataManager dataPath], @"index.html"]];
    NSString * html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    html = [html stringByReplacingOccurrencesOfString:@"$PROGRAM" withString:[[self program] name]];
    [[self wvContact] loadHTMLString:html baseURL:[NSURL URLWithString:[DataManager dataPath]]];
    [[[self wvContact] scrollView] setScrollEnabled:NO];
    
    
    [[self navigationItem] setTitle:[[self program] name]]; // change le titre de la barre
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


- (NSString *)getQueryParam:(NSString *)name fromURL:(NSURL *)url {
    if (url)
    {
        NSArray *urlComponents = [url.query componentsSeparatedByString:@"&"];
        for (NSString *keyValuePair in urlComponents)
        {
            NSArray *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString *key = [[pairComponents firstObject] stringByRemovingPercentEncoding];
            
            if ([key isEqualToString:name])
            {
                return [[pairComponents lastObject] stringByRemovingPercentEncoding];
            }
        }
    }
    return nil;
}


// ==========================================================================
#pragma mark - UIWebViewDelegate
// ==========================================================================
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    if([[[request URL] scheme] isEqualToString:JSHOOK_SCHEME]) {
        
        NSString * fname = [self getQueryParam:@"fname" fromURL:[request URL]];
        NSString * lname = [self getQueryParam:@"lname" fromURL:[request URL]];
        NSString * email = [self getQueryParam:@"email" fromURL:[request URL]];
        NSString * address = [self getQueryParam:@"address" fromURL:[request URL]];
        NSString * type = [self getQueryParam:@"type" fromURL:[request URL]];
        NSString * rooms = [self getQueryParam:@"rooms" fromURL:[request URL]];
        NSString * surface = [self getQueryParam:@"surface" fromURL:[request URL]];
        
        [MailManager sendEmail:email withGender:@"" withFirstName:fname withLastName:lname withAddress:address withProgram:[[self program] name] withType:type withRooms:rooms withSurface:surface withDelegate:nil];
        
        [SVProgressHUD showSuccessWithStatus:@"Merci, vos informations ont bien été prises en compte."];
    }
    
    return NO;
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
