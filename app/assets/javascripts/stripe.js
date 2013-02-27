$(function() {
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))

  $(".submit-button").click(function() {
  //$(".payment-form").submit(function() {

    $(".submit-button").attr("disabled", true);

    var form = $(".payment-form");

    // Setting up card variable to be sent through form
    var card = {
      number: $(".card-number").val(),

      expMonth: $(".card-expiry-month").val(),

      expYear: $(".card-expiry-year").val(),

      cvc: $(".card-cvc").val()
    };

    Stripe.createToken(card, function(status, response) {
      if (status === 200) {
        $('#stripe_card_token').val(response.id)

        form.submit();
      } else {
        // Produce errors

        $("#stripe-error-message").text(response.error.message);

        $(".submit-button").attr("disabled", false);
      }
    });

    return false;
  });
});