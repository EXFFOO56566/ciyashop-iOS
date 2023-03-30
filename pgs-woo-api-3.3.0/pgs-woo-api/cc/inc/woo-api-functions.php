<?php
function pgs_woo_script_style_admin() {
    wp_register_style( 'jquery-ui', PGS_API_URL.'cc/css/jquery-ui.min.css' );
    wp_register_style( 'pgs-woo-api-support', PGS_API_URL.'cc/css/pgs-woo-api-support.css' );
    wp_register_style( 'pgs-woo-api-css', PGS_API_URL.'cc/css/pgs-woo-api.css' );
    wp_register_style( 'jquery-confirm-bootstrap' , PGS_API_URL.'cc/css/jquery-confirm/jquery-confirm-bootstrap.css' );
    wp_register_style( 'jquery-confirm', PGS_API_URL.'cc/css/jquery-confirm/jquery-confirm.css' );

    wp_register_script( 'jquery-confirm', PGS_API_URL.'cc/js/jquery-confirm/jquery-confirm.js', array('jquery'), false, false );
    wp_register_script('pgs-woo-api-js', PGS_API_URL.'cc/js/pgs-woo-api.js', array('jquery-ui-core','jquery-ui-tabs'), false, false );
    wp_register_script('pgs-woo-api-confirm-custom-js', PGS_API_URL.'cc/js/confirm-custom.js', array('jquery-confirm','wp-util'), false, false );
    wp_localize_script( 'pgs-woo-api-js', 'pgs_woo_api', array(
    	'plugin_url' => plugins_url(),
    	'pgs_api_url' => PGS_API_URL,
        'delete_msg' => esc_html__("Are you sure you want to delete this element?",'pgs-woo-api'),
        'choose_image' => esc_html__("Choose Image",'pgs-woo-api'),
        'add_image' => esc_html__( 'Add Image','pgs-woo-api')
    ) );

    if( ( isset( $_GET['page'] ) && $_GET['page'] == 'pgs-woo-api-settings' ) ||
        ( isset( $_GET['page'] ) && $_GET['page'] == 'pgs-woo-api-token-settings' ) ) {
        wp_enqueue_style( 'pgs-woo-api-css' );
    }

    if( isset( $_GET['page'] ) && $_GET['page'] == 'pgs-woo-api-support-settings' ){
        wp_enqueue_style( 'pgs-woo-api-support' );
        wp_localize_script( 'pgs-woo-api-js', 'pgs_wcmc_ajax', array(
            'ajax_url' => admin_url( 'admin-ajax.php' ),
            'wizard_url' => admin_url('admin.php?page=pgs_woo_api-setup'),
            'reverify_url' => admin_url( 'admin.php?page=pgs-woo-api-support-settings&pgs_re_verify=yes' ),
        ));

        wp_enqueue_style( 'jquery-confirm-bootstrap' );
        wp_enqueue_style( 'jquery-confirm' );
        $sts = pgs_woo_api_wp_warning_alert(false);
        if( $sts ){
            wp_localize_script( 'pgs-woo-api-confirm-custom-js', 'pgs_app_confirm_object', array(
                'ajaxurl' => admin_url( 'admin-ajax.php' ),
                'alert_title' => esc_html__( 'Warning', 'pgs_woo_api' ),
                'alert_cancel' => esc_html__( 'Cancel', 'pgs_woo_api' )
            ));
            wp_enqueue_script( 'pgs-woo-api-confirm-custom-js' );
        }
    }

    if( ( isset( $_GET['page'] ) && $_GET['page'] == 'pgs-woo-api-settings' ) ||
        ( isset( $_GET['page'] ) && $_GET['page'] == 'pgs-woo-api-token-settings' ) ){

        wp_enqueue_style( 'jquery-ui' );
        wp_enqueue_script( 'jquery-ui-sortable' );

        $activated_with = pgs_woo_api_activated_with();
        wp_localize_script( 'pgs-woo-api-js', 'pgs_app_sample_data_import_object', array(
            'ajaxurl'                          => admin_url( 'admin-ajax.php' ),
            'alert_title'                      => esc_html__( 'Warning', 'pgs_woo_api' ),
            'alert_proceed'                    => esc_html__( 'Proceed', 'pgs_woo_api' ),
            'alert_cancel'                     => esc_html__( 'Cancel', 'pgs_woo_api' ),
            'alert_install_plugins'            => esc_html__( 'Install Plugins', 'pgs_woo_api' ),
            'alert_default_message'            => esc_html__( 'Importing demo content will import contents, widgets and theme options. Importing sample data will override current widgets and theme options. It can take some time to complete the import process.', 'pgs_woo_api' ),
            'tgmpa_url'                        => admin_url( 'themes.php?page=theme-plugins' ),
            //'sample_data_required_plugins_list'=> ( !empty($pgs_woo_api_sample_data_required_plugins_list) ) ? array_values($pgs_woo_api_sample_data_required_plugins_list) : false,
            'sample_import_nonce'              => wp_create_nonce( 'pgs_woo_api_sample_data_security' ),
            //'plugin_ver' => ( isset($plugin_data['Version']) ) ? $plugin_data['Version'] : '',
            'purchased_android' => ( $activated_with['purchased_android'] ) ? $activated_with['purchased_android'] : false,
            'purchased_ios' => ( $activated_with['purchased_ios'] ) ? $activated_with['purchased_ios'] : false
        ));
    }
    if(current_user_can( 'update_core' )){
        wp_enqueue_script( 'pgs-woo-api-js' );
    }

}
add_action( 'admin_enqueue_scripts', 'pgs_woo_script_style_admin' );




/**
 * Notification message
 */
function pgs_woo_api_admin_notice_render($message,$status) {
    $html = '<div class="notice notice-'.$status.' is-dismissible">';
        $html .= '<p>'.$message.'</p>';
    $html .= '</div>';
    return $html;
}

/**
 * Notification message For AJAX
 */
function pgs_woo_api_ajax_admin_notice_render($message,$status) {
    $html = '<div class="pgs-woo-api-notice pgs-alert-'.$status.'">';
        $html .= '<p>'.$message.'</p>';
    $html .= '</div>';
    return $html;
}

/**
 * Get feature box option status
 */
function pgs_woo_api_feature_box_status($lang=''){
    $pgs_woo_api_home_option = get_option('pgs_woo_api_home_option');
    $feature_box_status = (isset($pgs_woo_api_home_option['feature_box_status']) && !empty($pgs_woo_api_home_option['feature_box_status']))?$pgs_woo_api_home_option['feature_box_status']:'enable';

    if(!empty($lang)){
        $pgs_woo_api_home_option_lang = get_option('pgs_woo_api_home_option_'.$lang);
        $feature_box_status = (isset($pgs_woo_api_home_option_lang['feature_box_status']) && !empty($pgs_woo_api_home_option_lang['feature_box_status']))?$pgs_woo_api_home_option_lang['feature_box_status']:'enable';
    }
    if($feature_box_status == 'enable'){
        $style = 'style="display: block;"';
    } else {
        $style = 'style="display: none;"';
    }
    echo $style;
}

/**
 * DeActivate Plugin.
 */
if( isset( $_GET['page'] ) && $_GET['page'] == 'pgs-woo-api-support-settings' && ( isset( $_GET['pgs_re_verify'] ) && $_GET['pgs_re_verify'] == "yes" ) ) {
    delete_option('pgs_woo_api_plugin_android_purchase_key');
    delete_option('pgs_woo_api_plugin_ios_purchase_key');
    delete_option('pgs_woo_api_pgs_token_android');
    delete_option('pgs_woo_api_pgs_token_ios');
    $redirect = admin_url('admin.php?page=pgs-woo-api-support-settings');
    header('Location: '.$redirect);
}


/*Theme info*/
function pgs_woo_api_get_plugin_info(){
    $path = PGS_API_PATH.'pgs-woo-api.php';
    $plugin = get_plugin_data($path);
    $plugin_name = $plugin['Name'];
    $plugin_v = $plugin['Version'];
	$plugin_info = array(
        'name' => $plugin_name,
        'slug' => sanitize_file_name(strtolower($plugin_name)),
        'v' => $plugin_v,
    );
    return $plugin_info;
}

/**
 * Check item validated with purchesh key or not.
 */
function pgs_woo_api_is_activated() {
    $pgs_token_android = get_option('pgs_woo_api_pgs_token_android');
    $pgs_token_ios = get_option('pgs_woo_api_pgs_token_ios');

    if( $pgs_token_android && !empty($pgs_token_android)){
		return $pgs_token_android;
	} elseif( $pgs_token_ios && !empty($pgs_token_ios)){
        return $pgs_token_ios;
    }
	return false;
}
/**
 * Check item validate with android or iOS
 */
function pgs_woo_api_activated_with() {
    $pgs_token_android = get_option('pgs_woo_api_pgs_token_android');
    $pgs_token_ios = get_option('pgs_woo_api_pgs_token_ios');
    $purchased_android = false;
    $purchased_ios = false;
    $result = array();
    if( isset($pgs_token_android) && !empty($pgs_token_android)){
    	$purchased_android = true;
    }
    if( isset($pgs_token_ios) && !empty($pgs_token_ios)){
        $purchased_ios = true;
    }
    $result = array(
        'purchased_android' => $purchased_android,
        'purchased_ios' => $purchased_ios
    );
    return $result;
}

/**
 * Widzard process check plugin active
 */
function pgs_woo_api_widzard_check_plugin_active( $plugin = '' ) {

	if( empty($plugin) ) return false;

	return ( in_array( $plugin, (array) get_option( 'active_plugins', array() ) ) || ( function_exists('is_plugin_active_for_network') && is_plugin_active_for_network($plugin) ) );
}
/**
 * Check item token is activated with purches key
 */
function pgs_woo_api_token_is_activated() {
	$pgs_token_android = get_option('pgs_woo_api_pgs_token_android');
    $pgs_token_ios = get_option('pgs_woo_api_pgs_token_ios');

    if( $pgs_token_android && !empty($pgs_token_android)){
		return $pgs_token_android;
	} elseif( $pgs_token_ios && !empty($pgs_token_ios)){
        return $pgs_token_ios;
    }
	return false;
}

function pgs_woo_api_get_plugin_data(){
    global $pgs_woo_api_globals;
    $plugin_data = get_plugin_data(PGS_API_PATH.'pgs-woo-api.php');
    $pgs_woo_api_globals['pgs_plugin_slug']  = sanitize_title($plugin_data['Name']);
	$pgs_woo_api_globals['pgs_plugin_name']  = str_replace('-', '_', sanitize_title($plugin_data['Name']));
	$pgs_woo_api_globals['pgs_plugin_option']= $pgs_woo_api_globals['pgs_plugin_name'].'_options';
    return $plugin_data;
}

add_action( 'init', 'pgs_woo_api_activate_au' );
function pgs_woo_api_activate_au(){
	global $plugin_version;

	require_once ( PGS_API_PATH.'cc/inc/classes/class-pgs-wp-autoupdate.php' );
	$auth_token = PGS_WOO_API_Support::pgs_woo_api_verify_plugin();
    $product_key = PGS_WOO_API_Support::pgs_woo_api_verify_product_key();
    $current_plugin = pgs_woo_api_get_plugin_data();
	$plugin_current_version = $plugin_version;
	$plugin_remote_path     = trailingslashit(PGS_ENVATO_API).'get-plugin-info';
	$plugin_slug            = 'pgs-woo-api/pgs-woo-api.php';
	$token                  = $auth_token;
	$product_key            = $product_key;
	$site_url               = get_site_url();
    $purchase_key = PGS_WOO_API_Support::pgs_woo_api_get_purchase_key();
    new Pgs_woo_api_WP_AutoUpdate ( $plugin_current_version, $plugin_remote_path, $plugin_slug, $token, $product_key, $site_url,$purchase_key);
}

/**
 * verify notice for show notice alert chk
 */
add_action('wp_ajax_pgs_woo_api_call_try_now', 'pgs_woo_api_call_try_now');
add_action('wp_ajax_nopriv_pgs_woo_api_call_try_now', 'pgs_woo_api_call_try_now');
function pgs_woo_api_call_try_now(){
    $action_url = admin_url( 'admin.php?page=pgs-woo-api-support-settings' );
    if ( ! wp_verify_nonce( $_POST['call_try_now_nonce'], 'pgs_woo_api_call_try_now_security' ) ) {
		$import_status_data = array(
			'success'     => false,
			'message'     => esc_html__( 'Please verify your purchase key!' , 'pgs-woo-api' ),
            'action'      => $action_url
		);
	} else {
        $import_status_data = array(
            'success'     => false,
            'message'     => esc_html__( 'Please verify your purchase key!' , 'pgs-woo-api' ),
            'action'      => $action_url
        );
    }
    wp_send_json( $import_status_data );
    exit();
}

/**
 * wp notice for show notice alert
 */
function pgs_woo_api_wp_warning_alert($count=false) {
    $show_notice = false; $notice = '';
    $show_notice_data = get_option('pgs_woo_api_plugin_show_key_notice');
    $show_notice_transient = get_site_transient("pgs_woo_api_plugin_show_key_notice");
    if( $show_notice_data == true ){
        $show_notice = true;
    } elseif ( $show_notice_transient  == true ){
        $show_notice = true;
    }

    if(isset($_POST['not']) && $_POST['not'] == true ){
        $show_notice = false;
    }
    if( $count == true ){
        $show_count = '';
        if($show_notice){
            $show_notice_count = get_option('pgs_woo_api_plugin_show_key_notice_count');
            $show_notice_transient_count = get_site_transient("pgs_woo_api_plugin_show_key_notice_count");
            if( !empty($show_notice_count) ){
                $show_count = $show_notice_count;
            } elseif( !empty($show_notice_transient_count) ){
                $show_count = $show_notice_transient_count;
            }
            $show_notice_transient_count = get_site_transient("pgs_woo_api_plugin_show_key_notice_count");
        }
        return array( 'show_notice' => $show_notice, 'show_notice_count' => $show_count  );
    } else {
        return $show_notice;
    }
}
/**
 * Template file for show alert contet for show notice alert
 */
function pgs_woo_api_warning_alert_templates() {
    if( (isset($_GET['page']) && $_GET['page'] == "pgs-woo-api-support-settings") ||
        (isset($_GET['page']) && $_GET['page'] == "pgs-woo-api-settings") ||
        ( isset( $_GET['page'] ) && $_GET['page'] == 'pgs-woo-api-token-settings' ) ) {
        $sts = pgs_woo_api_wp_warning_alert();
        if( $sts ){
            include_once trailingslashit(PGS_API_PATH) . "cc/template/warning-alert/pgs-woo-api-warning-alert.php";
        }
	}

}
add_action( "admin_footer", "pgs_woo_api_warning_alert_templates" );