(function() {
  "use strict";
  angular.module("frontApp").factory("BaseService", function() {
    return {
      calMapDistance: function(zoom) {
        var clientPx, meterPerPx, targetDistance, targetMeterPerPx;
        meterPerPx = 60;
        targetMeterPerPx = meterPerPx / (zoom - 10);
        clientPx = document.body.clientWidth;
        if (document.body.clientHeight > document.body.clientWidth) {
          clientPx = document.body.clientHeight;
        }
        targetDistance = clientPx * targetMeterPerPx;
        return targetDistance;
      }
    };
  });

}).call(this);

//# sourceMappingURL=base-service.js.map
