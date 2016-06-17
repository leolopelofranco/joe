angular.module('Joe.controllers')
  .controller('ListController', function($scope, ReminderService, $state, $stateParams) {
    ReminderService.getList()
      .then(function(d){
      $scope.data = d
    })

    $scope.clickedPatient = function(patient){
      $state.go('detail', {patient_id: patient.user_id});
    };

    $scope.addReminder = function() {
      $state.go('reminder');
    }



});
