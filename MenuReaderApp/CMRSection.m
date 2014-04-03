//
//  CMRSection.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRSection.h"
#import "CMRDish.h"

@implementation CMRSection

-(instancetype)initWithCells:(NSArray *)cells section:(NSString *)sectionTitle cellId:(NSString *)cellIdentifier type:(CMRCellType)type{
    self.cells = cells;
    self.sectionTitle = sectionTitle;
    self.cellIdentifier = cellIdentifier;
    self.type = type;
    
    return self;
}

-(NSInteger)getNumberOfRows {
    return [self.cells count];
}

-(id)cellForRow:(NSUInteger)row {
    return [self.cells objectAtIndex:row];
}

@end
