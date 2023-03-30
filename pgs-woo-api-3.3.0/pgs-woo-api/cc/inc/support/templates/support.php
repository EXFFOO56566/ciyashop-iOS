<?php
// Do not allow directly accessing this file.
if ( ! defined( 'ABSPATH' ) ) {
	exit( 'Direct script access denied.' );
}
/**
 * Setting page for support settings
 */
add_action('admin_menu', 'pgs_woo_api_option_page_support');
function pgs_woo_api_option_page_support(){    
    add_menu_page( esc_html('PGS Woo API','pgs-woo-api'), esc_html('App Settings','pgs-woo-api'),'manage_options','pgs-woo-api-support-settings','pgs_woo_api_support_token_callback');
}


function pgs_woo_api_support_token_callback(){
    $plugin_name = "Ciya Shop Mobile App API";
    $auth_token = PGS_WOO_API_Support::pgs_woo_api_verify_plugin();
    $purchase_key_android = get_option('pgs_woo_api_plugin_android_purchase_key');
    $purchase_key_ios = get_option('pgs_woo_api_plugin_ios_purchase_key');
    $icon_android = 'dashicons dashicons-admin-network';
    $icon_ios = 'dashicons dashicons-admin-network';
    $pgs_token_android = get_option('pgs_woo_api_pgs_token_android');
    $input_type_android = 'text';
    if( $pgs_token_android && !empty($pgs_token_android)){
		$icon_android = 'dashicons dashicons-yes';
        $input_type_android = 'password';
        $purchase_key_ios = '';
	}
    $pgs_token_ios = get_option('pgs_woo_api_pgs_token_ios');
    $input_type_ios = 'text';
    if( $pgs_token_ios && !empty($pgs_token_ios)){
        $icon_ios = 'dashicons dashicons-yes';        
        $input_type_ios = 'password';
        $purchase_key_android = '';
    }
    
    if( !empty($pgs_token_android) && !empty($pgs_token_ios)){
        $purchase_key_android = get_option('pgs_woo_api_plugin_android_purchase_key');
        $purchase_key_ios = get_option('pgs_woo_api_plugin_ios_purchase_key');    
    }

    $is_activated = pgs_woo_api_is_activated();
    $panel = (isset($_GET['panel']) && !empty($_GET['panel']))?$_GET['panel']:'';
    $active_tab_1 = 'nav-tab-active'; $active_tab_2 = '';
    if($panel == "support-doc"){
        $panel = "support-doc";
        $active_tab_1 = '';
        $active_tab_2 = 'nav-tab-active';
    }
    ?>
    <div class="wrap pgs-woo-api-api-admin-page">
        <?php
        require_once( PGS_API_PATH . 'cc/inc/support/templates/support-header.php' );
        ?>
        <div class="wrap-top gradient-bg">
            <h2 class="nav-tab-wrapper">                
                <a class="nav-tab <?php esc_attr_e($active_tab_1)?>" href="<?php echo admin_url('admin.php?page=pgs-woo-api-support-settings')?>"><?php esc_html_e('License','pgs-woo-api')?></a>
                <?php if(!empty($auth_token)){?>
                <a class="nav-tab <?php esc_attr_e($active_tab_2)?>" href="<?php echo admin_url('admin.php?page=pgs-woo-api-support-settings&panel=support-doc')?>"><?php esc_html_e('Support','pgs-woo-api')?></a>
                <?php }?>
            </h2>            
            <div class="support-bg">
                <?php 
                if(!empty($auth_token) && $is_activated){
                    if( $panel != "support-doc" ){?>
                        <div class="cdhl-theme-active theme-panel">
                            <h3><?php esc_html_e( 'Please Follow the installation process', 'pgs-woo-api' ); ?></h3>
                            <?php            
                            if(isset($_POST['submit-token-android']) || isset($_POST['submit-token-ios']) ){
                                if( isset($_POST['submit-token-android'])){
                                    $prefix = "android";
                                    $error = get_site_transient("pgs_woo_api_auth_notice_$prefix");
                                } elseif( isset($_POST['submit-token-ios'])){
                                    $prefix = "ios";
                                    $error = get_site_transient("pgs_woo_api_auth_notice_$prefix");
                                }
                                if( ! empty($_POST['pgs_woo_api_verify_plugin']["purchase_key_$prefix"]) && !empty($auth_token) && empty($error) ) {?>
                                    <div class="pgs-woo-api-admin-important-success-notice">
                                        <?php echo esc_html( get_site_transient("pgs_woo_api_pgs_auth_msg_$prefix") ); ?>
                                    </div>
                                    <?php 
                                    delete_site_transient("pgs_woo_api_pgs_auth_msg_$prefix");
                                }
                            }?>
                            <p class="pgs-woo-api-theme-description">
                                <?php esc_html_e('Click on the below button and follow the installation process, the installation process will update the plugin necessary plugin files and help to install the required plugins etc.', 'pgs-woo-api'); ?>
                            </p>
                            <form method="post" action="" name="" class="pgs-woo-api-upgrade">
                                <input type="hidden" id="pgs-woo-api-wpnonce" name="_wpnonce" value="<?php echo wp_create_nonce( 'updates' )?>">
                                <input type="hidden" id="pgs-woo-api-wp_http_referer" name="_wp_http_referer" value="<?php echo esc_attr( wp_unslash( $_SERVER['REQUEST_URI'] ) )?>'">
                                <input type="hidden" id="pgs-woo-api-wp-checked" name="checked[]" value="pgs-woo-api/pgs-woo-api.php">
                                <div class="install-pro-letsgo">
                                    <input id="pgs-woo-api-upgrade-plugins" class="button button-primary" type="submit" value="Let's Go!" name="upgrade">
                                    <span class="spinner"></span>
                                </div>
                            </form>
                            <div class="pgs-response"></div>                        
                        </div>                    
                        <?php
                    } else {
                        if( $panel == "support-doc" ){
                            require_once( PGS_API_PATH . 'cc/inc/support/templates/support-docs.php' );
                        }
                    }                    
                } else {
                    require_once( PGS_API_PATH . 'cc/inc/support/templates/support-content.php' );
                }?>
            </div>
        </div>
    </div>
    <?php
}