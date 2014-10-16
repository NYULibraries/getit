/*! Copyright (c) 2011 Brandon Aaron (http://brandonaaron.net)
 * Licensed under the MIT License (LICENSE.txt).
 *
 * Thanks to: http://adomas.org/javascript-mouse-wheel/ for some pointers.
 * Thanks to: Mathias Bank(http://www.mathias-bank.de) for a scope bug fix.
 * Thanks to: Seamus Leahy for adding deltaX and deltaY
 *
 * Version: 3.0.6
 *
 * Requires: 1.2.2+
 */
(function(a){function d(b){var c=b||window.event,d=[].slice.call(arguments,1),e=0,f=!0,g=0,h=0;return b=a.event.fix(c),b.type="mousewheel",c.wheelDelta&&(e=c.wheelDelta/120),c.detail&&(e=-c.detail/3),h=e,c.axis!==undefined&&c.axis===c.HORIZONTAL_AXIS&&(h=0,g=-1*e),c.wheelDeltaY!==undefined&&(h=c.wheelDeltaY/120),c.wheelDeltaX!==undefined&&(g=-1*c.wheelDeltaX/120),d.unshift(b,e,g,h),(a.event.dispatch||a.event.handle).apply(this,d)}var b=["DOMMouseScroll","mousewheel"];if(a.event.fixHooks)for(var c=b.length;c;)a.event.fixHooks[b[--c]]=a.event.mouseHooks;a.event.special.mousewheel={setup:function(){if(this.addEventListener)for(var a=b.length;a;)this.addEventListener(b[--a],d,!1);else this.onmousewheel=d},teardown:function(){if(this.removeEventListener)for(var a=b.length;a;)this.removeEventListener(b[--a],d,!1);else this.onmousewheel=null}},a.fn.extend({mousewheel:function(a){return a?this.bind("mousewheel",a):this.trigger("mousewheel")},unmousewheel:function(a){return this.unbind("mousewheel",a)}})})(jQuery)


function Coordinate(startX, startY) {
    this.x = startX;
    this.y = startY;
}

function StackMapZoomMap(o){
  var defaults = {
  	boxHeight: 510,
  	boxWidth: 680,
  	container: jQuery('#SMmap-container'),
  	fitX: 0,
  	fitY: 0,
  	lockEdges: true,
  	locXContents: '.loc-x',
  	locYContents: '.loc-y',
  	mapSelector: '.SMmap',
  	originalWidth: 800,
  	originalHeight: 600,
  	overlaySelector: '.SMmap-overlay',
  	sizeXContents: '.size-x',
  	sizeYContents: '.size-y',
  	windowSelector: '.SMmap-window',
  	zoomFactor: 1.125,
  	zoomFit: -1, //if -1, then zoom all the way out
  	zoomFitBtn: '.zoom-fit',
  	zoomInBtn: '.zoom-in',
  	zoomMin: 1,
  	zoomMax: 1.423828125, //adjust to max zoom in
  	zoomOutBtn: '.zoom-out'
  };
  var m = this;
  jQuery.extend(m, defaults, o);
  m.mapWindow = m.container.find(m.windowSelector);
  m.popupWindow = m.mapWindow.closest('.SMpopup');
  m.map = m.mapWindow.find(m.mapSelector);
  m.mapElem = m.map[0];
  m.overlay = m.mapWindow.find(m.overlaySelector);
  m.overlayElem = m.overlay[0];
  m.sizeXContents = m.overlay.find(m.sizeXContents);
  m.sizeYContents = m.overlay.find(m.sizeYContents);
  m.locXContents = m.overlay.find(m.locXContents);
  m.locYContents = m.overlay.find(m.locYContents);
  m.halfBoxHeight = m.boxHeight / 2;
  m.halfBoxWidth = m.boxWidth / 2;
  m.curZoomFactor = 1;
  m.zoomFactorElem = m.mapWindow.find(m.zoomFactorSelector)[0];
  m.zoomMin = Math.min(m.boxWidth / m.originalWidth, m.boxHeight / m.originalHeight);
  if(m.zoomMin < 1) {
	  m.zoomMin = Math.pow(m.zoomFactor, (Math.floor(Math.log(m.zoomMin) / Math.log(m.zoomFactor))));
  }
  if(m.zoomFit == -1) {
	   m.zoomFit = m.zoomMin;
  }
  m.curSize = new Coordinate;
  m.mousePosition = new Coordinate;
  m.moveMap = function (x, y) {
    var newX = x, newY = y;
    if(m.lockEdges) {
      var rightEdge = -m.curSize.x + m.boxWidth;
	    var topEdge = -m.curSize.y + m.boxHeight;
      newX = newX < rightEdge ? rightEdge : newX;
      newY = newY < topEdge ? topEdge : newY;
      newX = newX > 0 ? 0 : newX;
      newY = newY > 0 ? 0 : newY;
	  }
	  m.mapElem.style.left = newX + 'px';
	  m.mapElem.style.top = newY + 'px';
	  m.overlayElem.style.left = newX + 'px';
	  m.overlayElem.style.top = newY + 'px';
  }
  m.setZoomFactor = function(newZoomFactor, focusX, focusY) {
  	if(m.curZoomFactor == newZoomFactor) return;
  	if(newZoomFactor < m.zoomMin) newZoomFactor = m.zoomMin;
  	if(newZoomFactor > m.zoomMax) newZoomFactor = m.zoomMax;
  	var mapPosition = m.map.position();
    var curFocusX = (-mapPosition.left + focusX) / m.curZoomFactor,
  	curFocusY = (-mapPosition.top + focusY) / m.curZoomFactor;
  	m.curZoomFactor = newZoomFactor;
  	m.curSize.x = m.originalWidth * m.curZoomFactor;
  	m.curSize.y = m.originalHeight * m.curZoomFactor;
  	m.mapElem.style.width = m.curSize.x + 'px';
  	m.mapElem.style.height = m.curSize.y + 'px';
  	m.sizeXContents.each(function(){jQuery(this).width(Math.ceil(jQuery(this).attr('width') * m.curZoomFactor));});
  	m.sizeYContents.each(function(){jQuery(this).height(Math.ceil(jQuery(this).attr('height') * m.curZoomFactor));});
  	m.locXContents.css('top', function(){return jQuery(this).attr('y') * m.curZoomFactor;});
  	m.locYContents.css('left', function(){return jQuery(this).attr('x') * m.curZoomFactor;});
  	curFocusX = focusX - (curFocusX * newZoomFactor);
  	curFocusY = focusY - (curFocusY * newZoomFactor);
  	m.moveMap(curFocusX, curFocusY);
  }
  m.setZoomFactor(m.zoomFit, m.halfBoxWidth, m.halfBoxHeight);
  m.mouseMove = function(event) {
    event.preventDefault();
    var e = event.pageX - m.mousePosition.x + m.map.position().left,
    d = event.pageY - m.mousePosition.y + m.map.position().top;
    m.moveMap(e, d);
    m.mousePosition.x = event.pageX;
    m.mousePosition.y = event.pageY;
  }
  m.map.mousedown(function(event) {
	  event.preventDefault();
	  m.mousePosition.x = event.pageX;
	  m.mousePosition.y = event.pageY;
    jQuery(document).mousemove(m.mouseMove);
    jQuery(document).mouseup(function(){jQuery(document).unbind('mousemove');});
	});
  m.container.find(m.zoomInBtn).click(function(){m.setZoomFactor(m.curZoomFactor * m.zoomFactor, m.halfBoxWidth, m.halfBoxHeight);});
  m.container.find(m.zoomOutBtn).click(function(){m.setZoomFactor(m.curZoomFactor / m.zoomFactor, m.halfBoxWidth, m.halfBoxHeight);});
  m.container.find(m.zoomFitBtn).click(function(){m.setZoomFactor(m.zoomFit, m.halfBoxWidth, m.halfBoxHeight); m.moveMap(m.fitX, m.fitY);});
  m.mapWindow.mousewheel(function(event, delta) {
    var mapPosition = m.mapWindow.position();
    var popupPosition = m.popupWindow.position();
    m.setZoomFactor(m.curZoomFactor * Math.pow(m.zoomFactor, delta), event.pageX - mapPosition.left - popupPosition.left, event.pageY - mapPosition.top - popupPosition.top);
    event.preventDefault();
	});
}


function trimHTML(text){
  text = jQuery.trim(text).replace('&', '%26');
  if(text.indexOf('<') != -1) {
    return text.substring(0, text.indexOf('<'));
  } else {
    return text;
  }
}

var StackMap = StackMap || {
    domain: 'http://newschool.stackmap.com',  // TODO
    delayImgLoad: true,  // TODO
    libraries: ['New School University Center'],  // TODO
    setup: function() {
      jQuery("body").append('<div id="SMblock-screen"></div>');
      jQuery('#SMblock-screen').click(StackMap.hideAllPopups);
      jQuery("body").append('<div id="SMtooltip"><p></p></div>');
      jQuery("body").on('mousedown', '.SMpin-target', function(e){
        e.stopPropagation();
      });
      jQuery("body").on('mouseenter', '.SMpin-target', function() {
        jQuery('#SMtooltip').css('left', jQuery(this).offset().left + jQuery(this).width() + 5).css('top', jQuery(this).offset().top);
        jQuery('#SMtooltip p').html(jQuery(this).find('.SMtooltip-contents').html());
        jQuery('#SMtooltip').fadeIn();
      })
      jQuery("body").on('mouseleave', '.SMpin-target', function() {
        jQuery('#SMtooltip').fadeOut();
      });
      jQuery("body").on('click', '.SMclose', StackMap.hideAllPopups);
      jQuery("body").on('click', '.SMprinter-friendly', function() {
        var $popup = jQuery(this).closest('.SMpopup');
        StackMap.openPrinterFriendly($popup.data('callno'), $popup.data('location'), $popup.data('library'), $popup.data('title'));
      });
    },
    addPopup: function(mapLink) {
      var $mapLink = jQuery(mapLink);
      var mapId = $mapLink.data('id');
      var popupId = 'popup' + mapId;
      var library = trimHTML($mapLink.data('library'));
      if(jQuery.inArray(library, StackMap.libraries) == -1) return;
      var location = trimHTML($mapLink.data('location'));
      var callno = trimHTML($mapLink.data('callno'));
      var holdingString = library + '$$' + location + '$$' + callno;
      console.log(holdingString);
      var request = {'holding':[holdingString], 'alt':true}; //alt for condensed API
      request.holding.push(holdingString);
      jQuery.ajax({
        dataType: "json",
        url: StackMap.domain + "/json/?callback=?",
        timeout: 1000,
        data: request,
        success: function(data, textStatus) {
          var result = data.results[0];
          if(jQuery("#" + popupId).size() == 0) {
            $popup = StackMap.buildPopup(popupId, result);
            if($popup.length) {
              jQuery("body").append($popup);
              var mapZoomer = new StackMapZoomMap({
                container: $popup.find('.SMmap-container'),
                originalWidth: map.width,
                originalHeight: map.height
              });
            }
          }
          $mapLink.show();
          $mapLink.click(function() {
            StackMap.showPopup(popupId);
          });
        }
      });
    },
    buildPopup: function(popupId, result) {
      if(result.maps.length != 0) { //if it was successful...
        map = result.maps[0];
        var holdingTitle = jQuery('h2.title').eq(1).html();  // TODO
        var $popup = jQuery('<div>', {
          'class': 'SMpopup',
          'id': popupId,
          'data-callno': result.callno,
          'data-location': result.location,
          'data-library': result.library,
          'data-title': holdingTitle
        }).append(jQuery('<input />', {
          'class': 'SMclose SMbutton',
          'type': 'button',
          'value': 'Close'
        }), jQuery('<input />', {
          'class': 'SMprinter-friendly SMbutton',
          'type': 'button',
          'value': 'Printer Friendly'
        }), jQuery('<h2>', {'class': 'SMheader'}).text(
          map.library + ', ' + map.floorname));
        var $mapImg = jQuery('<img />', {
          'class': 'SMmap',
          'alt': map.floorname
        });
        if(StackMap.delayImgLoad) {
          $mapImg.attr('othersrc', map.mapurl + '&marker=1');
        } else {
          $mapImg.attr('src', map.mapurl + '&marker=1');
        }
        var $map = jQuery('<div>', {'class': 'SMmap-container'})
          .append(jQuery('<ul>', {'class': 'SMmap-buttons'})
            .append(
              jQuery('<li><input class="zoom-in SMbutton" type="button" value="Zoom In" /></li>'),
              jQuery('<li><input class="zoom-out SMbutton" type="button" value="Zoom Out" /></li>'),
              jQuery('<li><input class="zoom-fit SMbutton" type="button" value="View Entire Map" /></li>')
            ), jQuery('<div>', {
              'class': 'SMmap-window',
              style: 'width: 680px; height: 510px;'})
            .append(
              $mapImg, jQuery('<div>', {'class': 'SMmap-overlay'})
            )
          );
        for(var j = 0; j < map.ranges.length; j++) { //bubble text
          var callnoText = 'Range ' + map.ranges[j].rangename + '<br />';
          if(map.ranges[j].startcallno != '*') {
            callnoText += map.ranges[j].startcallno + ' -<br /> ' + map.ranges[j].endcallno;
          }
          var callnoX = map.ranges[j].x - 10;
          var callnoY = map.ranges[j].y - 45;
          $map.find('.SMmap-overlay').append(jQuery('<div>',
                      {'class': 'SMpin-target loc-x loc-y size-x size-y',
                      x: callnoX,
                      y: callnoY,
                      style: 'left:' + callnoX + 'px; top:' + callnoY + 'px;"'})
                  .html('&nbsp;')
                  .attr('height', 44).attr('width', 25)
                  .append(jQuery('<div>',
                          {'class': 'SMtooltip-contents', style: 'display:none;'})
                      .html(callnoText)
                      )
                  );
        }
        var $sidebar = jQuery('<div>', {'class': 'SMmore-info'});
        var $sidebarContents = jQuery('<ul>').append(
              jQuery('<li><p><strong>Directions</strong>: ' + map.directions + '</p></li>'),
              jQuery('<li><strong>Call Number</strong></li>'),
              jQuery('<li>' + result.callno + '</li>'),
              jQuery('<li><strong>Item Location</strong></li>'),
              jQuery('<li><p>The item is on shelf highlighted in red and labeled as:</p></li>')
        );
        for(var j = 0; j < map.ranges.length; j++){
          var curData = '<li><strong>' + map.ranges[j].rangename + '</strong>';
          if(map.ranges[j].startcallno != '*')
              curData += ': ' + map.ranges[j].startcallno + '-' + map.ranges[j].endcallno;
          curData += '</li>';
          $sidebarContents.append(jQuery(curData));
        }
        $sidebar.append($sidebarContents);
        $popup.append($map, $sidebar);
        $popup.append(jQuery('<span class="SMpowered-by">Powered by <a target="_blank" href="http://stackmap.com">stackmap.com</a></span>'));
        return $popup;
      }
    },
    openPrinterFriendly: function(callno, location, library, title) {
        var pfUrl = StackMap.domain + '/view/?callno=' + callno + '&amp;location=' + location.replace('&amp;', '%26') + '&amp;library=' + library + '&amp;title=' + title + '&amp;v=pf';
        window.open(pfUrl, 'stackmap', 'width=950,height=800,toolbar=no,directories=no,scrollbars=1,location=no,menubar=no,status=no,left=0,top=0');
        return false;
    },
    showPopup: function(popupId){
        console.log(popupId)
        var $popup = jQuery('#' + popupId);
        console.log($popup)
        console.log($popup.data('opened'))
        if(!$popup.data('opened')){
            if(StackMap.delayImgLoad){
                var $mapImg = $popup.find('.SMmap');
                $mapImg.attr('src', $mapImg.attr('othersrc'));
            }
            var postData = {callno: $popup.data('callno'),
                    library: $popup.data('library'),
                    location: $popup.data('location'),
                    action: 'mapit'};
            jQuery.getJSON(StackMap.domain + "/logmapit/?callback=?", postData);  // TODO
            $popup.data('opened', true);
        }

        var left = Math.max(0, (jQuery(window).width() - 890) / 2 + jQuery(window).scrollLeft());
        $popup.css("top", (jQuery(window).scrollTop() + 10)  + "px")
               .css("left", left + "px").show();

        jQuery('#SMblock-screen').css('height', jQuery(document).height()).show();
    },
    hideAllPopups: function(){
        jQuery('.SMpopup').hide();
        jQuery('#SMblock-screen').hide();
    }
}
jQuery(document).ready(StackMap.setup);
