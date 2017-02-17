//
//  ImageVC.m
//  afcpromotion
//
//  Created by Olivier on 15/02/2017.
//  Copyright © 2017 Olivier. All rights reserved.
//

#import "ImageVC.h"

@interface ImageVC ()
@property (weak, nonatomic) IBOutlet UIButton *btClose;
@property (weak, nonatomic) IBOutlet UIButton *btMail;
@property (strong, nonatomic) NSArray * images;
@property (weak, nonatomic) IBOutlet iCarousel *cvCarousel;
@property (weak, nonatomic) IBOutlet UIPageControl *pcPages;
@end

@implementation ImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];

    // Do any additional setup after loading the view.
    NSArray * paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"jpg" inDirectory:[NSString stringWithFormat:@"%@/images", [[self program] folder]]];
    
    NSMutableArray * temp = [NSMutableArray array];
    for(NSString * path in paths) {
        UIImage * i = [UIImage imageWithContentsOfFile:path];
        if(i) {
            [temp addObject:i];
        }
    }
    [self setImages:[NSArray arrayWithArray:temp]];
    
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    [[self cvCarousel] setBackgroundColor:[UIColor clearColor]];
    [[self cvCarousel] setDelegate:self];
    [[self cvCarousel] setDataSource:self];

    [[self pcPages] setNumberOfPages:[[self images] count]];
    [[self pcPages] setCurrentPage:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClose:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}
- (IBAction)onMail:(id)sender {
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
            aValue *= 1.2;
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
