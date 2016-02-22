//
//  ViewController.m
//  ApplePayDemo
//
//  Created by ah on 16/2/19.
//  Copyright © 2016年 ah. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
#import "AhAlertView.h"

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

}

- (IBAction)Apple_pay_action:(id)sender {
    
    
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        
        NSLog(@"可以使用Apple Pay支付");
        
        
        //  检测是否当前设备是否可以进行某种卡的支付
        
//         if( ![PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:@[PKPaymentNetworkMasterCard,PKPaymentNetworkVisa,PKPaymentNetworkAmex]]) return; //容错
        
        [self makePayments];
    }else{
        
         NSLog(@"不可以使用Apple Pay支付");
        [self showInfo:@"不可以使用Apple Pay支付"];
       
    }
    
}

- (void)showInfo:(NSString *)info{
    
     [AhAlertView alertViewWithTitle:@"提示" message:info];
}

/**Apple Pay支付*/
- (void)makePayments{
    
    PKPaymentRequest *payRequest = [[PKPaymentRequest alloc]init];
    
    
    //  钱的处理  方式1
    PKPaymentSummaryItem *item0 = [PKPaymentSummaryItem summaryItemWithLabel:@"吉他" amount:[NSDecimalNumber decimalNumberWithString:@"0.1"]];
    
    PKPaymentSummaryItem *item1 = [PKPaymentSummaryItem summaryItemWithLabel:@"DV机" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
    PKPaymentSummaryItem *item2 = [PKPaymentSummaryItem summaryItemWithLabel:@"刘英" amount:[NSDecimalNumber decimalNumberWithString:@"0.02"]];
    
    payRequest.paymentSummaryItems = @[item0,item1,item2];
    
    //  钱的处理  方式2
    
//    NSDecimalNumber *subtotalAmount = [NSDecimalNumber decimalNumberWithMantissa:1275 exponent:-2 isNegative:NO];
//    PKPaymentSummaryItem *subtotalAmountItem = [PKPaymentSummaryItem summaryItemWithLabel:@"订单金额" amount:subtotalAmount];
//    
//    //折扣
//    NSDecimalNumber *discountAmount = [NSDecimalNumber decimalNumberWithMantissa:200 exponent:-2 isNegative:YES];
//    PKPaymentSummaryItem *discountAmountItem = [PKPaymentSummaryItem summaryItemWithLabel:@"折扣优惠" amount:discountAmount];
//    
//    // 合计
//    NSDecimalNumber *totalAmount = [NSDecimalNumber zero];
//    totalAmount = [totalAmount decimalNumberByAdding:subtotalAmount];
//    totalAmount = [totalAmount decimalNumberByAdding:discountAmount];
//   PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel:@"特付宝" amount:totalAmount];
//    
//    payRequest.paymentSummaryItems = @[subtotalAmountItem,discountAmountItem,totalItem];

    
    payRequest.countryCode = @"CN";  //  国家代码
    payRequest.currencyCode = @"CNY";  //  货币代码
    payRequest.supportedNetworks = @[PKPaymentNetworkChinaUnionPay];
    //  与你在评估开发者平台设置的必须一致
    payRequest.merchantIdentifier = @"merchant.com.ApplePayDemoah.cn";
    
    // PKMerchantCapability3DS
    payRequest.merchantCapabilities = PKMerchantCapabilityCredit | PKMerchantCapabilityDebit;
    
    //  关于地址和Email  在天朝来说一般是在自己分App界面进行设置, 这里不建议在App pay中进行处理.
    
//    payRequest.requiredBillingAddressFields = PKAddressFieldEmail | PKAddressFieldPostalAddress;
    
    
    NSLog(@"payRequest====%@",payRequest);
    
    
    
    PKPaymentAuthorizationViewController *payVc = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:payRequest];
    payVc.delegate = self;
    
    NSLog(@"payVc==========%@",payVc);
    
    [self presentViewController:payVc animated:YES completion:nil];
    
}
#pragma mark -  Apple pay的代理

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    NSLog(@"Payment was authorized: %@", payment);
    
    //需要连接服务器并上传支付令牌和其他信息，以完成整个支付流程
    NSLog(@"%@",payment.token);
    
    BOOL asyncSuccessful = YES;
    
    if(asyncSuccessful) {
        completion(PKPaymentAuthorizationStatusSuccess);
        
        //提示用户支付结果
        NSLog(@"Apple Pay支付成功");
        
    } else {
        completion(PKPaymentAuthorizationStatusFailure);
        
        //提示用户支付结果
        NSLog(@"Apple Pay支付失败");
    }
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    NSLog(@"paymentAuthorizationViewControllerDidFinish");
    //隐藏支付窗口
    [controller dismissViewControllerAnimated:YES completion:nil];
}

//输入指纹或者密码后,授权支付之前的回调

- (void)paymentAuthorizationViewControllerWillAuthorizePayment:(PKPaymentAuthorizationViewController *)controller{
    
    NSLog(@"paymentAuthorizationViewControllerWillAuthorizePayment==输入指纹或者密码后,授权支付之前的回调");
}



@end
