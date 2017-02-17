//
//  PinView.h
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"


@protocol PinViewDelegate <NSObject>
- (void)onPictureClicked:(ProgramData *)aProgram;
- (void)onMovieClicked:(ProgramData *)aProgram;
@end



@interface PinView : UIView {
    BOOL mExpanded;
    BOOL mAnimating;
}

@property (strong, nonnull) ProgramData * program;

- (PinView *)initWithFrame:(CGRect)aFrame withLogo:(UIImage *)aLogo withProgram:(ProgramData *)aProgram withDelegate:(id<PinViewDelegate>)aDelegate ;
- (void)collapse;
@end
