//
//  SearchObject.h
//  MapSearch
//
//  Created by dan rudolf on 5/29/14.
//  Copyright (c) 2014 Dan Rudolf. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SearchObject : MKPointAnnotation
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) CLLocationDistance howfar;

- (SearchObject *)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title distance:(CLLocationDistance)distance;

@end
