#import <Preferences/Preferences.h>
#import "SKSpecifierParser.h"
#import <objc/runtime.h>

@implementation SKSpecifierParser
+(PSCellType)PSCellTypeFromString:(NSString*)str
{
    if ([str isEqual:@"PSGroupCell"])
        return PSGroupCell;
    if ([str isEqual:@"PSLinkCell"])
        return PSLinkCell;
    if ([str isEqual:@"PSLinkListCell"])
        return PSLinkListCell;
    if ([str isEqual:@"PSListItemCell"])
        return PSListItemCell;
    if ([str isEqual:@"PSTitleValueCell"])
        return PSTitleValueCell;
    if ([str isEqual:@"PSSliderCell"])
        return PSSliderCell;
    if ([str isEqual:@"PSSwitchCell"])
        return PSSwitchCell;
    if ([str isEqual:@"PSStaticTextCell"])
        return PSStaticTextCell;
    if ([str isEqual:@"PSEditTextCell"])
        return PSEditTextCell;
    if ([str isEqual:@"PSSegmentCell"])
        return PSSegmentCell;
    if ([str isEqual:@"PSGiantIconCell"])
        return PSGiantIconCell;
    if ([str isEqual:@"PSGiantCell"])
        return PSGiantCell;
    if ([str isEqual:@"PSSecureEditTextCell"])
        return PSSecureEditTextCell;
    if ([str isEqual:@"PSButtonCell"])
        return PSButtonCell;
    if ([str isEqual:@"PSEditTextViewCell"])
        return PSEditTextViewCell;
    
    return PSGroupCell;
}

+(NSArray*)specifiersFromArray:(NSArray*)array forTarget:(id)target
{
    NSMutableArray *specifiers = [NSMutableArray array];
    for (NSDictionary *dict in array)
    {
        PSCellType cellType = [SKSpecifierParser PSCellTypeFromString:dict[@"cell"]];
        PSSpecifier *spec = nil;
        if (cellType == PSGroupCell)
        {
            if (dict[@"label"] != nil)
            {
                spec = [PSSpecifier groupSpecifierWithName:dict[@"label"]];
                [spec setProperty:dict[@"label"] forKey:@"label"];
            }
            else
                spec = [PSSpecifier emptyGroupSpecifier];
            
            [spec setProperty:@"PSGroupCell" forKey:@"cell"];
        }
        else
        {
            NSString *label = dict[@"label"] == nil ? @"" : dict[@"label"];
            Class detail = dict[@"detail"] == nil ? nil : objc_getClass([dict[@"detail"] cString]);
            Class edit = dict[@"pane"] == nil ? nil : objc_getClass([dict[@"pane"] cString]);
            spec = [PSSpecifier preferenceSpecifierNamed:label target:target set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:detail cell:cellType edit:edit];
            for (NSString *key in dict)
            {
                if ([key isEqual:@"cellClass"])
                {
                    const char *s = [dict[key] cString];
                    [spec setProperty:objc_getClass(s) forKey:key];
                }
                else
                    [spec setProperty:dict[key] forKey:key];
            }
        }
        
        
        if (dict[@"icon"])
            [spec setupIconImageWithPath:dict[@"icon"]];
        if (dict[@"id"])
            [spec setProperty:dict[@"id"] forKey:@"id"];
        else
            [spec setProperty:dict[@"label"] forKey:@"id"];
        spec.target = target;
        
        [specifiers addObject:spec];
    }
    return specifiers;
}
@end