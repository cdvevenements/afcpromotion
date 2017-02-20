//
//  MapVC.m
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "MapVC.h"

@interface MapVC ()
@property (weak, nonatomic) IBOutlet UIImageView *ivMap;
@end

@implementation MapVC


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self startAnimation];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage * logo = [UIImage imageNamed:@"logo_round"];
    
    // background
    MapData * m = [[DataManager instance] mapData];
//    NSArray * arr = [[m image] componentsSeparatedByString:@"."];
    NSString * path = [NSString stringWithFormat:@"%@/%@", [DataManager dataPath], [m image]];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    [[self ivMap] setImage:image];
//    [[self ivMap] setUserInteractionEnabled:YES];
//    UIGestureRecognizer * tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(onMapClicked:)];
//    [[self uvTouch] addGestureRecognizer:tap];
    
    // change le titre de "< Back" pour les PROCHAINS UiViewController qui seront PUSHED
    UIBarButtonItem * bbi = [[UIBarButtonItem alloc]initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    [[self navigationItem] setBackBarButtonItem:bbi];

    [[UINavigationBar appearance] setBarTintColor:BG_COLOR];
    [[UINavigationBar appearance] setTintColor:FG_COLOR];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: FONT_BOLD(FONT_SZ_MEDIUM)}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: FONT_BOLD(FONT_SZ_MEDIUM), NSForegroundColorAttributeName: FG_COLOR} forState:UIControlStateNormal];

    
    
    // create pins
    CGFloat SZ = 64;
    int idx = 0;
    for(ProgramData * p in [[DataManager instance] programs]) {

        double x = map([p coord].longitude,
                       MIN([m topleft].longitude, [m bottomright].longitude),
                       MAX([m topleft].longitude, [m bottomright].longitude),
                       CGRectGetMinX([[self view] frame]),
                       CGRectGetMaxX([[self view] frame]));
        
        double y = map([p coord].latitude,
                       MIN([m topleft].latitude, [m bottomright].latitude),
                       MAX([m topleft].latitude, [m bottomright].latitude),
                       CGRectGetMaxY([[self view] frame]),
                       CGRectGetMinY([[self view] frame]));
        
        
        UIButton * pin = [[UIButton alloc] initWithFrame:CGRectMake(x - SZ/2, y - SZ/2, SZ, SZ)];
        [pin setBackgroundColor:BG_COLOR];
        [pin setImage:logo forState:UIControlStateNormal];
        [pin setTag:idx];
        [[pin layer] setCornerRadius:SZ / 2];
        [pin addTarget:self action:@selector(onPinClicked:) forControlEvents:UIControlEventTouchUpInside];
        
//        CABasicAnimation * pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        pulse.duration = .5;
//        pulse.toValue = [NSNumber numberWithFloat:1.1];
//        pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        pulse.autoreverses = YES;
//        pulse.repeatCount = MAXFLOAT;
//        [[pin layer] addAnimation:pulse forKey:@"PULSE_ANIM_KEY"];
//
        [[self view] addSubview:pin];
        idx++;
    }
}


- (void)startAnimation {
    for(UIView * v in [[self view] subviews]) {
        if([v isKindOfClass:[UIButton class]]) {
            CABasicAnimation * pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            pulse.duration = .5;
            pulse.toValue = [NSNumber numberWithFloat:1.1];
            pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pulse.autoreverses = YES;
            pulse.repeatCount = MAXFLOAT;
            [[v layer] addAnimation:pulse forKey:@"PULSE_ANIM_KEY"];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)onMapClicked:(id)aSender {
//    for(UIView * pin in [[self ivMap] subviews]) {
//        if([pin isKindOfClass:[PinView class]]) {
//            [(PinView *)pin collapse];
//        }
//    }
//}


- (void)onPinClicked:(id)aSender {
    
    UIButton * pin = (UIButton *)aSender;
    ProgramData * program = [[[DataManager instance] programs] objectAtIndex: [pin tag]];
    
    UIAlertController * contents = [UIAlertController alertControllerWithTitle:[program name] message:[program address] preferredStyle:UIAlertControllerStyleActionSheet];
    
    // show video
    UIAlertAction * video = [UIAlertAction actionWithTitle:@"Voir la vidéo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMedia:program isVideo:YES];
    }];
    
    [video setValue:[UIImage imageNamed:@"movie32"] forKey:@"image"];
    [contents addAction:video];
    
    // show pictures
    UIAlertAction * picture = [UIAlertAction actionWithTitle:@"Voir les images" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMedia:program isVideo:NO];
    }];
    [picture setValue:[UIImage imageNamed:@"picture32"] forKey:@"image"];
    [contents addAction:picture];
    
    // custom title
    NSMutableAttributedString * title = [[NSMutableAttributedString alloc] initWithString:[program name]];
    [title addAttribute:NSFontAttributeName value:FONT_BOLD(FONT_SZ_LARGE) range:NSMakeRange(0, [[program name] length])];
    [title addAttribute:NSForegroundColorAttributeName value:FG_COLOR range:NSMakeRange(0, [[program name] length])];
    [contents setValue:title forKey:@"attributedTitle"];
    
    // custom message
    NSMutableAttributedString * message = [[NSMutableAttributedString alloc] initWithString:[program address]];
    [message addAttribute:NSFontAttributeName value:FONT(FONT_SZ_MEDIUM) range:NSMakeRange(0, [[program address] length])];
    [message addAttribute:NSForegroundColorAttributeName value:FG_COLOR range:NSMakeRange(0, [[program address] length])];
    [contents setValue:message forKey:@"attributedMessage"];

    // embed in popover
    [[contents popoverPresentationController] setSourceView:pin];
    [[contents popoverPresentationController] setSourceRect:[pin bounds]];
    [[contents popoverPresentationController] setPermittedArrowDirections:UIPopoverArrowDirectionAny];

    [self presentViewController:contents animated:YES completion:^{
        ;
    }];
}



- (void)showMedia:(ProgramData *)aProgram isVideo:(BOOL)aIsVideo {
    VideoVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idVideoVC"];
    [vc setIsVideo:aIsVideo];
    [vc setProgram:aProgram];
    [[self navigationController] pushViewController:vc animated:YES];
}


//// ==========================================================================
//#pragma mark - PinViewDelegate
//// ==========================================================================
//- (void)onPictureClicked:(ProgramData *)aProgram {
////    ImageVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idImageVC"];
////    [vc setProgram:aProgram];
////    [[self navigationController] pushViewController:vc animated:YES];
//    VideoVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idVideoVC"];
//    [vc setIsVideo:NO];
//    [vc setProgram:aProgram];
//    [[self navigationController] pushViewController:vc animated:YES];
//
//
//}
//
//- (void)onMovieClicked:(ProgramData *)aProgram {
//    VideoVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idVideoVC"];
//    [vc setIsVideo:YES];
//    [vc setProgram:aProgram];
//    [[self navigationController] pushViewController:vc animated:YES];
//}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
