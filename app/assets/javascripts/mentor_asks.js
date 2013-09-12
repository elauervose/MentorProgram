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
