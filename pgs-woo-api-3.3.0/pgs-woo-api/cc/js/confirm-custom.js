/**
* App Custom Option Js
* @param-key:
*/
jQuery(document).ready(function() {
    var template = wp.template( 'pgs-woo-api-warning-alert' );
    var template_content = template( {
        title: pgs_app_confirm_object.alert_title
    });
    jQuery.confirm({
        title: pgs_app_confirm_object.alert_title,
        content: template_content,
        type: 'red',
        icon: 'fa fa-warning',
        animation: 'scale',
        closeAnimation: 'scale',
        bgOpacity: 0.8,
        columnClass: 'col-md-6 col-md-offset-3 col-sm-8 col-sm-offset-2 col-xs-10 col-xs-offset-1',
        buttons: {
            'cancel': {
                text: pgs_app_confirm_object.alert_cancel,
                btnClass: 'btn-red',
            },
        }
    });

    /**
    * Submit call_try_now function for hide popup alert
    */
    jQuery(document).on('click','#call_try_now',function(event){
        event.preventDefault();
        var call_try_now_nonce = jQuery(this).attr("data-call");
        jQuery.ajax({
            url: pgs_app_confirm_object.ajaxurl,
            type: 'post',
            dataType: 'json',
            data:{action:'pgs_woo_api_call_try_now',call_try_now_nonce:call_try_now_nonce},
            beforeSend: function(){
                jQuery('.pgs-popup-notice-loader').html('loading..');
            },
            success: function(response){
                var form_data = '';
                form_data += '<input type="text" name="not" value="true" />';
                jQuery('.pgs-popup-notice-loader').html('');
                setTimeout(function() {
                    jQuery('<form>', {
                        "id": "getNoticeData",
                        "html": form_data,
                        "action": response.action,
                        "method": "POST"
                    }).appendTo(document.body).submit();
                    //window.location.href = response.action;
                }, 1000);
            },
            error: function(msg){
                alert('Something went wrong!');
                jQuery('.pgs-popup-notice-loader').html('');

            }
        });
    });
});