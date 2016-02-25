//
//  ActionViewController.m
//  Quik Translation Action
//
//  Created by Danil Gailes on 14.11.15.
//  Copyright © 2015 DSTech. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textToTranslate;
@property (weak, nonatomic) IBOutlet UITextView *translatedText;

@property (strong, nonatomic) NSDictionary *JSONResponse;
@end

@implementation ActionViewController

//- (void)tttttviewDidLoad {
//    [super viewDidLoad];
//    
//    for (NSExtensionItem *item in self.extensionContext.inputItems) {
//        for (NSItemProvider *itemProvider in item.attachments) {
//            NSLog(@"%@", itemProvider);
//        }
//    }
//}
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    BOOL textFound = NO;
//    for (NSExtensionItem *item in self.extensionContext.inputItems) {
//        for (NSItemProvider *itemProvider in item.attachments) {
//            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText]) {
//                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePlainText options:nil completionHandler:^(NSString *item, NSError *error) {
//                    if(item) {
//                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                            self.textToTranslate.text = item;
//                            
//                            return;
//                        }];
//                    NSLog(@"text: %@", self.textToTranslate.text);
//                    }
//                }];
//                textFound = YES;
//                break;
//            }
//        }
//        
//        if (textFound) {
//            break;
//        }
//    }
//}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self hasText]) {
        [self loadTextItemWithCompletion:^(NSString *text) {
            if (text.length > 0) {

                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.textToTranslate setText:text];
                });

                [self loadTranslationForText:text];
            }
        }];
    }
}

- (BOOL)hasText
{
    return [[self itemProvider] hasItemConformingToTypeIdentifier:(NSString *)kUTTypePlainText];
}

- (void)loadTextItemWithCompletion:(void (^)(NSString *text))completion
{
    NSParameterAssert(completion);
    [[self itemProvider] loadItemForTypeIdentifier:(NSString *)kUTTypePlainText options:nil completionHandler:^(NSString *item, NSError *error) {
        if (error) {
            //
        } else {
            completion(item);
        }
    }];
}


- (void)loadTranslationForText:(NSString *)text
{
//    Use NSURLSession to get JSON response from server

    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    //
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:nil];

    NSURLSessionDataTask *getJSONObject =
    [session dataTaskWithURL:[self URLToRequestWithTranslation:text]
           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
               if ([response.MIMEType isEqualToString:@"application/json"]) {
                   self.JSONResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               }
               NSLog(@"In completion Handler!");
           }];

    [getJSONObject resume];



    NSLog(@"Get it!");

    //[self.translatedText setText:[self.JSONResponse valueForKey:@"text"]];

    //                    NSData *data = [NSData dataWithContentsOfURL:[self URLToRequestWithTranslation:item]];
    //                    if (data) {
    //                        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //                        //if ([[result valueForKey:@"code"] isEqualToValue: @200]) {
    //                            for (NSString *item in [result objectForKey:@"text"]) {
    //                                NSLog(@"%@", item);
    //                            }
    //                        //}
    //
    //                    } else {
    //                        NSLog(@"Respond failed!");
    //                    }
}

- (NSItemProvider *)itemProvider
{
    NSExtensionItem *item = self.extensionContext.inputItems[0];
    NSItemProvider *itemProvider = item.attachments[0];

    return itemProvider;
}

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    for (NSString *tmpString in [self.JSONResponse objectForKey:@"text"]) {
        self.translatedText.text = [self.translatedText.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", tmpString]];
    }
}
//- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
//    for (NSString *tmpString in [self.JSONResponse objectForKey:@"text"]) {
//        self.translatedText.text = [self.translatedText.text stringByAppendingString:[NSString stringWithFormat:@"%@ ", tmpString]];
//    }
//}


- (NSURL *)URLToRequestWithTranslation:(NSString *)textToTranslate {
    // Syntax of request
    /*
     https://translate.yandex.net/api/v1.5/tr.json/translate ?
     key=<API-ключ>
     & text=<переводимый текст>
     & lang=<направление перевода>
     & [format=<формат текста>]
     & [options=<опции перевода>]
     & [callback=<имя callback-функции>]
     */
    NSString *text = [textToTranslate stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *key = @"trnsl.1.1.20151114T094923Z.d35e8bc453944a96.21ed475453a829287b698df0c3ad5a71e44ce88e";
    NSString *urlToService = @"https://translate.yandex.net/api/v1.5/tr.json/translate";
    NSString *lang = @"en-ru";
    NSString *resultString = [NSString stringWithFormat:@"%@?key=%@&text=%@&lang=%@",urlToService, key, text, lang];
    
    NSLog(@"Request URL: %@", resultString);
    return [NSURL URLWithString:resultString];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
    
}

@end
