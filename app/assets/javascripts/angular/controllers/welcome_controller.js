angular.module('Joe.controllers')
  .controller('WelcomeController', ["$scope","$rootScope", "$state", "AuthService", "$cookies", "Auth", "UserService", function($scope, $rootScope, $state, AuthService, $cookies, Auth, UserService) {


    $scope.user = {}

    $scope.hello = { "x": "hello"}

    console.log($cookies.getAll())

    AuthService.currentUser()
    .then(function(d){
      if(d) {
        $scope.reminder = function() {
          $state.go('detail', {patient_id: d.id});
        }
        $scope.logout = function() {
          if($cookies.getObject('user')) {
            UserService.logout(d.id)
              .then(function(){
                $state.go('index');
              })
          }
        };

        $scope.res = function() {
          $state.go('password');
        }

        $scope.changePassword = function() {
          $scope.user.id = d.id
          UserService.change_password($scope.user)
            .then(function(){
              UserService.logout(d.id)
                .then(function(){
                  $state.go('index');
                })
            })
        }
      }
      else {
        $state.go('index');
      }
    })






  }]);
