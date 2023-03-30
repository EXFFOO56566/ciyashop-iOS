<?php
/**
 * Plugin Name: PGS Woo API
 * Plugin URI: http://www.potenzaglobalsolutions.com/
 * Description: This plugin contains important functions and features for "WooCommerce API".
 * Version: 3.3.0
 * Author: Potenza Global Solutions
 * Author URI: http://www.potenzaglobalsolutions.com/
 * Text Domain: pgs-woo-api
 * WC requires at least: 3.0
 * WC tested up to: 3.5.0
 */
if ( ! function_exists( 'is_plugin_active' ) ) {
    include_once( ABSPATH . 'wp-admin/includes/plugin.php' );
}
global $plugin_version;

$plugin_version = '3.3.0';

if( ! defined( 'PGS_API_PATH' ) ) define( 'PGS_API_PATH', plugin_dir_path( __FILE__ ) );
if( ! defined( 'PGS_API_URL' ) ) define( 'PGS_API_URL', plugin_dir_url( __FILE__ ) );
if( ! defined( 'PGS_ENVATO_API' ) ) define('PGS_ENVATO_API',  'https://envatoapi.potenzaglobalsolutions.com/');
if( ! defined( 'PGS_WOO_API' ) ) define('PGS_WOO_API', 'pgs-woo-api');

$page = (isset($_GET['page']) && !empty($_GET['page']))?$_GET['page']:'';
if( $page != "pgs-woo-api-support-settings" ){
    add_action('admin_notices', 'pgs_woo_api_admin_notice');
}
function pgs_woo_api_admin_notice() {
    $html  = '<div id="message" class="error fade"><p style="line-height: 150%">';
    $html .= '<strong>'.esc_html__("PGS Woo API","pgs-woo-api").'</strong><p>';
    $support_settings_url = esc_url( admin_url('admin.php?page=pgs-woo-api-support-settings') );
    $html .= sprintf(
        wp_kses( __( 'Go to the <a href="%s">App Settings</a> For setup the PGS Woo API plugin.', 'pgs-woo-api' ),
        array(
            'a' => array(
                'href' => $support_settings_url,
            )
        )),
        $support_settings_url
    );
    $html .= '</p></div>';
    echo $html;
}

/**
 * Check plugin is installed
 */
function pgs_woo_api_is_plugin_installed($search){
	if ( ! function_exists( 'get_plugins' ) ) {
		require_once ABSPATH . 'wp-admin/includes/plugin.php';
	}
	$plugins = get_plugins();
	$plugins = array_filter( array_keys($plugins), function($k){
		if( strpos($k, '/') !== false ) return true;
	});
	$plugins_stat = function($plugins, $search){
		$new_plugins = array();
		foreach($plugins as $plugin){
			$new_plugins_data = explode('/', $plugin);
			$new_plugins[] = $new_plugins_data[0];
		}
        return in_array($search, $new_plugins);
	};
	return $plugins_stat($plugins, $search);
}

/**
 * The code that runs during plugin deactivation.
 */
function pgs_woo_api_deactivate() {
	// TODO: Add settings for plugin deactivation
}

add_action('plugins_loaded', 'wan_load_textdomain');
function wan_load_textdomain() {
    load_plugin_textdomain( 'pgs-woo-api', false, dirname( plugin_basename( __FILE__ ) ) . '/languages/' );
}
// Includes for Admin
require_once( PGS_API_PATH . 'cc/inc/woo-api-functions.php' );
require_once( PGS_API_PATH . 'cc/inc/support/templates/support.php' );
require_once( PGS_API_PATH . 'cc/inc/classes/class-pgs-woo-api-support.php' );