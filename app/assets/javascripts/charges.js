
$(document.ready(function() {
	  
	Stripe.setPublishableKey('pk_test_ldAbOSYOYB7gnfM5iH3jsco4');
	 
	var stripeResponseHandler = function(status, response) {
	var $form = $('#new_payment');
	 
	if (response.error) {
	// Show the errors on the form
	$form.find('.payment-errors').text(response.error.message);
	$form.find('submit').prop('disabled', false);
	} else {
	// token contains id, last4, and card type
	var token = response.id;
	// Insert the token into the form so it gets submitted to the server
	$form.append($('<input type="hidden" name="stripeToken" />').val(token));
	// and re-submit
	$form.get(0).submit();
	}
	};
	 
	jQuery(function($) {
	$('#new_payment').submit(function(e) {
	var $form = $(this);
	alert('gotcha');
	 
	// Disable the submit button to prevent repeated clicks
	$form.find('submit').prop('disabled', true);
	 
	Stripe.createToken($form, stripeResponseHandler);
	 
	// Prevent the form from submitting with the default action
	return false;
	});
	});
});


