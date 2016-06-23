angular.module('Joe.controllers')
  .controller('HomeController', ["$scope", "$state", "AuthService", "$cookies", "Auth", "UserService", function($scope, $state, AuthService, $cookies, Auth, UserService) {

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

                $cookies.remove('user')
                console.log($cookies.getAll())
                $state.go('index');
              })
          }
        };
      }
      else {
        $state.go('index');
      }
    })






    $scope.login = function() {
      $state.go('login');
    }



  }]);
