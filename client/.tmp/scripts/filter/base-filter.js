(function() {
  "use strict";
  angular.module("frontApp").filter('newlines', function() {
    return function(text) {
      if (text != null) {
        return text.replace(/\n/g, '<br />');
      }
    };
  }).filter('rekishokuText', function() {
    return function(text) {
      if (text != null) {
        return text.replace('歴食', '<span class="hidden-xs">歴食</span>');
      }
    };
  });

}).call(this);

//# sourceMappingURL=base-filter.js.map
