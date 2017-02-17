//
//  UglyPinView.h
//  afcpromotion
//
//  Created by Olivier on 16/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DataManager.h"

@protocol UglyPinViewDelegate <NSObject>
- (void)onPictureClicked:(ProgramData *)aProgram;
- (void)onMovieClicked:(ProgramData *)aProgram;
@end


@interface UglyPinView : UIView {
    ProgramData * mProgram;
}


//@property (strong, nonnull) ProgramData * program;
@property id<UglyPinViewDelegate> delegate;

- (void)setProgram:(ProgramData *)aProgram;
- (void)setup:(CGRect)aFrame withLogo:(UIImage *)aLogo withProgram:(ProgramData *)aProgram withDelegate:(id<UglyPinViewDelegate>)aDelegate ;

@end
