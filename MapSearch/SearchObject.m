//
//  SearchObject.m
//  MapSearch
//
//  Created by dan rudolf on 5/29/14.
//  Copyright (c) 2014 Dan Rudolf. All rights reserved.
//

#import "SearchObject.h"

@implementation SearchObject

- (SearchObject *)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString *)title distance:(CLLocationDistance)distance{
    self.howfar = distance;
    self.coordinate = coordinate;
    self.title = title;

  return self;
}

- (NSComparisonResult)compare:(SearchObject *)that
{
    if (self.howfar < that.howfar)
        return NSOrderedAscending;
    else
        return NSOrderedDescending;
}


@end
