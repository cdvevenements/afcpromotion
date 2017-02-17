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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    UIImage * logo = [UIImage imageNamed:@"logo"];
    
    // background
    MapData * m = [[DataManager instance] mapData];
//    NSArray * arr = [[m image] componentsSeparatedByString:@"."];
    NSString * path = [NSString stringWithFormat:@"%@/%@", [DataManager dataPath], [m image]];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    [[self ivMap] setImage:image];
    [[self ivMap] setUserInteractionEnabled:YES];
    UIGestureRecognizer * tap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(onMapClicked:)];
//    [[self uvTouch] addGestureRecognizer:tap];
    
    
    
    
    
    // create pins
    CGFloat SZ = 64;
    for(ProgramData * p in [[DataManager instance] programs]) {
        
        
        double x = map([p coord].latitude,
                       MIN([m topleft].latitude, [m bottomright].latitude),
                       MAX([m topleft].latitude, [m bottomright].latitude),
                       CGRectGetMinX([[self ivMap] frame]),
                       CGRectGetMaxX([[self ivMap] frame]));
        double y = map([p coord].longitude,
                       MIN([m topleft].longitude, [m bottomright].longitude),
                       MAX([m topleft].longitude, [m bottomright].longitude),
                       CGRectGetMinY([[self ivMap] frame]),
                       CGRectGetMaxY([[self ivMap] frame]));
        
        
        UglyPinView * pin = [[NSBundle mainBundle] loadNibNamed:@"UglyPinView" owner:self options:nil][0];
        [pin setDelegate:self];
        [pin setProgram:p];
        [pin setFrame:CGRectMake(x, y, CGRectGetWidth([pin frame]), CGRectGetHeight([pin frame]))];

        
//        PinView * pin = [[PinView alloc] initWithFrame:CGRectMake(x - SZ/2, y - SZ/2, SZ, SZ) withLogo:logo withProgram:p withDelegate:self];
        [[self ivMap] addSubview:pin];
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
