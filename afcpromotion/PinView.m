//
//  PinView.m
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "PinView.h"

#define PULSE_ANIM_KEY      @"pulse"

@interface PinView ()

@property (strong, nonnull) UIButton * mainButton;
@property (strong, nonnull) UIButton * movieButton;
@property (strong, nonnull) UIButton * pictureButton;
@property (strong, nonnull) UILabel * nameLabel;
@property (strong, nonnull) UILabel * addressLabel;
@property (strong, nonnull) id<PinViewDelegate> delegate;





@end

static UIImage * sPicture = nil;
static UIImage * sMovie = nil;



@implementation PinView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (PinView *)initWithFrame:(CGRect)aFrame withLogo:(UIImage *)aLogo withProgram:(ProgramData *)aProgram withDelegate:(id<PinViewDelegate>)aDelegate {
    
    self = [super initWithFrame:aFrame];
    
    mExpanded = NO;
    mAnimating = NO;
    [self setProgram:aProgram];
    
    if(!sPicture) {
        sPicture = [UIImage imageNamed:@"picture"];
    }
    if(!sMovie) {
        sMovie = [UIImage imageNamed:@"movie"];
    }
    
    CGFloat sz = CGRectGetWidth(aFrame);
    CGRectMake(0, 0, sz, sz);
    
    UIButton * bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sz, sz)];
    [bt setBackgroundColor:[UIColor greenColor]];
    [bt setBackgroundImage:aLogo forState:UIControlStateNormal];
    [[bt layer] setCornerRadius:sz / 2];
    [bt addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * pic = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sz, sz)];
    [pic setBackgroundColor:[UIColor greenColor]];
    [pic setBackgroundImage:sPicture forState:UIControlStateNormal];
    [[pic layer] setCornerRadius:sz / 2];
    [pic setAlpha:0];
    [pic addTarget:self action:@selector(onPictureClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * mov = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, sz, sz)];
    [mov setBackgroundColor:[UIColor greenColor]];
    [mov setBackgroundImage:sMovie forState:UIControlStateNormal];
    [[mov layer] setCornerRadius:sz / 2];
    [mov setAlpha:0];
    [mov addTarget:self action:@selector(onMovieClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:pic];
    [self addSubview:mov];
    [self addSubview:bt];
    
    CABasicAnimation * pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulse.duration = .5;
    pulse.toValue = [NSNumber numberWithFloat:1.1];
    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pulse.autoreverses = YES;
    pulse.repeatCount = MAXFLOAT;
    [bt.layer addAnimation:pulse forKey:PULSE_ANIM_KEY];
    
    return self;
}


- (void)onClick:(id)aSender {
    if(!mAnimating) {
        if(mExpanded) {
            [self collapse];
        }
        else {
            [self expand];
        }
    }
}


- (void)onPictureClick:(id)aSender {
    [[self delegate] onPictureClicked:[self program]];
}


- (void)onMovieClick:(id)aSender {
    [[self delegate] onMovieClicked:[self program]];
}


- (void)expand {

//    CABasicAnimation * pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    pulse.duration = .5;
//    pulse.toValue = [NSNumber numberWithFloat:1.1];
//    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pulse.autoreverses = YES;
//    pulse.repeatCount = MAXFLOAT;
//    [bt.layer addAnimation:pulse forKey:PULSE_ANIM_KEY];



}


- (void)collapse {
    
}



@end
