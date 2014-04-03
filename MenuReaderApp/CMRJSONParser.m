//
//  CMRJSONParser.m
//  Menu Reader
//
//  Created by Emily Janzer on 4/2/14.
//  Copyright (c) 2014 Emily Janzer. All rights reserved.
//

#import "CMRJSONParser.h"
#import "CMRSection.h"
#import "CMRImage.h"
#import "CMRDish.h"
#import "CMRReview.h"
#import "CMRTag.h"
#import "CMRTranslation.h"
#import "CMRSimilar.h"

@implementation CMRJSONParser

- (NSMutableArray *)parseJSON:(id)jsonObject withImage:(UIImage *)image {
    NSMutableArray *sectionObjects = [NSMutableArray array];
    
    id object = [jsonObject objectForKey:@"dish"];
    if (object && object != [NSNull null]) {
        NSArray *dishDicts = object;
        NSMutableArray *dishes = [NSMutableArray arrayWithCapacity:[dishDicts count]];
        
        for (NSDictionary *dishDict in dishDicts) {
            NSString *chineseName = dishDict[@"chin_name"];
            NSString *englishName = dishDict[@"eng_name"];
            NSString *pinyin = dishDict[@"pinyin"];
            NSString *dishDescription = dishDict[@"desc"];
            CMRDish *dish = [[CMRDish alloc]initWithChineseName:chineseName englishName:englishName pinyin:pinyin description:dishDescription];
            //CMRDish *dishCell = [[CMRDish alloc] initWithDictionary:dishDict];
            [dishes addObject:dish];
        }
        
        CMRSection *dishSection = [[CMRSection alloc] initWithCells:dishes section:@"Dish" cellId:@"DishCell" type:CMRCellTypeDish];
        
        [sectionObjects addObject:dishSection];
    }
    
    object = [jsonObject objectForKey:@"images"];
    if (object && object != (id)[NSNull null]) {
        NSArray *imageDicts = object;

        NSMutableArray *dishImages = [NSMutableArray arrayWithCapacity:[imageDicts count]];
        
        for (NSDictionary *imageDict in imageDicts) {
            NSData *imageData = [[NSData alloc]initWithBase64EncodedString:[imageDict objectForKey:@"data"] options:NSDataBase64DecodingIgnoreUnknownCharacters];
            UIImage *image = [UIImage imageWithData:imageData];
            CMRImage *dishImage = [[CMRImage alloc] initWithImage:image];
            [dishImages addObject:dishImage];
        }
        CMRSection *dishImageSection = [[CMRSection alloc] initWithCells:dishImages section:@"Images" cellId:@"ImageCell" type:CMRCellTypeImage];
        [sectionObjects addObject:dishImageSection];
    }
    
    object = [jsonObject objectForKey:@"reviews"];
    if (object && object != (id)[NSNull null]) {
        NSArray *reviewDicts = object;

        NSMutableArray *reviews = [NSMutableArray arrayWithCapacity:[reviewDicts count]];
        
        for (NSDictionary *reviewDict in reviewDicts) {
            NSString *username = reviewDict[@"username"];
            NSString *text = reviewDict[@"text"];
            NSString *restaurant = reviewDict[@"restaurant"];
            NSString *date = reviewDict[@"date"];
            CMRReview *review = [[CMRReview alloc]initWithUsername:username text:text restaurant:restaurant date:date];
            //CMRReview *review = [[CMRReview alloc] initWithDictionary:reviewDict];
            [reviews addObject:review];
        }
        
        CMRSection *reviewSection = [[CMRSection alloc] initWithCells:reviews section:@"Reviews" cellId:@"ReviewCell" type:CMRCellTypeReview];
        
        [sectionObjects addObject:reviewSection];
    }
    
    object = [jsonObject objectForKey:@"tags"];
    if (object && object != (id)[NSNull null]) {
        NSArray *tagDicts = object;
        NSMutableArray *tags = [NSMutableArray arrayWithCapacity:[tagDicts count]];
        
        for (NSDictionary *tagDict in tagDicts) {
            NSString *name = tagDict[@"name"];
            NSString *count = tagDict[@"count"];
            NSNumber *idNumber = tagDict[@"id"];
            CMRTag *tag = [[CMRTag alloc] initWithName:name countString:count idNumber:idNumber];
            //CMRTag *tag = [[CMRTag alloc] initWithDictionary:tagDict];
            [tags addObject:tag];
        }
        
        CMRSection *tagSection = [[CMRSection alloc] initWithCells:tags section:@"Tags" cellId:@"TagCell" type:CMRCellTypeTag];
        
        [sectionObjects addObject:tagSection];
    
    }

    object = [jsonObject objectForKey:@"translation"];
    if (object && object != (id)[NSNull null]) {
        NSArray *translationDicts = object;
        NSMutableArray *translations = [NSMutableArray arrayWithCapacity:[translationDicts count]];
        
        for (NSDictionary *translationDict in translationDicts) {
            NSString *chinese = translationDict[@"char"];
            NSString *english = translationDict[@"english"];
            CMRTranslation *translation = [[CMRTranslation alloc] initWithChinese:chinese english:english];
            //CMRTranslation *translation = [[CMRTranslation alloc] initWithDictionary:translationDict];
            [translations addObject:translation];
        }
        
        CMRSection *translationSection = [[CMRSection alloc] initWithCells:translations section:@"Translation" cellId:@"TranslationCell" type:CMRCellTypeTranslation];
        
        [sectionObjects addObject:translationSection];
    
    }

    object = [jsonObject objectForKey:@"similar"];
    if (object && object != (id)[NSNull null]) {
        NSArray *similarDicts = object;
        NSMutableArray *similarDishes = [NSMutableArray arrayWithCapacity:[similarDicts count]];
        
        for (NSDictionary *similarDict in similarDicts) {
            NSString *chinese = similarDict[@"chinese"];
            NSString *english = similarDict[@"english"];
            NSNumber *idNumber = similarDict[@"id"];
            CMRSimilar *similarDish = [[CMRSimilar alloc] initWithChinese:chinese english:english idNumber:idNumber];
            //CMRSimilar *similarDish = [[CMRSimilar alloc] initWithDictionary:similarDict];
            [similarDishes addObject:similarDish];
        }
        
        CMRSection *similarSection = [[CMRSection alloc] initWithCells:similarDishes section:@"Similar Dishes" cellId:@"SimilarCell" type:CMRCellTypeSimilar];
        
        [sectionObjects addObject:similarSection];
    
    }

    return sectionObjects;
}


@end
