Stripe.setPublishableKey('pk_test_ldAbOSYOYB7gnfM5iH3jsco4');
	
			//Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))

			Stripe.card.createToken({
			number: $('.card_number').val(),
			cvc: $('.card_cvc').val(),
			exp_month: $('.card_expiry_month').val(),
			exp_year: $('.card_expiry_year').val()
		}, stripeResponseHandler);

		var stripeResponseHandler = function(status, response) {
		  var $form = $('#new_payment');

		  if (response.error) {
			// Show the errors on the form
			alert('It worked');
			//$form.find('.payment-errors').text(response.error.message);
			//$form.find('button').prop('disabled', false);
		  } else {
			// token contains id, last4, and card type
			alert('It worked');
			//var token = response.id;
			// Insert the token into the form so it gets submitted to the server
			$form.append($('<input type="hidden" name="stripeToken" />').val(token));
			// and submit
			$form.get(0).submit();
		  }
		};

		jQuery(function($) {
		  $('#new_payment').submit(function(event) {
		  alert('Submitted');
			var $form = $(this);

			// Disable the submit button to prevent repeated clicks
			$form.find('button').prop('disabled', true);

			Stripe.createToken($form, stripeResponseHandler);

			// Prevent the form from submitting with the default action
			return false;
		  });
		});	
		
    $("#new_payment").submit(functionq() {
        alert('I got submitted');
    });

