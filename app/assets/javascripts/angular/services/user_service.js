angular.module('Joe.services')
  .service('UserService', ["$q", "$http", "$cookies", "$rootScope", "AuthService", function($q, $http, $cookies, $rootScope, AuthService){
    var service = this;

    this.setUserFromFb = function(fb_credentials) {
      var d = $q.defer();
      $http({
        url: '/users/fb_login',
        method: 'POST',
        data: {
          user: fb_credentials
        }
      }).success(function(response){
        var user = response.data.user;
        user.auth_token = response.data.auth_token;
        AuthService.setCurrentUser(user);
        d.resolve(user);
      }).error(function(reason) {
        d.reject(reason);
      });
      return d.promise;
    };

    this.signup = function(params) {
      var d = $q.defer();
      $http({
        url: '/users',
        method: 'POST',
        data: {
          user: params
        }
      }).success(function(response) {
        var user = response.data.user;
        user.auth_token = response.data.auth_token;
        AuthService.setCurrentUser(user);
        d.resolve(user);
      }).error(function(reason) {
        d.reject(reason);
      });
      return d.promise;
    };

    this.login = function(params) {
      var d = $q.defer();
      $http({
        url: '/users/login',
        method: 'POST',
        data: {
          user: params
        }
      }).success(function(response) {
        if (response.success) {
          var user = response.data.user;
          user.auth_token = response.data.auth_token;
          AuthService.setCurrentUser(user);
          d.resolve(user);
        } else {
          d.reject(response);
        }
      }).error(function(reason) {
        d.reject(reason);
      });
      return d.promise;
    };

    this.logout = function(id) {
      var d = $q.defer();
      $http({
        url: '/users/' + id + '/logout',
        method: 'DELETE'
      }).success(function(response) {
        console.log(response)
        service._user = null;
        $cookies.remove('user')
        console.log($cookies.getAll())
        $rootScope.isLoggedIn = false;
        d.resolve();
      }).error(function(reason){
        console.log(reason)
        d.reject();
        // TODO: implement if logout fails
      });
      return d.promise;
    };

    this.change_password = function(user) {
      var d = $q.defer();
      $http({
        url: '/users/' + user.id + '/password',
        method: 'POST',
        data: {
          user: user
        }
      }).success(function(response) {
        console.log(response)
        // service._user = null;
        // $cookies.remove('user')
        // console.log($cookies.getAll())
        // $rootScope.isLoggedIn = false;
        // d.resolve();
      }).error(function(reason){
        console.log(reason)
        d.reject();
        // TODO: implement if logout fails
      });
      return d.promise;

    }
}]);
