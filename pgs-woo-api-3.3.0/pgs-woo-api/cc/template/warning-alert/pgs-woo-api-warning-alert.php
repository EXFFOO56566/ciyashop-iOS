<script type="text/html" id="tmpl-pgs-woo-api-warning-alert">
	<!--h3 class="sample-title">{{data.title}}</h3-->
	<div class="pgs-woo-api-sample-message">
		<div class="notice-message-content">
			Hello,</br></br>
			Greetings from PotenzaGlobalSolutions!</br></br>
			We PotenzaGlobalSolutions is the Exclusive author of "CiyaShop Native Android Application based on WooCommerce" and "CiyaShop Native iOS Application based on WooCommerce." </br></br>
			<strong>CiyaShop Android on Codecanyon :</strong>-<a href="https://codecanyon.net/item/ciyashop-native-android-application-based-on-woocommerce/22375882" target="_blank">https://codecanyon.net/item/ciyashop-native-android-application-based-on-woocommerce/22375882</a></br>
			<strong>CiyaShop iOS on Codecanyon :</strong>-<a href="https://codecanyon.net/item/ciyashop-native-ios-application-based-on-woocommerce/22375994" target="_blank">https://codecanyon.net/item/ciyashop-native-ios-application-based-on-woocommerce/22375994</a></br>
			<strong>Profile:</strong>- https://codecanyon.net/user/potenzaglobalsolutions</br></br>
			We have observed that you have tried many failed attempts. If you have purchased our CiyaShop application and facing the issue in purchase code verification or other configuration, then please contact our support and Create Support ticket, and our team will help you. To contact our support, please click on the "Contact Support" button below.</br></br>
			<strong>Warning:</strong> -PotenzaGlobalSolutions recorded your all attempts. If you are not having Purchase code and using pirated code then you have to purchase our product from the above link of products and then verify product otherwise we will take necessary action against you since we are an exclusive author of CiyaShop Android and CiyaShop iOS application and we are having all the rights. Also we are having records of failed attempts as evidence.</br></br>
		</div><br/>
		<div class="notice-message-count">
			<?php
			$notice_count = pgs_woo_api_wp_warning_alert(true);
			if(isset( $notice_count['show_notice_count'] ) && !empty( $notice_count['show_notice_count'] )){
				printf( "we have find %s failed attempts", $notice_count['show_notice_count']);
			}
			?>
		</div>
	</div><br/>
	<div class="pgs-woo-api-sample-details">
		<a class="pgs_woo_api_notice_button button button-primary" target="_blank" href="http://docs.potenzaglobalsolutions.com/docs/ciya-shop-mobile-apps/"><?php esc_html_e('Documentation','pgs-woo-api')?></a>
		<a class="pgs_woo_api_notice_button button button-primary" target="_blank" href="https://potezasupport.ticksy.com/"><?php esc_html_e('Support','pgs-woo-api')?></a>
		<a id="call_try_now" class="pgs_woo_api_notice_button button button-primary" href="" data-call="<?php echo wp_create_nonce( 'pgs_woo_api_call_try_now_security' );?>"><?php esc_html_e('Try again','pgs-woo-api')?></a><span class="pgs-popup-notice-loader"><span>
	</div>
	<div class="pgs-woo-api-popup-notice-alert"></div>
</script>