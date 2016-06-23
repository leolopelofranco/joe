angular.module('Joe.controllers')
  .controller('IndexController', ["$scope", "$state", "AuthService", "$cookies", "Auth", "UserService", function($scope, $state, AuthService, $cookies, Auth, UserService) {
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
