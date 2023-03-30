<?php
/**
 * Add Home Api  
 */
add_action('admin_menu', 'pgs_woo_api_option_page_menu');
function pgs_woo_api_option_page_menu(){	
	add_menu_page( esc_html('PGS Woo API','pgs-woo-api'), esc_html('App Settings','pgs-woo-api'),'manage_options','pgs-woo-api-settings','pgs_woo_api_callback');
}

function pgs_woo_api_callback(){    
    
    //require_once( PGS_API_PATH . 'inc/options-pages/option_functions.php' );
    $pgs_woo_api_home_option = array();
    $pgs_woo_api_home_option = get_option('pgs_woo_api_home_option');
    
    //get app color options
    $app_assets_options = get_option('pgs_woo_api_app_assets_options');
    
    $primary_color = (isset($app_assets_options['app_assets']['app_color']['primary_color']))?$app_assets_options['app_assets']['app_color']['primary_color']:'';
    $secondary_color = (isset($app_assets_options['app_assets']['app_color']['secondary_color']))?$app_assets_options['app_assets']['app_color']['secondary_color']:'';
    $header_color = (isset($app_assets_options['app_assets']['app_color']['header_color']))?$app_assets_options['app_assets']['app_color']['header_color']:'';
    
    $feature_product_status = "enable";
    $recent_product_status = "enable";
    $special_deal_product_status = "enable";
    
    
    $lang='';
    $return = ( class_exists('SitePress') ? true : false );
    if($return){        
        if(isset($_GET['lang']) && !empty($_GET['lang'])){        
            $pgs_woo_api_wpml_initial_language = get_option('pgs_woo_api_wpml_initial_language_array');
            if(isset($pgs_woo_api_wpml_initial_language) && !empty($pgs_woo_api_wpml_initial_language)){
                $default_lang = $pgs_woo_api_wpml_initial_language['code'];                                    
                if($_GET['lang'] != $default_lang){
                    $lang = $_GET['lang'];                                                                    
                }
            }                    
        } else {            
            $current_lang = apply_filters( 'wpml_current_language', NULL );         
            if(isset($current_lang) && !empty($current_lang)){                                
                $pgs_woo_api_wpml_initial_language = get_option('pgs_woo_api_wpml_initial_language_array');                
                if(isset($pgs_woo_api_wpml_initial_language) && !empty($pgs_woo_api_wpml_initial_language)){
                    $default_lang = $pgs_woo_api_wpml_initial_language['code'];                                    
                    if($current_lang != $default_lang){
                        $lang = $current_lang;                                                
                    } else {
                        $lang = '';
                    }
                }    
            }
        }                
        global $sitepress;
        $language_negotiation_type = $sitepress->get_setting( 'language_negotiation_type' );
        if($language_negotiation_type != 1){
            $return = false;    
            $message  = esc_html__( 'Current WPML Language URL format settings not compatible with PGS Woo API.', 'pgs-woo-api' );        
            $message .= ' <a href="'.admin_url('admin.php?page=sitepress-multilingual-cms/menu/languages.php').'">';
            $message .= esc_html__( 'Click here for change settings.','pgs-woo-api');   
            $message .= '</a>';
            echo pgs_woo_api_admin_notice_render( $message,'error' );
        }
    }
    //$products_carousel = pgs_woo_api_get_products_carousel();    
    ?>
    <div class="wrap pgs-woo-api-options-page">
		<h2></h2>
        <div class="wrap-top gradient-bg">
            <h2 class="wp-heading-inline"><?php esc_html_e('App Settings','pgs-woo-api')?></h2>
            <div class="pgs-woo-api-right">
              <div class="publish-btn-box">
                  <span class="spinner"></span>
                  <!--button id="publish-btn" type="submit" name="submit-api" form="pgs-woo-api-form" class="pgs-woo-api-btn button button-primary Submit-btn" value="Submit"><?php //esc_html_e('Save Changes','pgs-woo-api')?></button-->
              </div>
              <div class="mobile-screen-view"></div>
            </div>
        </div>

        <form action="" method="post" name="pgs-woo-api-form" id="pgs-woo-api-form">
            <div id="pgs-woo-api-tabs">
                <ul>
                    <li><a href="#pgs-woo-api-tabs-app-primary-logo"><?php esc_html_e('WelCome','pgs-woo-api')?></a></li>                    
                </ul>                
                
                
                <div id="pgs-woo-api-tabs-app-primary-logo">
            
                    <div class="pgs-woo-api-panel" id="pgs-woo-api-app_logo">
                        <div class="pgs-woo-api-panel-body">
                            <div class="pgs-woo-api-panel-heading"><?php esc_html_e('WelCome','pgs-woo-api')?></div>
							<p class="description"><?php esc_html_e('Please verify your purches key','pgs-woo-api')?></p>
                            
                            <div class="pgs-woo-api-field-group">
                                <div class="pgs-woo-api-form-group">

                                </div>
                            </div>
                        </div>
                        
                    </div>                
                </div><!-- #pgs-woo-api-tabs-app-primary-logo -->
				
                
                
                
                <div id="pgs-woo-api-tabs-filters">
                    <div class="pgs-woo-api-panel" id="pgs-woo-api-filters">
                        <div class="pgs-woo-api-panel-body">
                            <div class="pgs-woo-api-panel-heading"><?php esc_html_e('Filters','pgs-woo-api')?></div>
                            <div class="pgs-woo-api-repeater-field-group">                                                                
                                    <?php
                                    $pgs_price_filters = (isset($pgs_woo_api_home_option['pgs_api_filters']['pgs_price']))?$pgs_woo_api_home_option['pgs_api_filters']['pgs_price']:'enable';
                                    $pgs_average_rating = (isset($pgs_woo_api_home_option['pgs_api_filters']['pgs_average_rating']))?$pgs_woo_api_home_option['pgs_api_filters']['pgs_average_rating']:'enable';
                                    ?>
                                    <div class="pgs-woo-api-form-groups radio-button-inline">
                                        <label><?php esc_html_e("Price",'pgs-woo-api')?></label><br />
                                        <label><input type="radio" name="pgs[pgs_api_filters][pgs_price]" class="pgs-woo-api-form-control" value="enable"  <?php echo ($pgs_price_filters == "enable")?'checked=""':'';?> /><?php esc_html_e( 'Enable','pgs-woo-api')?></label>
                                        <label><input type="radio" name="pgs[pgs_api_filters][pgs_price]" class="pgs-woo-api-form-control" value="disable" <?php echo ($pgs_price_filters == "disable")?'checked=""':'';?> /><?php esc_html_e( 'Disable','pgs-woo-api')?></label>
                                    </div>
                                    <?php
                                    $attribute_taxonomies = wc_get_attribute_taxonomies();
                                    if ( ! empty( $attribute_taxonomies ) ) {
                        				foreach ( $attribute_taxonomies as $tax ) {                        					
                                            $attribute    = wc_sanitize_taxonomy_name( $tax->attribute_name );
                        					$taxonomy     = wc_attribute_taxonomy_name( $attribute );
                                            $pgs_taxonomy_filters = (isset($pgs_woo_api_home_option['pgs_api_filters'][$taxonomy]))?$pgs_woo_api_home_option['pgs_api_filters'][$taxonomy]:'enable';
                                            ?>
                                            <div class="pgs-woo-api-form-groups radio-button-inline">
                                                <label><?php echo ucfirst($tax->attribute_label)?></label><br />
                                                <label><input type="radio" name="pgs[pgs_api_filters][<?php echo $taxonomy?>]" class="pgs-woo-api-form-control" value="enable" <?php echo ($pgs_taxonomy_filters == "enable")?'checked=""':'';?> /><?php esc_html_e( 'Enable','pgs-woo-api')?></label>
                                                <label><input type="radio" name="pgs[pgs_api_filters][<?php echo $taxonomy?>]" class="pgs-woo-api-form-control" value="disable" <?php echo ($pgs_taxonomy_filters == "disable")?'checked=""':'';?> /><?php esc_html_e( 'Disable','pgs-woo-api')?></label>
                                            </div>
                                            <?php
                                        }
                        			}
                                    ?>
                                    <div class="pgs-woo-api-form-groups radio-button-inline">
                                        <label><?php esc_html_e("Average Rating",'pgs-woo-api')?></label><br />
                                        <label><input type="radio" name="pgs[pgs_api_filters][pgs_average_rating]" class="pgs-woo-api-form-control" value="enable" <?php echo ($pgs_average_rating == "enable")?'checked=""':'';?>/><?php esc_html_e( 'Enable','pgs-woo-api')?></label>
                                        <label><input type="radio" name="pgs[pgs_api_filters][pgs_average_rating]" class="pgs-woo-api-form-control" value="disable" <?php echo ($pgs_average_rating == "disable")?'checked=""':'';?> /><?php esc_html_e( 'Disable','pgs-woo-api')?></label>
                                    </div>
                            </div>
                        </div>
                    </div>
                </div>
                
        </div>
    </form>
</div>    
    <?php
}?>