(function() {
  "use strict";
  angular.module("frontApp").directive('fileModel', function($parse) {
    return {
      restrict: 'A',
      link: function(scope, element, attrs) {
        var model;
        model = $parse(attrs.fileModel);
        return element.bind('change', function() {
          return scope.$apply(function() {
            return model.assign(scope, element[0].files[0]);
          });
        });
      }
    };
  }).directive('categoryList', function() {
    return {
      restrict: 'A',
      scope: {
        data: '='
      },
      link: function(scope, element, attrs) {
        var text;
        text = [];
        angular.forEach(scope.data, function(cat) {
          return text.push(cat.name);
        });
        return element.append(text.join("・"));
      }
    };
  });

}).call(this);

//# sourceMappingURL=base-directive.js.map
