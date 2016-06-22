angular.module('Joe.controllers')
  .controller('HomeController', ["$scope", "$state", "AuthService", "$cookies", function($scope, $state, AuthService, $cookies) {

    AuthService.currentUser()
    .then(function(d){
      $scope.reminder = function() {
        $state.go('detail', {patient_id: d.id});
      }
    })






    $scope.user = {}

    $scope.submitLogin = function() {
      Auth.login(user);

    }

  }]);
