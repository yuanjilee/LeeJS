//
//  SecondViewController.m
//  LeeJS
//
//  Created by Keanu Reeves on 15-6-9.
//  Copyright (c) 2015年 yuanjilee. All rights reserved.
//


/*********************JS网络文件操作***********************/
#import "SecondViewController.h"

@interface SecondViewController () <UIWebViewDelegate>
{
    UIWebView *webView;
}
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    //webView
    webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    [webView.scrollView showsVerticalScrollIndicator];
    [self.view addSubview:webView];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"index2" ofType:@"html"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:path]];
    [webView loadRequest:request];
    
}

#pragma mark - webViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //总路径
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    NSLog(@"requestString2 = %@",requestString);
    //绝对路径
    NSLog(@"relativaPath2 = %@",request.mainDocumentURL.relativePath);

    
    //获取URL并且做比较，判断是否触发了JS事件，注意有"/"
    if ([request.mainDocumentURL.relativePath isEqualToString:@"/clicked"]) {
        
        //本地处理
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"nativa" message:@"button clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil, nil];
        [alertView show];
        
//        SecondViewController *secondViewCon = [[[SecondViewController alloc] init] autorelease];
//        [self.navigationController pushViewController:secondViewCon animated:YES];
        
        return NO;
    }
    return  YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finished");
    //请求完成之后可以获取当前网站的title，还有document等信息
    NSString *pageTitle = [self->webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"myTitle2-------%@",pageTitle);
    //可以将获取的标题设置为当前当行的title
    self.navigationItem.title = pageTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
