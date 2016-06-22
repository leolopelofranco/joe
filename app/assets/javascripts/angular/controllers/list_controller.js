angular.module('Joe.controllers')
  .controller('ListController', ["$scope", "ReminderService", "$state", "$stateParams", "Auth", function($scope, ReminderService, $state, $stateParams, Auth) {

    console.log(Auth.isAuthenticated());
    Auth.currentUser().then(function(user) {
            // User was logged in, or Devise returned
            // previously authenticated session.
            console.log(user); // => {id: 1, ect: '...'}

            ReminderService.getList()
              .then(function(d){
              $scope.data = d
            })
        }, function(error) {
            // unauthenticated error
        });



    $scope.clickedPatient = function(patient){
      $state.go('detail', {patient_id: patient.user_id});
    };

    $scope.addReminder = function() {
      $state.go('reminder');
    }



}]);
