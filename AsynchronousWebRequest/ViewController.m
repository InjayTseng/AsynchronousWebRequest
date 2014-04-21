//
//  ViewController.m
//  AsynchronousWebRequest
//
//  Created by David Tseng on 12/11/12.
//  Copyright (c) 2012 David Tseng. All rights reserved.
//

#import "ViewController.h"
typedef void(^XBLOCK)(NSString* str1);


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self getUnitNameFromService:^(NSString *str1) {
        NSLog(@"Name: %@",str1);
    }];
}

-(void)getUnitNameFromService:(XBLOCK)outputBlock{
    
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@://%@:%@/Service/UnitService.ashx",@"http",@"50.201.99.168",@"80"]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    //Request Setting
    [request setHTTPMethod:@"POST"];
    [request addValue:@"STRING" forHTTPHeaderField:@"Accept-Serialize"];
    
    //Body Content
    NSString *body=[NSString stringWithFormat:@"\nGetUnitByID\nP:3\n%@",@"5732"];
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    
    //Start the request for the data
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        //If data were received
        if (data) {
            //Convert to string
            NSString *result = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
            NSLog(@"Done %@",result);
            NSLog(@"Unit Name Deserialize------");
            NSArray *array = [result componentsSeparatedByCharactersInSet:
                              [NSCharacterSet characterSetWithCharactersInString:@""]];
            if([array count]>=20) {
                NSString *unitName = [NSString stringWithFormat:@"%@",[array objectAtIndex:19]];
                if (outputBlock) {
                    outputBlock(unitName);
                }else{
                    NSLog(@"LOG:  NIL outputBlock");
                }
            }
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
