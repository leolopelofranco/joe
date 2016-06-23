angular.module('Joe.controllers')
  .controller('IndexController', ["$scope", "$state", "AuthService", "$cookies", "Auth", "UserService", "$rootScope", function($scope, $state, AuthService, $cookies, Auth, UserService, $rootScope) {

    $scope.login = function() {
      $state.go('login');
    }

    $scope.signup = function() {
      $state.go('signup');
    }

    $scope.user = {}

    if($rootScope.isLoggedIn) {
      AuthService.currentUser()
        .then(function(user){
          $state.go('welcome', {patient_id: user.id});
        });
    }


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
