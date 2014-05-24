//
//  TestViewController.m
//  LocationMapView
//
//  Created by Anand on 4/29/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "TestViewController.h"

#import "TestAnnotation.h"

#define METERS_PER_MILE 1609.344

#define API_KEY_WEATHER @"tadvm8d73tbapaau8cg28wca"

@interface TestViewController ()

@end

@implementation TestViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.mapView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLocation:(NSString *)location{
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            
            NSLog(@"%@", error);
            
        } else {
            
            CLPlacemark *placemark = [placemarks lastObject];
            CLLocationCoordinate2D coordinate1;
            
            coordinate1.latitude = placemark.location.coordinate.latitude; //will returns latitude
            coordinate1.longitude =  placemark.location.coordinate.longitude; //will returns longitude
            
            CLLocationCoordinate2D zoomLocation;
            zoomLocation.latitude = coordinate1.latitude;
            zoomLocation.longitude= coordinate1.longitude;
            // 2
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, METERS_PER_MILE, METERS_PER_MILE);
            [self.mapView setRegion:viewRegion animated:YES];
            
            self.mapView.delegate = self;
            
            TestAnnotation *annotation3 = [[TestAnnotation alloc] initWithCoordinate:coordinate1 title:self.temperature];
            [self.mapView addAnnotation:annotation3];
        }
    }];
    
}
#pragma mark -MapView Delegate Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *identifier = @"TestAnnotation";
    
    MKPinAnnotationView * annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView){
        
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
    }else {
        annotationView.annotation = annotation;
    }
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}


- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    self.mapView.hidden = NO;
    NSString *titleString = searchBar.text;
    
    self.searchedString  = titleString;
    titleString = [titleString stringByReplacingOccurrencesOfString:@" "
                                         withString:@"+"];
    NSString *URLString = [NSString stringWithFormat:@"http://api.worldweatheronline.com/free/v1/weather.ashx?q=%@&format=json&num_of_days=1&key=%@",titleString,API_KEY_WEATHER];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        self.responseData = [[NSMutableData alloc] init];
    }
    
    [searchBar resignFirstResponder];
    
}

#pragma mark -NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:self.responseData
                          options:kNilOptions
                          error:&error];
    
    NSDictionary *weatherData = [json objectForKey:@"data"];
    
    NSArray *currentConditions = [weatherData objectForKey:@"current_condition"];
    
    self.temperature = [[currentConditions objectAtIndex:0] objectForKey:@"temp_C"];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    [self showLocation:self.searchedString];
    
}
@end
