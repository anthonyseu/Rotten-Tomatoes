//
//  MovieListViewController.m
//  Rotten Tomatoes
//
//  Created by Li Jiao on 1/25/15.
//  Copyright (c) 2015 Li Jiao. All rights reserved.
//

#import "MovieListViewController.h"
#import "MovieTableViewCell.h"
#import "MovieDetailViewController.h"
#import "JGProgressHUD.h"

@interface MovieListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *movieListTableView;
@property (nonatomic, strong) NSArray *movieArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) JGProgressHUD *HUD;
@property (weak, nonatomic) IBOutlet UILabel *networkErrorLabel;
@property (weak, nonatomic) NSString *searchText;
@property (weak, nonatomic) IBOutlet UISearchBar *movieSearchBar;
@property (weak, nonatomic) NSArray *searchResults;
@end

@implementation MovieListViewController

- (void)viewDidLoad {
    // view default settings
    self.title = @"Movies";
    
    // table view setting
    self.movieListTableView.dataSource = self;
    self.movieListTableView.delegate = self;
    self.movieListTableView.rowHeight = 110;
    
    // register the list cell
    UINib *myCellNib = [UINib nibWithNibName:@"MovieTableViewCell" bundle:nil];
    [self.movieListTableView registerNib:myCellNib forCellReuseIdentifier:@"MovieTableViewCell"];
    
    // UI pull refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.movieListTableView insertSubview:self.refreshControl atIndex:0];

    // load the data first
    [self doLoadData];
    
    // HUD setting
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = @"Loading";
    [self.HUD showInView:self.view];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movieArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell" forIndexPath:indexPath];
    
    NSDictionary *obj = self.movieArray[indexPath.row];
    NSString *urlString = [obj valueForKeyPath:@"posters.thumbnail"];

    [cell.thumbnailPoster setImageWithURL:[NSURL URLWithString:urlString]];
    [cell.movieTitle setText:[obj valueForKeyPath:@"title"]];
    [cell.movieYear setText:[NSString stringWithFormat: @"%@", [obj valueForKey:@"year"]]];
    [cell.movieRuntime setText:[NSString stringWithFormat: @"%@min", [obj valueForKey:@"runtime"]]];
    [cell.movieSynopsis setText:[obj valueForKey:@"synopsis"]];
    
    return cell;
}

- (void)onRefresh {
    [self doLoadData];
}

- (void)doLoadData {
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=28rdf5pc7pkc38v7mvnrtsb4"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            // fade in network error message if it's hidden
            if (self.networkErrorLabel.hidden) {
                // QUESTION: is this the right way to fade in a hidden view?
                self.networkErrorLabel.hidden = NO;
                self.networkErrorLabel.alpha = 0.0;
                [UIView animateWithDuration:0.2 animations:^{
                    self.networkErrorLabel.alpha = 1.0;
                }];
            }
        } else {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movieArray = (NSArray *)[responseDictionary valueForKeyPath:@"movies"];
            self.networkErrorLabel.hidden = YES;
            [self.movieListTableView reloadData];
        }
        [self.HUD dismiss];
        [self.refreshControl endRefreshing];

    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.movieListTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIImageView *thumbImageView = ((MovieTableViewCell *)[tableView cellForRowAtIndexPath:indexPath]).thumbnailPoster;
    UIImage *thumbImage = thumbImageView.image;
    
    MovieDetailViewController *detailController = [[MovieDetailViewController alloc] init];
    NSDictionary *obj = self.movieArray[indexPath.row];
    detailController.movieObj = obj;
    detailController.thumbImage = thumbImage;
    
    [self.navigationController pushViewController:detailController animated:YES];
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
