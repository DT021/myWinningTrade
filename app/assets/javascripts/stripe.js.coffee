# This identifies your website in the createToken call below
Stripe.setPublishableKey 'YOUR_PUBLISHABLE_KEY'


$('.payment-form').submit( (event) ->

  # Disable the submit button to prevent repeated clicks
  $('.submit-button').prop 'disabled', true

  Stripe.createToken({
  number: $('.card-number').val(),
  cvc: $('.card-cvc').val(),
  exp_month: $('.card-expiry-month').val(),
  exp_year: $('.card-expiry-year').val()
  }, stripeResponseHandler)

  # Prevent the form from submitting with the default action
  return false
)


