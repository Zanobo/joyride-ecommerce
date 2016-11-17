//= require jquery
//= require jquery.validate/jquery.validate.min
//= require spree
//= require spree/frontend/checkout
//= require spree/frontend/product
//= require spree/frontend/cart
//= require bootstrap-sprockets
//= require bootstrap/modal
//= require_tree .

//select calendar days
$( function() {
    $('td').click( function() {
        $('td').removeClass("day-select");
        $(this).addClass("day-select");
    } );
} );