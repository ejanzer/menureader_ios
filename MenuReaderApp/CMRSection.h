//
//  CMRSection.h
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMRSection : NSObject

typedef NS_ENUM(NSInteger, CMRCellType) {
    CMRCellTypeImage,
    CMRCellTypeDish,
    CMRCellTypeReview,
    CMRCellTypeTag,
    CMRCellTypeTranslation,
    CMRCellTypeSimilar
};

@property CMRCellType type;

@property NSString *cellIdentifier;
@property NSString *sectionTitle;
@property NSArray *cells;

-(id)initWithCells:(NSArray *)data section:(NSString *)sectionTitle cellId:(NSString *)cellIdentifier type:(CMRCellType)cellType;

-(NSInteger)getNumberOfRows;

-(NSObject *)getCellForRow:(NSUInteger)row;

@end
