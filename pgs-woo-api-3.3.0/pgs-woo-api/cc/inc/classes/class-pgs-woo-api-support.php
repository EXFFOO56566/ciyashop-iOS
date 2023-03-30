<?php
// Do not allow directly accessing this file.
if ( ! defined( 'ABSPATH' ) ) {
	exit;
}

if( !class_exists('PGS_WOO_API_Support') ){
	class PGS_WOO_API_Support{
		public static $_instance = NULL;
		public function __construct() {
			do_action( 'PGS_WOO_API_Support_loaded' );
            $this-> init();
		}

		public static function init() {
			add_action( 'init', array( __CLASS__, 'pgs_woo_api_set_plugin_credentials' ) );
		}

		public static function instance() {
			if ( is_null( self::$_instance ) ) {
				self::$_instance = new self();
			}
			return self::$_instance;
		}

		public static function pgs_woo_api_set_plugin_credentials() {
            if(isset($_POST['pgs_woo_api_verify_plugin']) && isset($_POST['pgs_woo_api_nonce'])) {
				if( wp_verify_nonce( $_POST['pgs_woo_api_nonce'], 'pgs-woo-api-verify-token' )) {


                    if( isset($_POST['submit-token-android']) && empty($_POST['pgs_woo_api_verify_plugin']['purchase_key_android'])){
                        delete_option('pgs_woo_api_pgs_token_android');  // update pgs_woo_api_verify_plugin
						delete_site_transient('pgs_woo_api_pgs_auth_msg_android');
						delete_option('pgs_woo_api_plugin_android_purchase_key'); // update purchase_key
						return;
                    } elseif( isset($_POST['submit-token-ios']) && empty($_POST['pgs_woo_api_verify_plugin']['purchase_key_ios']) ) {
                        delete_option('pgs_woo_api_pgs_token_ios');  // update pgs_woo_api_verify_plugin
						delete_site_transient('pgs_woo_api_pgs_auth_msg_ios');
						delete_option('pgs_woo_api_plugin_ios_purchase_key'); // update purchase_key
                    } else {
						$item_key = '';

                        if(isset($_POST['ciyashop_native']) && !empty($_POST['ciyashop_native'])){
                            if($_POST['ciyashop_native'] == 'android'){
                                $item_key = sanitize_text_field($_POST['pgs_woo_api_verify_plugin']['item_key_android']);
                                $product_purchase_key = sanitize_text_field($_POST['pgs_woo_api_verify_plugin']['purchase_key_android']);
                                $_POST['pgs_woo_api_verify_plugin']['item_key_ios'] = '';
                                $_POST['pgs_woo_api_verify_plugin']['purchase_key_ios'] = '';
                            } else {
                                $item_key = sanitize_text_field($_POST['pgs_woo_api_verify_plugin']['item_key_ios']);
                                $product_purchase_key = sanitize_text_field($_POST['pgs_woo_api_verify_plugin']['purchase_key_ios']);
                                $_POST['pgs_woo_api_verify_plugin']['item_key_android'] = '';
                                $_POST['pgs_woo_api_verify_plugin']['purchase_key_android'] = '';
                            }
                        } else {
                            if(isset($_POST['pgs_woo_api_verify_plugin']['item_key_android']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_android'])){
                                $item_key = sanitize_text_field($_POST['pgs_woo_api_verify_plugin']['item_key_android']);
                                $product_purchase_key = sanitize_text_field($_POST['pgs_woo_api_verify_plugin']['purchase_key_android']);
                            } elseif(isset($_POST['pgs_woo_api_verify_plugin']['item_key_ios']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_ios'])){
                                $item_key = sanitize_text_field($_POST['pgs_woo_api_verify_plugin']['item_key_ios']);
                                $product_purchase_key = sanitize_text_field($_POST['pgs_woo_api_verify_plugin']['purchase_key_ios']);
                            }
                        }

						$args = array(
							'product_key'   => $item_key,
							'purchase_key'  => $product_purchase_key,
							'site_url' 		=> get_site_url(),
							'action'		=> 'register'
						);

						$url = add_query_arg( $args, trailingslashit(PGS_ENVATO_API) . 'verifyproduct');
                        $response = wp_remote_get( $url, array( 'timeout' => 2000 ) );
						if( is_wp_error($response) ){

                            if(isset($_POST['pgs_woo_api_verify_plugin']['item_key_android']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_android'])){
                                set_site_transient('pgs_woo_api_auth_notice_android', esc_html__('There was an error processing your request, please try again later!') );
                                delete_site_transient('pgs_woo_api_pgs_auth_msg_android');
                            } elseif(isset($_POST['pgs_woo_api_verify_plugin']['item_key_ios']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_ios'])){
                                set_site_transient('pgs_woo_api_auth_notice_ios', esc_html__('There was an error processing your request, please try again later!') );
                                delete_site_transient('pgs_woo_api_pgs_auth_msg_ios');
                            }
							return false;
						}

						$response_code = wp_remote_retrieve_response_code( $response );
						$response_body = json_decode( wp_remote_retrieve_body( $response ), true );
						if(isset($response_body['response']['show_notice'])){
                            if(!empty($response_body['response']['show_notice'])){
                                set_site_transient('pgs_woo_api_plugin_show_key_notice', true );
                                update_option( 'pgs_woo_api_plugin_show_key_notice', true );
                                set_site_transient('pgs_woo_api_plugin_show_key_notice_count', $response_body['response']['total_count'] );
                                update_option( 'pgs_woo_api_plugin_show_key_notice_count', $response_body['response']['total_count'] );
                            } else {
                                update_option('pgs_woo_api_plugin_show_key_notice', false );
                                delete_site_transient('pgs_woo_api_plugin_show_key_notice');
                                delete_site_transient('pgs_woo_api_plugin_show_key_notice_count');
                                delete_option( 'pgs_woo_api_plugin_show_key_notice_count' );
                            }
                        }
						if ( $response_code == '200' ) {
							if($response_body['status'] == 1){
                                update_option('pgs_woo_api_plugin_show_key_notice', false );
                                delete_site_transient('pgs_woo_api_plugin_show_key_notice');
                                delete_site_transient('pgs_woo_api_plugin_show_key_notice_count');
                                delete_option( 'pgs_woo_api_plugin_show_key_notice_count' );

                                if(isset($_POST['pgs_woo_api_verify_plugin']['item_key_android']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_android'])){
                                    set_site_transient('pgs_woo_api_pgs_auth_msg_android', $response_body['message'] );
                                    delete_site_transient('pgs_woo_api_auth_notice_android');
                                    update_option('pgs_woo_api_plugin_android_purchase_key', $product_purchase_key);
                                    update_option('pgs_woo_api_pgs_token_android', $response_body['pgs_token']);
                                } elseif(isset($_POST['pgs_woo_api_verify_plugin']['item_key_ios']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_ios'])){
                                    set_site_transient('pgs_woo_api_pgs_auth_msg_ios', $response_body['message'] );
                                    delete_site_transient('pgs_woo_api_auth_notice_ios');
                                    update_option('pgs_woo_api_plugin_ios_purchase_key', $product_purchase_key);
                                    update_option('pgs_woo_api_pgs_token_ios', $response_body['pgs_token']);
                                }

                    			return $response_body['pgs_token'];
                            }

							if($response_body['status'] != 429){//To manny request
                                if(isset($_POST['pgs_woo_api_verify_plugin']['item_key_android']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_android'])){
                                    delete_option('pgs_woo_api_pgs_token_android');
                                    update_option('pgs_woo_api_plugin_android_purchase_key', $product_purchase_key);
                                } elseif(isset($_POST['pgs_woo_api_verify_plugin']['item_key_ios']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_ios'])){
                                    delete_option('pgs_woo_api_pgs_token_ios');
                                    update_option('pgs_woo_api_plugin_ios_purchase_key', $product_purchase_key);
                                }
							}

                            if(isset($_POST['pgs_woo_api_verify_plugin']['item_key_android']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_android'])){
                                set_site_transient('pgs_woo_api_auth_notice_android', $response_body['message'] );
                                delete_site_transient('pgs_woo_api_pgs_auth_msg_android');
                            } elseif(isset($_POST['pgs_woo_api_verify_plugin']['item_key_ios']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_ios'])){
                                set_site_transient('pgs_woo_api_auth_notice_ios', $response_body['message'] );
                                delete_site_transient('pgs_woo_api_pgs_auth_msg_ios');
                            }
							return false;
						}
						else {
							if(isset($_POST['pgs_woo_api_verify_plugin']['item_key_android']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_android'])){
                                set_site_transient('pgs_woo_api_auth_notice_android', $response_body['message'] );
                                delete_site_transient('pgs_woo_api_pgs_auth_msg_android');
                            } elseif(isset($_POST['pgs_woo_api_verify_plugin']['item_key_ios']) && !empty($_POST['pgs_woo_api_verify_plugin']['item_key_ios'])){
                                set_site_transient('pgs_woo_api_auth_notice_ios', $response_body['message'] );
                                delete_site_transient('pgs_woo_api_pgs_auth_msg_ios');
                            }
                            return false;
						}
                    }
				}
			}
        }

		public static function pgs_woo_api_verify_plugin() {
			$pgs_token_android = get_option('pgs_woo_api_pgs_token_android');
            $pgs_token_ios = get_option('pgs_woo_api_pgs_token_ios');

            if( $pgs_token_android && !empty($pgs_token_android)){
				return $pgs_token_android;
			} elseif( $pgs_token_ios && !empty($pgs_token_ios)){
                return $pgs_token_ios;
            }
			return false;
		}

        public static function pgs_woo_api_verify_product_key() {

            $pgs_token_android = get_option('pgs_woo_api_pgs_token_android');
            $pgs_token_ios = get_option('pgs_woo_api_pgs_token_ios');
            if( $pgs_token_android && !empty($pgs_token_android)){
				$pgs_product_key = 'c7ec1dc95001d57cdedfe122569648dc';
			} else {
                $pgs_product_key = '7884626eb301b0f657bb23894fd2dbfe';
            }
			return $pgs_product_key;
		}


        public static function pgs_woo_api_get_purchase_key() {
            $purchase_key_android = get_option('pgs_woo_api_plugin_android_purchase_key');
            $purchase_key_ios = get_option('pgs_woo_api_plugin_ios_purchase_key');
            if($purchase_key_android != ''){
                return $purchase_key_android;
            } elseif($purchase_key_ios != ''){
                return $purchase_key_ios;
            }
            return false;
        }

        private function pgs_woo_api_auto_upk() {
            $auto_upk = "";
        }
	}
}
PGS_WOO_API_Support::instance();
?>