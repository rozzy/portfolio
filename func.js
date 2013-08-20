playShadows = function (o, mobile) {
  m = 2.534345;
  s1m = 10;
  s2m = 7;
  v = mobile ? {x: 1.5, y: 0.95} : {x: 1, y: 0.45};
  o.x = o.x > v.x ? v.x : o.x;
  o.x = o.x < -v.x ? -v.x : o.x;
  o.y = o.y > v.y ? v.y : o.y;
  o.y = o.y < -v.y ? -v.y : o.y;
  $('#s1').css({marginTop: o.y*s1m, marginLeft: o.x*s1m});
  $('#s2').css({marginTop: -o.y*s2m, marginLeft: -o.x*s2m});
  $('#m').css({marginTop: o.y*m, marginLeft: o.x*m});
};
gyro.frequency = 1;
gyro.startTracking(function(o) {
  if (o.x != null) playShadows(o, true);
});
$(window).mousemove(function (o) {
  target = $('div#m');
  o.tX = target.offset().left + target.width()/2;
  o.tY = target.offset().top + target.height()/2;
  sb = 0.018;
  playShadows({x: sb*(o.tX - o.clientX), y: sb*(o.tY - o.clientY)}, false);
});