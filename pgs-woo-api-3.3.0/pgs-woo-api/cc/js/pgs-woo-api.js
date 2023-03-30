/**
* App Custom Option Js
* @param-key:
*/
jQuery(document).ready(function() {
    jQuery("#pgs-woo-api-upgrade-plugins").on("click",function(event){
        event.preventDefault();
        jQuery.ajax({
            type: "post",
            dataType: "json",
            url: pgs_wcmc_ajax.ajax_url,
            data : {
                plugin:"pgs-woo-api/pgs-woo-api.php",
                slug:"pgs-woo-api",
                action: "update-plugin",
                _ajax_nonce:jQuery("#pgs-woo-api-wpnonce").val(),
                _fs_nonce:"",
                username:"",
                password:"",
                connection_type:"",
                public_key:"",
                private_key:"",
            },
            beforeSend: function(){
                jQuery('.spinner').css('visibility','visible');
                jQuery("#pgs-woo-api-upgrade-plugins").prop('disabled', true); // disable button
            },
            success: function(result){
                if(result.success){
                    html  = '<div class="update-message notice inline notice-alt updated-message notice-success">';
                    html += '<p aria-label="result.pluginName updated!">PGS Woo API plugin successfully updated</p>';
                    html += '</div>';
                    jQuery('.pgs-response').html(html);
                    setTimeout(function(){
                        window.location.href = pgs_wcmc_ajax.wizard_url;
                        jQuery("#pgs-woo-api-upgrade-plugins").prop('disabled', false); // enable button
                        jQuery('.spinner').css('visibility','hidden');
                    },3000);
                } else {
                    jQuery("#pgs-woo-api-upgrade-plugins").prop('disabled', false); // enable button
                    jQuery('.spinner').css('visibility','hidden');
                    html = '<div class="update-message notice inline notice-alt notice-error">';
                    html += '<p aria-label="PGS Woo API updated!">We are facing an issue with purchase code verification on the current domain.';
                    html += ' Please <a href="'+pgs_wcmc_ajax.reverify_url+'">click here to verify the purchase code</a>.</p>';
                    html += '</div>';
                    jQuery('.pgs-response').html(html);
                }
            }
        });
        return false;
    });
});