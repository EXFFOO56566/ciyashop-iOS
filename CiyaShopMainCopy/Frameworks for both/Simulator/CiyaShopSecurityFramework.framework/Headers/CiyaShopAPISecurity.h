//
//  CiyaShopAPISecurity.h
//  CiyaShopSecurityFramework
//
//  Created by Jitendra on 30/08/18.
//  Copyright © 2018 Jitendra. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletionBlock) (BOOL responseObject);
typedef void (^DictionaryResponse) (BOOL success, NSString *message, id dictionary);

@interface CiyaShopAPISecurity : NSObject

#pragma mark - Set Authentication Data

+(void)setOauthData:(NSDictionary*)dict;

#pragma mark - API calls

+ (void)homeData:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)productListing:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getSellerDetail:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getStaticPages:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)updateCustomer:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getCustomerDetail:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)updateCustomerImage:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getInfoPages:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)changeNotification:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)resetPassword:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)contactSeller:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)contactUs:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)deactivateUser:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getAttributes:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getReviews:(int)productId completionBlock:(DictionaryResponse) completionBlock;
+ (void)addItemtoWishList:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)removeItemFromWishList:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)updateCustomerAddress:(NSDictionary*)dictParams userId:(NSString*)userId completionBlock:(DictionaryResponse) completionBlock;
+ (void)addToCart:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getRewardPoints:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getOrders:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getCoupons:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)scratchCoupon:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getAllNotifications:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)deleteNotification:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)cancelOrder:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getVariations:(NSDictionary*)dictParams productid:(int)productId completionBlock:(DictionaryResponse) completionBlock;
+ (void)userLogout:(DictionaryResponse) completionBlock;
+ (void)postReview:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)createCustomer:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)updatePassword:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)forgetPassword:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)addAllItemToWishList:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)loginCustomer:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)socialLoginCustomer:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)findGeoLocation:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)addNotification:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)liveSearch:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;

+ (void)getCountry:(DictionaryResponse) completionBlock;
+ (void)getState:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;

+ (void)createOrder:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)confirmOrder:(NSDictionary*)dictParams orderid:(int)orderid completionBlock:(DictionaryResponse) completionBlock;
+ (void)orderReview:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)getPaymentGatewayList:(DictionaryResponse) completionBlock;

+ (void)generatePayUMoneyHash:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;

+ (void)applyCoupon:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)removeCoupon:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;

+ (void)getBlogData:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;

+ (void)storeFinder:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;

+ (void)homeLayout:(DictionaryResponse) completionBlock;
+ (void)homeScrolling:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)productSale:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)productRandom:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;

+ (void)getDownloadProducts:(int)userid completionBlock:(DictionaryResponse)completionBlock;

+ (void)verifyCustomer:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;
+ (void)resendOTP:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;

+ (void)checkDeliveryToPincode:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;

+ (void)getStampReviewData:(NSString*)_url params:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;

+ (void)postStampReview:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;


#pragma mark - Other API calls That can be used for custom calls

+ (void)postAPICall:(NSString*)url dictParams:(NSDictionary*)dictParams completionBlock:(DictionaryResponse) completionBlock;

@end
