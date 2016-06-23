var Joe = angular.module('Joe', [
  'ui.router',
  'ngCookies',
  'angular-datepicker',
  'daterangepicker',
  'Devise',
  'Joe.controllers',
  'Joe.directives',
  'Joe.services'
]);


Joe.run(["$rootScope", "UserService", "AuthService", function($rootScope, UserService, AuthService){
  // Set color for ngProgress to
  // Muber color scheme
  AuthService.currentUser()
    .then(function(user){
      if (user) {
        $rootScope.isLoggedIn = true;
      } else {
        $rootScope.isLoggedIn = false;
      }
    });
}]);
