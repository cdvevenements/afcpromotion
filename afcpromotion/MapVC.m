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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    UIImage * logo = [UIImage imageNamed:@"logo_round"];
    
    // background
    MapData * m = [[DataManager instance] mapData];
//    NSArray * arr = [[m image] componentsSeparatedByString:@"."];
    NSString * path = [NSString stringWithFormat:@"%@/%@", [DataManager dataPath], [m image]];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    [[self ivMap] setImage:image];
    [[self ivMap] setUserInteractionEnabled:YES];
//    UIGestureRecognizer * tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(onMapClicked:)];
//    [[self uvTouch] addGestureRecognizer:tap];
    
    
    
    // create pins
    CGFloat SZ = 64;
    int idx = 0;
    for(ProgramData * p in [[DataManager instance] programs]) {

        double x = map([p coord].longitude,
                       MIN([m topleft].longitude, [m bottomright].longitude),
                       MAX([m topleft].longitude, [m bottomright].longitude),
                       CGRectGetMinX([[self ivMap] frame]),
                       CGRectGetMaxX([[self ivMap] frame]));
        
        double y = map([p coord].latitude,
                       MIN([m topleft].latitude, [m bottomright].latitude),
                       MAX([m topleft].latitude, [m bottomright].latitude),
                       CGRectGetMaxY([[self ivMap] frame]),
                       CGRectGetMinY([[self ivMap] frame]));
        
        
        UIButton * pin = [[UIButton alloc] initWithFrame:CGRectMake(x - SZ/2, y - SZ/2, SZ, SZ)];
        [pin setBackgroundColor:BG_COLOR];
        [pin setImage:logo forState:UIControlStateNormal];
        [pin setTag:idx];
        [[pin layer] setCornerRadius:SZ / 2];
        [pin addTarget:self action:@selector(onPinClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CABasicAnimation * pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        pulse.duration = .5;
        pulse.toValue = [NSNumber numberWithFloat:1.1];
        pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pulse.autoreverses = YES;
        pulse.repeatCount = MAXFLOAT;
        [[pin layer] addAnimation:pulse forKey:@"PULSE_ANIM_KEY"];

        

        [[self ivMap] addSubview:pin];
        idx++;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onMapClicked:(id)aSender {
    for(UIView * pin in [[self ivMap] subviews]) {
        if([pin isKindOfClass:[PinView class]]) {
            [(PinView *)pin collapse];
        }
    }
}


- (void)onPinClicked:(id)aSender {
    
    UIButton * pin = (UIButton *)aSender;
    ProgramData * program = [[[DataManager instance] programs] objectAtIndex: [pin tag]];
    
    UIAlertController * contents = [UIAlertController alertControllerWithTitle:[program name] message:[program address] preferredStyle:UIAlertControllerStyleActionSheet];
    [contents addAction:[UIAlertAction actionWithTitle:@"Voir la vidéo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMedia:program isVideo:YES];
    }]];
    [contents addAction:[UIAlertAction actionWithTitle:@"Voir les images" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showMedia:program isVideo:NO];
    }]];
    
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


// ==========================================================================
#pragma mark - PinViewDelegate
// ==========================================================================
- (void)onPictureClicked:(ProgramData *)aProgram {
//    ImageVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idImageVC"];
//    [vc setProgram:aProgram];
//    [[self navigationController] pushViewController:vc animated:YES];
    VideoVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idVideoVC"];
    [vc setIsVideo:NO];
    [vc setProgram:aProgram];
    [[self navigationController] pushViewController:vc animated:YES];


}

- (void)onMovieClicked:(ProgramData *)aProgram {
    VideoVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idVideoVC"];
    [vc setIsVideo:YES];
    [vc setProgram:aProgram];
    [[self navigationController] pushViewController:vc animated:YES];
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
