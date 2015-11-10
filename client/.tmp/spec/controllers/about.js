(function() {
  'use strict';
  describe('Controller: AboutCtrl', function() {
    var AboutCtrl, scope;
    beforeEach(module('frontApp'));
    AboutCtrl = {};
    scope = {};
    beforeEach(inject(function($controller, $rootScope) {
      scope = $rootScope.$new();
      return AboutCtrl = $controller('AboutCtrl', {});
    }));
    return it('should attach a list of awesomeThings to the scope', function() {
      return expect(AboutCtrl.awesomeThings.length).toBe(3);
    });
  });

}).call(this);

//# sourceMappingURL=about.js.map
