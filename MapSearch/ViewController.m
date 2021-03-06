//
//  ViewController.m
//  MapSearch
//
//  Created by dan rudolf on 5/29/14.
//  Copyright (c) 2014 Dan Rudolf. All rights reserved.
//

#import "ViewController.h"
#import "SearchObject.h"

@interface ViewController ()<CLLocationManagerDelegate,MKMapViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property CLLocationManager *myLocation;
@property NSMutableArray *searchResults;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *swipe;
@property CLLocationCoordinate2D current;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.searchResults = [NSMutableArray new];
    self.myLocation = [[CLLocationManager alloc] init];
    self.myLocation.delegate = self;
    [self.myLocation startUpdatingLocation];
    self.mapView.delegate = self;

}

- (void)setMapViewRegion{
    MKCoordinateRegion currentRegion = MKCoordinateRegionMakeWithDistance(self.current, 2000, 2000);
    [self.mapView setRegion:currentRegion animated:YES];

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error set your location on the simulator");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    for (CLLocation *location in locations) {
        
        if (location.horizontalAccuracy < 100 && location.verticalAccuracy < 100) {
            [self.myLocation stopUpdatingLocation];
            self.current = location.coordinate;
            [self setMapViewRegion];
            [self performSearch:location];
            break;
        }
    }
}

- (void)performSearch:(CLLocation *)location{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = self.searchText.text;
    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.015, .015));
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        
        for (MKMapItem *item in response.mapItems) {
            CLLocationDistance distance = [item.placemark.location distanceFromLocation:location] / 1609.34;
            SearchObject *resultAnnotation = [[SearchObject alloc]initWithCoordinate:item.placemark.coordinate andTitle:item.name distance:distance];
            [self.searchResults addObject:resultAnnotation];
            [self.mapView addAnnotation:resultAnnotation];
            NSLog(@"%f",distance);
        }
        
        [self.searchResults sortUsingSelector:@selector(compare:)];
        [self.tableViewOutlet reloadData];
    }];

}

#pragma mark TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.myLocation startUpdatingLocation];
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
            [self.searchResults removeAllObjects];
    NSLog(@"%@",self.searchResults);
    
    return YES;
}

#pragma mark TableviewData/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchObject *object = [self.searchResults objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f Miles", object.howfar];
    cell.textLabel.text = object.title;
    
    return cell;
}
@end
