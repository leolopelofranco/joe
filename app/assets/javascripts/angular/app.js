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


Joe.factory("User", ["http", "$q", "$rootScope", "AuthService", function($http, $q, $rootScope, AuthService) {
var user = null;
return {
    fetchUser: function() {
        AuthService.currentUser()
          .then(function(user){
            if (user) {
              $rootScope.isLoggedIn = true;
              u = user;
              return u;
            }
          });


    },
    getUser : function(){
        return user;
    },
    setUser : function(u){
        user = u;
    }
  }
}]);
