//= require 'jquery-1.8.3.min.js'
//= require 'jquery-ui-1.10.3.custom.min.js'
//= require 'jquery.ui.touch-punch.min.js'
//= require 'bootstrap.min.js'
//= require 'bootstrap-select.js'
//= require 'bootstrap-switch.js'
//= require 'flatui-checkbox.js'
//= require 'flatui-radio.js'
//= require 'jquery.tagsinput.js'
//= require 'jquery.placeholder.js'
//= require 'jquery.stacktable.js'
//= require 'video.js'
//= require_tree .

// Updates table of mentee requests when filter conditions selected
$('select.filter').on('change', function() {
  var place = $('select#location_filter').find('option:selected').val();
  var category = $('select#category_filter').find('option:selected').val();
  var day = $('select#day_filter').find('option:selected').val();
  var time = $('select#time_filter').find('option:selected').val();
  $.ajax(this.action, {
    type: 'GET',
    data: { 'location': place, 'category': category, 'day': day, 'time': time },
    dataType: 'html',
    success: function(result) {
      console.log(result);
      $('#mentees_table').html(result);},
    contentType: 'application/json'
  });
});

// clears the modal body on mentor signup page; this should be moved
// to a better location once location of this page is finalized
$('#myModal').on('hidden', function () {
  $(this).removeData('modal');
});

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
