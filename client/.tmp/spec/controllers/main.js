(function() {
  'use strict';
  describe('Controller: MainCtrl', function() {
    var MainCtrl, scope;
    beforeEach(module('frontApp'));
    MainCtrl = {};
    scope = {};
    beforeEach(inject(function($controller, $rootScope) {
      scope = $rootScope.$new();
      return MainCtrl = $controller('MainCtrl', {});
    }));
    return it('should attach a list of awesomeThings to the scope', function() {
      return expect(MainCtrl.awesomeThings.length).toBe(3);
    });
  });

}).call(this);

//# sourceMappingURL=main.js.map
