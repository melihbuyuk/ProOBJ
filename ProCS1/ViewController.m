//
//  ViewController.m
//  ProCS1
//
//  Created by Serhat Akkurt on 14.02.2020.
//  Copyright © 2020 Serhat Akkurt. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak) IBOutlet UITextView *txtMsg;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

// MARK: Button Actions
- (IBAction)btnAction: (id)sender {
    NSMutableString* txt = [NSMutableString new];
    if ([sender tag] == 1) { //@"Expand Numbers";
        NSArray* arr = @[@23, @44, @4, @149, @609, @20307];
        for (NSNumber* nbr in arr) {
            int i = [nbr intValue];
            NSString* str = [self expandNumber:i];
            [txt appendString:[NSString stringWithFormat:@"%d : %@\n", i, str]];
        }
    } else if ([sender tag] == 2) { //@"Prime Numbers";
        NSArray* arr = @[@11, @24, @44];
        for (NSNumber* nbr in arr) {
            int i = [nbr intValue];
            NSArray* arr = [self findPrimeNumbersUpTo:i];
            [txt appendString:[NSString stringWithFormat:@"%@", arr]];
        }
    } else { //@"Stringify Object for Graphql";
        NSDictionary* dict = [self getSampleDict];
        NSString* str = [self collectKeysOfObject:dict];
        [txt appendString:str];
    }
    NSLog(@"%@", txt);
    _txtMsg.text = txt;
}

// MARK: Expand Number
- (NSString*)expandNumber: (int)number {
    NSString* str = @"";
    if (number > 0) {
        NSMutableArray *array = [NSMutableArray new];
        NSString *nmb = [NSString stringWithFormat: @"%d", number];
        for (int i = 0; i < nmb.length; i++) {
            NSString *ch = [nmb substringWithRange:NSMakeRange(i, 1)];
            if (![ch isEqualToString:@"0"]) {
                long zeroCount = nmb.length - i - 1;
                NSString* txt = [NSString stringWithFormat:@"%@%@", ch, [self getZero:zeroCount]];
                [array addObject:txt];
            }
        }
        str = [array componentsJoinedByString:@" + "];
    }
    return str;
}
//return zero given count
- (NSString*)getZero: (long)number {
    NSMutableString* zeros = [NSMutableString new];
    for (int i=0; i<number; i++) {
        [zeros appendString:@"0"];
    }
    return zeros;
}

// MARK: Prime Numbers
- (NSArray<NSNumber*>*)findPrimeNumbersUpTo: (int)number {
    NSMutableArray *array = [NSMutableArray new];
    for (int i=2; i<=number; i++) {
        bool isPrime = [self isPrimeNumber:i];
        if (isPrime) {
            [array addObject:[NSNumber numberWithInteger:i]];
        }
    }
    return array;
}
//check if prime
- (BOOL)isPrimeNumber: (int)number {
    BOOL isPrime = true;
    for (int i=2; i<number-1; i++) {
        if (number % i == 0){
            isPrime=false;
            break;
        }
    }
    return isPrime;
}

// MARK: Stringify Object for Graphql
- (NSString*)collectKeysOfObject: (NSDictionary*)dictionary {
    NSString* str = @"";
    NSMutableArray* arr = [NSMutableArray new];
    for (NSString* key in [dictionary allKeys]) {
        NSObject* subItem = [dictionary valueForKeyPath:key];
        NSString* nKey = [self getSub:subItem key:key];
        [arr addObject:nKey];
    }
    str = [arr componentsJoinedByString:@","];
    return str;
}

//recursive check subitems
- (NSString*)getSub: (NSObject*)subItem key:(NSString*)key {
    if ([subItem isKindOfClass:[NSDictionary class]]) {
        NSMutableArray* arrKey = [NSMutableArray new];
        NSArray* arrSubKey = [(NSDictionary*)subItem allKeys];
        for (NSString* sKey in arrSubKey) {
            NSObject* subValue = [subItem valueForKeyPath:sKey];
            if ([subValue isKindOfClass:[NSDictionary class]]) {
                NSString* subKey = [self getSub:subValue key:sKey];
                [arrKey addObject:subKey];
            } else {
                [arrKey addObject:sKey];
            }
        }
        NSString* joinedKeys = [arrKey componentsJoinedByString:@","];
        return [NSString stringWithFormat:@"%@{%@}", key, joinedKeys];
    } else {
        return key;
    }
}

//dummy json
- (NSDictionary*)getSampleDict {
    NSString * jsonString = @"{\"firstname\" : \"John\", \"lastname\" : \"Doe\", \"age\" : 21, \"company\": {\"name\":\"Protel\", \"address\":\"Esentepe Mahallesi\", \"sub\": {\"test\":\"lorem\"}},\"phone\" : \"905330000000\",\"hobies\" : [\"travel\", \"sports\", \"coding\"]}";
    NSData * jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error=nil;
    NSDictionary * parsedData = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    return parsedData;
}

@end

