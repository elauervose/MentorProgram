// Updates table of pairing requests when filter conditions selected
$('select.filter').on('change', function() {
  var place = $('select#location_filter').find('option:selected').val();
  var day = $('select#day_filter').find('option:selected').val();
  var time = $('select#time_filter').find('option:selected').val();
  $.ajax(this.action, {
    type: 'GET',
    data: { 'location': place, 'day': day, 'time': time },
    dataType: 'html',
    success: function(result) {
      console.log(result);
      $('#pairs_table').html(result);},
    contentType: 'application/json'
  });
});

// Update remaining characters in description textarea
$(document).ready(updateCharacterCount());
$('textarea#pair_ask_description').live('input', updateCharacterCount);

function updateCharacterCount() {
  var chars_remaining = 300 - $('textarea#pair_ask_description').val().length;
  $('p.characters').text('Characters remaining: ' + chars_remaining);
}
