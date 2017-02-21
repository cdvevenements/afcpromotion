//
//  VideoVC.m
//  afcpromotionVideoVC
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "VideoVC.h"

@interface VideoVC ()
@property (weak, nonatomic) IBOutlet UIButton *btClose;
@property (weak, nonatomic) IBOutlet UIButton *btMail;
@property (weak, nonatomic) IBOutlet VIMVideoPlayerView *uvPlayer;

@property (strong, nonatomic) NSArray * images;
@property (weak, nonatomic) IBOutlet iCarousel *cvCarousel;
@property (weak, nonatomic) IBOutlet UIPageControl *pcPages;
@end


@implementation VideoVC


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:NO];
    [[[self navigationController] navigationItem] setTitle:@"Retour"];

    [[self navigationItem] setTitle:[[self program] name]]; // change le titre de la barre

    UIBarButtonItem * contact = [[UIBarButtonItem alloc] initWithTitle:@"Me contacter" style:UIBarButtonItemStylePlain target:self action:@selector(onMail:)];
    [[self navigationItem] setRightBarButtonItem:contact];
    
    // disable swipe back gesture
    if ([[self navigationController] respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        [[[self navigationController] view] removeGestureRecognizer:[[self navigationController] interactivePopGestureRecognizer]];
    }
    
    // change le titre de "< Back" pour les PROCHAINS UiViewController qui seront PUSHED
    UIBarButtonItem * bbi = [[UIBarButtonItem alloc]initWithTitle:[self isVideo] ? @"Vidéo" : @"Images" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    [[self navigationItem] setBackBarButtonItem:bbi];
    
    // ui
    [[self pcPages] setPageIndicatorTintColor:[UIColor colorWithWhite:0.0 alpha:0.4]];
    [[self pcPages] setCurrentPageIndicatorTintColor:FLASH_COLOR];
    [[[self btMail] layer] setBorderWidth:2];
    [[[self btMail] layer] setBorderColor:[UIColor whiteColor].CGColor];
    [[[self btMail] layer] setCornerRadius:4.0];
    [[self view] setBackgroundColor:BG_COLOR];
    

    // video
    [[[self uvPlayer] player] setURL:[NSURL fileURLWithPath:[[self program] video]]];
    [[[self uvPlayer] player] setLooping:YES];
    [[[self uvPlayer] player] disableAirplay];
    [[self uvPlayer] setVideoFillMode:AVLayerVideoGravityResizeAspect];
    [[[self uvPlayer] player] setDelegate:self];
    [[self uvPlayer] setBackgroundColor:[UIColor clearColor]];
    
    // image
    NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[[self program] imageFolder] error:nil];
    NSMutableArray * temp = [NSMutableArray array];
    for(NSString * file in files) {
        UIImage * i = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", [[self program] imageFolder], file]];
        if(i) {
            [temp addObject:i];
        }
    }
    [self setImages:[NSArray arrayWithArray:temp]];
    [[self cvCarousel] setBackgroundColor:[UIColor clearColor]];
    [[self cvCarousel] setDelegate:self];
    [[self cvCarousel] setDataSource:self];
    [[self cvCarousel] setBounceDistance:0.2];
    [[self cvCarousel] setType:iCarouselTypeLinear];
    [[self cvCarousel] setScrollSpeed:0.4];

    [[self pcPages] setNumberOfPages:[[self images] count]];
    [[self pcPages] setCurrentPage:0];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [[self pcPages] setHidden:[self isVideo]];
    [[self cvCarousel] setHidden:[self isVideo]];
    [[self uvPlayer] setHidden:![self isVideo]];
}


- (void)viewWillDisappear:(BOOL)animated {
//    [[[self uvPlayer] player] pause];
}


- (IBAction)onClose:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}


- (IBAction)onMail:(id)sender {
//    ContactVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idContactVC"];
//    [vc setProgram:[self program]];
//    [[self navigationController] pushViewController:vc animated:YES];
    
    FormVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idFormVC"];
    [vc setProgram:[self program]];
    [[self navigationController] pushViewController:vc animated:YES];
}



// ==========================================================================
#pragma mark - VIMVideoPlayerDelegate
// ==========================================================================
- (void)videoPlayerIsReadyToPlayVideo:(VIMVideoPlayer *)videoPlayer {
    if([self isVideo]) {
        [[[self uvPlayer] player] play];
    }
}
- (void)videoPlayerDidReachEnd:(VIMVideoPlayer *)videoPlayer {
    
}
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer timeDidChange:(CMTime)cmTime {
    
}
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer loadedTimeRangeDidChange:(float)duration {
    
}
- (void)videoPlayerPlaybackBufferEmpty:(VIMVideoPlayer *)videoPlayer {
    
}
- (void)videoPlayerPlaybackLikelyToKeepUp:(VIMVideoPlayer *)videoPlayer {
    
}
- (void)videoPlayer:(VIMVideoPlayer *)videoPlayer didFailWithError:(NSError *)error {
    [SVProgressHUD showErrorWithStatus:[error description]];
}


// ==========================================================================
#pragma mark - MailManagerDelegate
// ==========================================================================
- (void)onMailSent:(NSError *)aError {
    [MailManager presentEmailUI:[self program] inViewController:self];
}


// ==========================================================================
#pragma mark - iCarouselDataSource
// ==========================================================================
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
    return [[self images] count];
}


- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    UIImageView * iv = (UIImageView *)view;
    if(iv == nil) {
        iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[self cvCarousel] frame]), CGRectGetHeight([[self cvCarousel] frame]))];
        [iv setBackgroundColor:[UIColor clearColor]];
        [iv setContentMode:UIViewContentModeScaleAspectFit];
        [iv setImage:[[self images] objectAtIndex:index]];
    }
    return iv;
}


// ==========================================================================
#pragma mark - iCarouselDelegate
// ==========================================================================
- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel {
    [[self pcPages] setCurrentPage:[carousel currentItemIndex]];
}


- (CGFloat)carousel:(iCarousel *)aCarousel valueForOption:(iCarouselOption)aOption withDefault:(CGFloat)aValue {
    switch (aOption) {
        case iCarouselOptionSpacing:
            aValue *= 1;
            break;
        case iCarouselOptionVisibleItems:
            aValue = 3;
            break;
        case iCarouselOptionFadeMin:
            aValue = -0.2;
            break;
        case iCarouselOptionFadeMax:
            aValue =  0.2;
            break;
        case iCarouselOptionFadeRange:
            aValue = 2.0;
            break;
        default:
            break;
    }
    return aValue;
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
