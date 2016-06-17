angular.module('Joe.controllers')
  .controller('HomeController', function($scope, $state) {

    $scope.reminder = function() {
      $state.go('list');
    }

  });
