$(function() {

  $('.lightbox').click(function(event) {
    var href = $(this).attr('href');
    event.preventDefault();
    $.colorbox({
      innerWidth: '760px',
      innerHeight: '440px',
      transition: 'fade',
      scrolling: false,
      iframe: true,
      href: href,
      className: 'lightbox'
    });
  });

});
