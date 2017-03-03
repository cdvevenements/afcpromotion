//
//  MapVC.m
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "MapVC.h"

@interface MapVC ()
@property (weak, nonatomic) IBOutlet UIView *ivSponsors;
@property (weak, nonatomic) IBOutlet UIImageView *ivMap;
//@property (weak, nonatomic) IBOutlet UIImageView *logo1;
//@property (weak, nonatomic) IBOutlet UIImageView *logo3;
//@property (weak, nonatomic) IBOutlet UIImageView *logo4;
@property (weak, nonatomic) IBOutlet UIButton *btSponsors;
//@property (weak, nonatomic) IBOutlet UIImageView *logo2;
@end


#define TAG_OFFSET_PROGRAM  (0)
#define TAG_OFFSET_AGENCY   (256)
#define TAG_OFFSET_SPONSOR  (512)

@implementation MapVC


- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [self startAnimation];
}


- (UIImage *)gsImage:(UIImage *)inputImage {
//    UIImage *inputImage = [UIImage imageNamed:@"inputimage.png"];
    GPUImageGrayscaleFilter *grayscaleFilter = [[GPUImageGrayscaleFilter alloc] init];
    return [grayscaleFilter imageByFilteringImage:inputImage];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // background
    NSString * path = [NSString stringWithFormat:@"%@/%@", [DataManager dataPath], [[[DataManager instance] mapData] image]];
    UIImage * image = [UIImage imageWithContentsOfFile:path];
    [[self ivMap] setImage:image];
    
    // change le titre de "< Back" pour les PROCHAINS UiViewController qui seront PUSHED
    UIBarButtonItem * bbi = [[UIBarButtonItem alloc]initWithTitle:@"Retour" style:UIBarButtonItemStylePlain target:self action:@selector(pop)];
    [[self navigationItem] setBackBarButtonItem:bbi];

    [[UINavigationBar appearance] setBarTintColor:BG_COLOR];
    [[UINavigationBar appearance] setTintColor:FG_COLOR];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName: FONT_BOLD(FONT_SZ_MEDIUM)}];
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName: FONT_BOLD(FONT_SZ_MEDIUM), NSForegroundColorAttributeName: FG_COLOR} forState:UIControlStateNormal];

    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat sz = screenBounds.size.width / 16;
    
    
    [self addPins:[[DataManager instance] programs] logo:[UIImage imageNamed:@"logo_round"] size:sz tagOffset:TAG_OFFSET_PROGRAM];
    [self addPins:[[DataManager instance] agencies] logo:[UIImage imageNamed:@"logo_inv_round"] size:sz tagOffset:TAG_OFFSET_AGENCY];
    [self addPins:[[DataManager instance] sponsors] logo:[UIImage imageNamed:@"logo_sponsor_round"] size:sz tagOffset:TAG_OFFSET_SPONSOR];
    
    
    for(UIView * v in [[self ivSponsors] subviews]) {
        if([v isKindOfClass:[UIImageView class]]) {
            [(UIImageView*)v setImage: [self gsImage:[(UIImageView*)v image]]];
        }
    }
    
    
    CGAffineTransform t  = CGAffineTransformMakeTranslation(-1 * (CGRectGetWidth([[self view] frame])) ,0);
    [[self ivSponsors] setTransform:t];
    [[self ivSponsors] setAlpha:0.0];
    [[self view] bringSubviewToFront: [self ivSponsors]];
}



- (void)addPins:(NSArray *)aData logo:(UIImage *)aLogo size:(CGFloat)aSize tagOffset:(NSUInteger)aOffset {
    // create pins
    int idx = 0;
    MapData * m = [[DataManager instance] mapData];
    for(ProgramData * p in aData) {
        
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
        
        
        UIButton * pin = [[UIButton alloc] initWithFrame:CGRectMake(x - aSize/2, y - aSize/2, aSize, aSize)];
        [pin setBackgroundColor:BG_COLOR];
        
        if([p isKindOfClass:[SponsorData class]]) {
            aLogo = [(SponsorData *)p icon];
        }
        
        [pin setImage:aLogo forState:UIControlStateNormal];
        [pin setTag:aOffset + idx];
        [[pin layer] setCornerRadius:aSize / 2];
        [pin addTarget:self action:@selector(onPinClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [[self view] addSubview:pin];
        idx++;
    }
}



- (void)startAnimation {
    for(UIView * v in [[self view] subviews]) {
        if([v isKindOfClass:[UIButton class]] && [v tag] < TAG_OFFSET_AGENCY && v != [self btSponsors]) {
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


- (void)onPinClicked:(id)aSender {
    
    UIButton * pin = (UIButton *)aSender;
    ProgramData * program = nil;
    BOOL showContact = YES;
    
    if([pin tag] < TAG_OFFSET_AGENCY) {
        program = [[[DataManager instance] programs] objectAtIndex: [pin tag]];
    }
    else if([pin tag] < TAG_OFFSET_SPONSOR) {
        program = [[[DataManager instance] agencies] objectAtIndex: [pin tag] - TAG_OFFSET_AGENCY];
    }
    else {
        program = [[[DataManager instance] sponsors] objectAtIndex: [pin tag] - TAG_OFFSET_SPONSOR];
        showContact=NO;
//        [self hackySponsor:sp sourcePin:pin];
//           program = [[[DataManager instance] agencies] objectAtIndex: [pin tag] - TAG_OFFSET_SPONSOR];
    }
    
    UIAlertController * contents = [UIAlertController alertControllerWithTitle:[program name] message:[program address] preferredStyle:UIAlertControllerStyleActionSheet];
    
    // show video
    if([program hasVideo]) {
        UIAlertAction * video = [UIAlertAction actionWithTitle:@"Voir la vidéo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMedia:program isVideo:YES showContact:showContact];
        }];
        
        [video setValue:[UIImage imageNamed:@"movie32"] forKey:@"image"];
        [contents addAction:video];
    }
    
    // show pictures
    if([program hasPictures]) {
        UIAlertAction * picture = [UIAlertAction actionWithTitle:@"Voir les images" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showMedia:program isVideo:NO showContact:showContact];
        }];
        [picture setValue:[UIImage imageNamed:@"picture32"] forKey:@"image"];
        [contents addAction:picture];
    }
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
    
    
    [[contents view] setTintColor:FLASH_COLOR];

    [self presentViewController:contents animated:YES completion:^{
        [self hackFont:[contents view] firstCall:YES];
    }];
}

/// CRADO LOLOLOL
- (void)hackFont:(UIView *)parent firstCall:(BOOL)aCall {
    
    static int idx = 0;
    if(aCall) {
        idx = 0;
    }
    for(UIView * v in [parent subviews]) {
        if([v isKindOfClass:[UILabel class]] && ++idx > 2) {
            [(UILabel *)v setFont:FONT(FONT_SZ_LARGE)];
        }
        [self hackFont:v firstCall:NO];
    }
}


- (void)hackySponsor:(SponsorData *)aSponsor sourcePin:(UIView *)aPin {
    UIAlertController * contents = [UIAlertController alertControllerWithTitle:[aSponsor name] message:[aSponsor address] preferredStyle:UIAlertControllerStyleActionSheet];
    
    // show web
    UIAlertAction * picture = [UIAlertAction actionWithTitle:@"Voir la vidéo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        WebVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idWebVC"];
        [vc setTitle:[aSponsor name]];
        [vc setUrl:[aSponsor url]];
        [[self navigationController] pushViewController:vc animated:YES];
    }];
    [picture setValue:[UIImage imageNamed:@"hand32"] forKey:@"image"];
    
    [[contents view] setTintColor:FLASH_COLOR];
    
//    NSString * str = @"Voir le site web";
//    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:str];
//    [attr addAttribute:NSFontAttributeName value:FONT(FONT_SZ_MEDIUM) range:NSMakeRange(0, [str length])];
//    [attr addAttribute:NSForegroundColorAttributeName value:FLASH_COLOR range:NSMakeRange(0, [str length])];
//    [picture setValue:attr forKey:@"attributedTitle"];
    
    [contents addAction:picture];

    // custom title
    NSMutableAttributedString * title = [[NSMutableAttributedString alloc] initWithString:[aSponsor name]];
    [title addAttribute:NSFontAttributeName value:FONT_BOLD(FONT_SZ_LARGE) range:NSMakeRange(0, [[aSponsor name] length])];
    [title addAttribute:NSForegroundColorAttributeName value:FG_COLOR range:NSMakeRange(0, [[aSponsor name] length])];
    [contents setValue:title forKey:@"attributedTitle"];
    
    // custom message
    NSMutableAttributedString * message = [[NSMutableAttributedString alloc] initWithString:[aSponsor address]];
    [message addAttribute:NSFontAttributeName value:FONT(FONT_SZ_MEDIUM) range:NSMakeRange(0, [[aSponsor address] length])];
    [message addAttribute:NSForegroundColorAttributeName value:FG_COLOR range:NSMakeRange(0, [[aSponsor address] length])];
    [contents setValue:message forKey:@"attributedMessage"];
    
    // embed in popover
    [[contents popoverPresentationController] setSourceView:aPin];
    [[contents popoverPresentationController] setSourceRect:[aPin bounds]];
    [[contents popoverPresentationController] setPermittedArrowDirections:UIPopoverArrowDirectionAny];
    
    

    
    [self presentViewController:contents animated:YES completion:^{
        // hacky hacky
        [self hackFont:[contents view] firstCall:YES];

    }];

    
}


- (void)showMedia:(ProgramData *)aProgram isVideo:(BOOL)aIsVideo showContact:(BOOL)aContact {
    VideoVC * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"idVideoVC"];
    [vc setIsVideo:aIsVideo];
    [vc setProgram:aProgram];
    [vc setShowContact:aContact];
    [[self navigationController] pushViewController:vc animated:YES];
}


- (IBAction)onSponsorsClicked:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [[self ivSponsors] setAlpha:1.0];
        CGAffineTransform t  = CGAffineTransformMakeTranslation(0, 0);
        [[self ivSponsors] setTransform:t];

    } completion:^(BOOL finished) {
        if(finished) {
            [[self ivMap] setUserInteractionEnabled:YES];
            [[self ivMap] addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onMapClicked:)]];
        }
    }];
    
}


- (IBAction)onMapClicked:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        [[self ivSponsors] setAlpha:0.0];
        CGAffineTransform t  = CGAffineTransformMakeTranslation(-1 * (CGRectGetWidth([[self view] frame])) ,0);
        [[self ivSponsors] setTransform:t];
    }];
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
