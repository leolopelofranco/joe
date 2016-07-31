angular.module('Joe.controllers')
  .controller('HomeController', ["$scope", "$state", "AuthService", "$cookies", "Auth", "UserService", "$rootScope", function($scope, $state, AuthService, $cookies, Auth, UserService, $rootScope) {


    
    if($cookies.getObject('user')) {
      $state.go('welcome', {patient_id: $cookies.getObject('user').id});
    }

    $scope.login = function() {
      $state.go('login');
    }

    $scope.signup = function() {
      $state.go('signup');
    }

    $scope.user = {}

    $scope.submitLogin = function() {

      UserService.login($scope.user).then(
        function(user) {
          $state.go('welcome', {patient_id: user.id});
        },
        function (reason) {
          console.log(reason)
          $scope.user.errors = reason;

        })
    }

}]);
