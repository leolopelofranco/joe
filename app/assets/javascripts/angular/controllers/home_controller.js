angular.module('Joe.controllers')
  .controller('HomeController', ["$scope", "$state", function($scope, $state) {

    $scope.reminder = function() {
      $state.go('list');
    }

  }]);
