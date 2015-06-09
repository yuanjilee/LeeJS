//
//  ViewController.m
//  LeeJS
//
//  Created by Keanu Reeves on 15-6-9.
//  Copyright (c) 2015年 yuanjilee. All rights reserved.
//



/*********************JS本地文件操作***********************/
#import "ViewController.h"
#import "SecondViewController.h"
@interface ViewController () <UIWebViewDelegate,UIAlertViewDelegate>
{
    UIWebView *webView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title = @"JS";
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(javascript:)];
    self.navigationItem.rightBarButtonItem = item;
   
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(push)];
    self.navigationItem.leftBarButtonItem = left;
    
    //webView
    webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    webView.delegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    [webView.scrollView showsVerticalScrollIndicator];
    [self.view addSubview:webView];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:path]];
    [webView loadRequest:request];
    
}

- (void)push
{
    SecondViewController *second = [[SecondViewController alloc]init];
    [self.navigationController pushViewController:second animated:YES];
}

#pragma mark - javascript and OC
//当点击按钮之后，弹出一个对话框，不是alert，而且javascript中得对话框
-(void)javascript:(UIWebView *)sender
{
    NSString *jsString = [NSString stringWithFormat:
                          @"alert('this is alert from website');"
                          ];

    [webView stringByEvaluatingJavaScriptFromString:jsString];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"startLoad");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"finished");
    //请求完成之后可以获取当前网站的title，还有document等信息
    NSString *pageTitle = [self->webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSLog(@"myTitle-------%@",pageTitle);
    //可以将获取的标题设置为当前当行的title
    self.navigationItem.title = pageTitle;
    
    /*
     document的一些属性：
     location-位置子对象
     document.location.hash // #号后的部分
     document.location.host // 域名+端口号
     document.location.hostname // 域名
     document.location.href // 完整URL
     document.location.pathname // 目录部分
     document.location.port // 端口号
     document.location.protocol // 网络协议(http:)
     document.location.search // ?号后的部分
     documeny.location.reload() //刷新网页
     document.location.reload(URL) //打开新的网页
     document.location.assign(URL) //打开新的网页
     document.location.replace(URL) //打开新的网页
     */
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"did fielded");
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    //判断当前跳转的URL，也就是javascript中得location，根据自己的需求跳转
    NSString *requestString = [[[request URL]  absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    NSLog(@"requestString = %@",requestString);
    NSLog(@"relativaPath = %@",request.mainDocumentURL.relativePath);
    //判断当前URL是不是myapps开头的字符串
    if ([requestString hasPrefix:@"myapps:"]) {
        
        //前端操作
//        UIAlertView *alter = [[UIAlertView alloc]initWithTitle:@"alter" message:@"this is a nativa alter" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//        [alter show];
//        return NO;
        
        
        NSMutableDictionary *param = [self queryStringToDictionary:requestString];
        NSLog(@"get param:%@",param);
        NSString *org = [param objectForKey:@"org"];
        //这里最为重要了，根据当前参数判断，然后是否跳转，如果不跳转直接用OC里边的方法
        if([org isEqualToString:@"iashes"]){
            NSLog(@"%@",@"可以传了。");
        }
        return NO;
    }//返回NO是不跳转，返回YES是跳转
    return YES;
}

#pragma mark - string&Dic exchange method
//通过&讲字符串转换成字典
- (NSMutableDictionary *)queryStringToDictionary:(NSString *)queryString {
    if (!queryString)
        return nil;
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSArray *pairs = [queryString componentsSeparatedByString:@"&"];
    NSLog(@"pairs = %@",pairs);
    for (NSString *pair in pairs) {
        NSRange separator = [pair rangeOfString:@"="];
        NSString *key, *value;
        if (separator.location != NSNotFound) {
            key = [pair substringToIndex:separator.location];
            value = [[pair substringFromIndex:separator.location + 1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        } else {
            key = pair;
            value = @"";
        }
        key = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [result setObject:value forKey:key];
    }
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
