<?php
class Pgs_woo_api_WP_AutoUpdate {
	/**
	 * The plugin current version
	 * @var string
	 */
	private $current_version;

	/**
	 * The plugin remote update path
	 * @var string
	 */
	private $update_path;

	/**
	 * @var string
	 */
	private $plugin_title = 'PGS Woo API';

	/**
	 * Plugin Slug (plugin_directory/plugin_file.php)
	 * @var string
	 */
	private $plugin_slug;

	/**
	 * Plugin name (plugin_file)
	 * @var string
	 */
	private $slug;

	/**
	 * License User
	 * @var string
	 */
	private $license_user;

	/**
	 * License Key
	 * @var string
	 */
	private $license_key;

	/**
	 * Initialize a new instance of the WordPress Auto-Update class
	 * @param string $current_version
	 * @param string $update_path
	 * @param string $plugin_slug
	 */
	public function __construct( $current_version, $update_path, $plugin_slug, $token = '', $product_key = '', $site_url = '', $purchase_key = '' ){
		// Set the class public variables
		$this->current_version = $current_version;
		$this->update_path     = $update_path;

		// Credentials
		$this->token           = $token;
		$this->product_key     = $product_key;
		$this->site_url        = $site_url;
        $this->purchase_key    = $purchase_key;

		// Set the Plugin Slug
		$this->plugin_slug     = $plugin_slug;
        //$this->slug          = $plugin_slug;
		list ($t1, $t2)        = explode( '/', $plugin_slug );
		$this->slug            = str_replace( '.php', '', $t2 );

		add_filter( 'upgrader_pre_download', array(
			$this,
			'pgd_pre_upgrade_filter',
		), 10, 4 );

		// define the alternative API for updating checking
		add_filter( 'pre_set_site_transient_update_plugins', array( &$this, 'check_update' ) );

		// Define the alternative response for information checking
		add_filter( 'plugins_api', array( &$this, 'check_info' ), 10, 3 );
	}

	public function pgd_pre_upgrade_filter( $reply, $package, $updater ) {
		$check_plugin_name1 = isset( $updater->skin->plugin ) && $this->plugin_slug === $updater->skin->plugin;
		$check_plugin_name2 = isset( $updater->skin->plugin_info ) && $updater->skin->plugin_info['Name'] == $this->plugin_title;
		if ( ! $check_plugin_name1 && ! $check_plugin_name2 ) {
			return $reply;
		}

		$is_activated = pgs_woo_api_is_activated();
		if ( ! $is_activated ) {
			$support_settings_url = esc_url( admin_url('admin.php?page=pgs-woo-api-support-settings') );
			$support_url = esc_url( 'https://codecanyon.net/item/ciyashop-native-android-application-based-on-woocommerce/22375882' );

			$ciyashop_app_support = sprintf(
				esc_html__( 'Or goto %s CiyaShop application support %s', 'pgs-woo-api' ),
				'<a href="' . esc_url( $support_url ) . '" target="_blank">','</a>'
			);

			return new WP_Error( 'no_credentials',
				sprintf( esc_html__( 'To receive automatic updates license activation is required. Please visit %sSettings%s to activate your CiyaShop PGS Woo API.', 'pgs-woo-api' ),
				'<a href="' . esc_url( $support_settings_url ) . '" target="_blank">', '</a>'
				) . ' ' . $ciyashop_app_support );
		}

		$qstring = parse_url($package, PHP_URL_QUERY);
		parse_str( $qstring, $qstring_arr );

		$updater->strings['downloading_package_url'] = esc_html__( 'Getting download link...', 'pgs-woo-api' );
		$updater->skin->feedback( 'downloading_package_url' );
		$downloaded_archive = $qstring_arr['plugin_name'];

		$downloaded_archive = download_url( $package );
		if ( is_wp_error( $downloaded_archive ) ) {
			return $downloaded_archive;
		}

		$plugin_directory_name = 'pgs-woo-api';
		// WP will use same name for plugin directory as archive name, so we have to rename it
		if ( basename( $downloaded_archive, '.zip' ) !== $plugin_directory_name ) {
			$new_archive_name = dirname( $downloaded_archive ) . '/' . $plugin_directory_name . time() . '.zip';
			if ( rename( $downloaded_archive, $new_archive_name ) ) {
				$downloaded_archive = $new_archive_name;
			}
		}

		return $downloaded_archive;
	}

	/**
	 * Add our self-hosted autoupdate plugin to the filter transient
	 *
	 * @param $transient
	 * @return object $ transient
	 */
	public function check_update( $transient ) {

		if ( isset( $transient->response[ $this->plugin_slug ] ) ) {
			return $transient;
		}

		// Get the remote version
		// $remote_version = $this->getRemote('version');
		$remote_version = $this->getRemote('info');
		// If a newer version is available, add the update
		if(isset($remote_version->version) && !empty($remote_version->version)){
			if ( version_compare( $this->current_version, $remote_version->version, '<' ) ){
				$obj             = new stdClass();
				$obj->slug       = $this->slug;
				$obj->new_version= $remote_version->version;
				$obj->url        = $remote_version->plugins_url;
				$obj->plugin     = $this->plugin_slug;
				$obj->package    = $remote_version->download_link;
				$obj->tested     = $remote_version->tested;
				$transient->response[$this->plugin_slug] = $obj;
			}
		}
		return $transient;
	}

	/**
	 * Add our self-hosted description to the filter
	 *
	 * @param boolean $false
	 * @param array $action
	 * @param object $arg
	 * @return bool|object
	 */
	public function check_info($obj, $action, $arg) {

		if (($action=='query_plugins' || $action=='plugin_information') &&
		    isset($arg->slug) && $arg->slug === $this->slug) {
			return $this->getRemote('info');
		}
		return $obj;
	}

	/**
	 * Return the remote version
	 *
	 * @return string $remote_version
	 */
	public function getRemote($action = ''){
		$params = array(
			'body' => array(
				'action'      => $action,
				'token'       => $this->token,
				'plugin_slug' => $this->slug,
				'site_url'    => $this->site_url,
				'product_key' => $this->product_key,
                'purchase_key' => $this->purchase_key
			)
		);

        // Make the POST request
		$request = wp_remote_post($this->update_path, $params );

		// Check if response is valid
		if ( !is_wp_error( $request ) || wp_remote_retrieve_response_code( $request ) === 200 ) {
			return @unserialize( $request['body'] );
		}

		return false;
	}
}
