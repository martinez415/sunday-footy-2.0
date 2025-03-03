$(document).ready(function() { 
  $('#league').change(function() {
    var leagueId = $(this).val(); 
    if (leagueId) { 
      $.getJSON('/clubs/' + leagueId, function(data) {
        $('#team').empty().append('<option value="">Select a team</option>');
        $.each(data, function(index, team) {
          $('#team').append('<option value="' + team + '">' + team + '</option>'); 
        });
        $('#team').prop('disabled', false);
      });
    } else { 
      $('#team').prop('disabled', true).empty().append('<option value="">Select a team</option>'); 
    }
  });
});
