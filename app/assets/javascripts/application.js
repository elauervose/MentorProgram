//= require 'jquery-1.8.3.min.js'
//= require 'jquery_ujs'
//= require 'jquery-ui-1.10.3.custom.min.js'
//= require 'jquery.ui.touch-punch.min.js'
//= require 'bootstrap.min.js'
//= require 'bootstrap-select.js'
//= require 'bootstrap-switch.js'
//= require 'flat-ui'
//= require 'jquery.tagsinput.js'
//= require 'jquery.placeholder.js'
//= require 'jquery.stacktable.js'
//= require 'video.js'
//= require_tree .

// clears the modal body on mentor signup page; this should be moved
// to a better location once location of this page is finalized
$('#myModal').on('hidden', function () {
  $(this).removeData('modal');
});

// Updates count of chracters remaining based on input text_area and limit
function updateCharacterCount(el, maxChars) {
  var chars_remaining = maxChars - el.val().length;
  $('.characters').text('Characters remaining: ' + chars_remaining);
}

// Set characters left on page load and on an updates to text_area
$(document).ready(function() {
  var text_area = $('.description').find('.description_area');
  if (text_area.length) {
    updateCharacterCount(text_area, 300);
    text_area.on('input', function() { updateCharacterCount(text_area, 300);});
  }
})

// Some general UI pack related JS
// Extend JS String with repeat method
String.prototype.repeat = function(num) {
    return new Array(num + 1).join(this);
};

(function($) {

  // Add segments to a slider
  $.fn.addSliderSegments = function (amount) {
    return this.each(function () {
      var segmentGap = 100 / (amount - 1) + "%"
        , segment = "<div class='ui-slider-segment' style='margin-left: " + segmentGap + ";'></div>";
      $(this).prepend(segment.repeat(amount - 2));
    });
  };

  $(function() {

    // Todo list
    $(".todo li").click(function() {
        $(this).toggleClass("todo-done");
    });

    // Custom Select
    $("select[name='herolist']").selectpicker({style: 'btn-primary', menuStyle: 'dropdown-inverse'});

    // Tooltips
    $("[data-toggle=tooltip]").tooltip("show");

    // Tags Input
    $(".tagsinput").tagsInput();

    // jQuery UI Sliders
    var $slider = $("#slider");
    if ($slider.length) {
      $slider.slider({
        min: 1,
        max: 5,
        value: 2,
        orientation: "horizontal",
        range: "min"
      }).addSliderSegments($slider.slider("option").max);
    }

    // Placeholders for input/textarea
    $("input, textarea").placeholder();

    // Make pagination demo work
    $(".pagination a").on('click', function() {
      $(this).parent().siblings("li").removeClass("active").end().addClass("active");
    });

    $(".btn-group a").on('click', function() {
      $(this).siblings().removeClass("active").end().addClass("active");
    });

    // Disable link clicks to prevent page scrolling
    $('a[href="#fakelink"]').on('click', function (e) {
      e.preventDefault();
    });

    // Switch
    $("[data-toggle='switch']").wrap('<div class="switch" />').parent().bootstrapSwitch();

  });

})(jQuery);
