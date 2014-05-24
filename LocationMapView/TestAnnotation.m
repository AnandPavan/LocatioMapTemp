//
//  TestAnnotation.m
//  LocationMapView
//
//  Created by Anand on 4/29/14.
//  Copyright (c) 2014 Anand. All rights reserved.
//

#import "TestAnnotation.h"

@implementation TestAnnotation

-(id) initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title {
    if ((self = [super init])) {
        self.coordinate =coordinate;
        self.title = title;
    }
    return self;
}

@end
