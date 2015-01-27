//
//  MovieDetailViewController.m
//  Rotten Tomatoes
//
//  Created by Li Jiao on 1/25/15.
//  Copyright (c) 2015 Li Jiao. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgoundPoster;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsis;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    // background image
    NSString *thumbUrl = [self.movieObj valueForKeyPath:@"posters.original"];
    NSString *oriUrl = [thumbUrl stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    
    [self.backgoundPoster setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:oriUrl]] placeholderImage:self.thumbImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.backgoundPoster.image = image;
    } failure:nil];
    
//    [self.backgoundPoster setImageWithURL:[NSURL URLWithString:oriUrl]];
    
    // view title
    self.title = [self.movieObj valueForKeyPath:@"title"];
    
    // movie detail
    [self.movieTitle setText:[self.movieObj valueForKeyPath:@"title"]];
    [self.movieSynopsis setText:[self.movieObj valueForKeyPath:@"synopsis"]];
    [self.movieSynopsis sizeToFit];
    
    // scroll view
    CGRect newBackgroundViewFrame = self.backgroundView.frame;
    newBackgroundViewFrame.size.height = self.movieSynopsis.frame.origin.y + self.movieSynopsis.frame.size.height + 200;
    self.backgroundView.frame = newBackgroundViewFrame;
    [self.detailScrollView setContentSize:CGSizeMake(self.detailScrollView.frame.size.width, self.backgroundView.frame.origin.y + self.backgroundView.frame.size.height - 180)];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
