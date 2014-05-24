//
//  TestViewController.h
//  LocationMapView
//
//  Created by Anand on 4/29/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface TestViewController : UIViewController <MKMapViewDelegate,UISearchBarDelegate>

@property (weak,   nonatomic) IBOutlet MKMapView   *mapView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSString             *searchedString;
@property (strong, nonatomic) NSMutableData        *responseData;
@property (strong, nonatomic) NSString             *temperature;

- (void)showLocation:(NSString *)location;

@end
