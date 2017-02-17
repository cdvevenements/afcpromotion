//
//  UglyPinView.m
//  afcpromotion
//
//  Created by Olivier on 16/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "UglyPinView.h"

@interface UglyPinView ()
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UIButton *btPicture;
@property (weak, nonatomic) IBOutlet UIButton *btMovie;

@end

@implementation UglyPinView

/*
// Only ovenonatomic, rride drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    return [super initWithCoder:aDecoder];
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setProgram:(ProgramData *)aProgram {
    mProgram = aProgram;
    [[self lbName] setText:[aProgram name]];
    [[self lbAddress] setText:[aProgram address]];
}

- (void)setup:(CGRect)aFrame withLogo:(UIImage *)aLogo withProgram:(ProgramData *)aProgram withDelegate:(id<UglyPinViewDelegate>)aDelegate {
    [self setProgram:aProgram];
    [self setDelegate:aDelegate];
}

- (IBAction)onPictureClicked:(id)sender {
    [[self delegate] onPictureClicked:mProgram];
}



- (IBAction)onMovieClicked:(id)sender {
    [[self delegate] onMovieClicked:mProgram];
}



@end
