<?php
$theme = pgs_woo_api_get_plugin_info();
//$plugin_name = "Ciya Shop Mobile App API"; 
$plugin_name = 'CiyaShop Native Application API (PGS Woo API) based on WooCommerce';
?>
<div class="clearfix">
	<div class="pgs-woo-api-about-text-wrap">
        <h1><?php printf( esc_html__('Welcome to %s', 'pgs-woo-api'), $plugin_name ); ?></h1>
        <div class="pgs-woo-api-about-text about-text">
            <?php add_thickbox(); ?>
			<div class="pgs-woo-api_theme_info pgs-woo-api-welcome">
				<div class="welcome-left pgs-woo-api-welcome-badge <?php echo esc_attr( 'pgs-woo-api-welcome-badge-without-logo' );?>">
					<div class="wp-badge">
						<img src="<?php echo esc_url( PGS_API_URL . '/cc/img/api.png');?>" height="100" width="100" />
					</div>
					<div class="pgs-woo-api-welcome-badge-version">
						<?php echo sprintf( esc_html__('Version %s','pgs-woo-api'), $theme['v']);?>
					</div>
				</div>
				<div class="welcome-right">
					<?php printf( wp_kses( __( '<strong>CiyaShop Application API</strong> is now ready to activate! <strong>CiyaShop Application</strong> is the perfect solution for your shopping business or your client shopping store as an agency or freelancer. It Engages consumers to constitute Loyalty with sharp design and features which make sense for the online shop. It is well-suited for retail stores, marketplaces, fashion shops, cosmetics and household appliances of any size. The CiyaShop application is the new way of building robust WooCommerce-based online shops and businesses.', 'pgs-woo-api' ), array( 'strong' => array() ) ), $plugin_name, $plugin_name ); ?>
				</div>
			</div>
        </div>
    </div>
</div>