angular.module('Joe.controllers')
  .controller('DetailController', ["$scope", "ReminderService", "$state", "$stateParams", "Auth", "AuthService", function($scope, ReminderService, $state, $stateParams, Auth, AuthService) {


    function dayOfWeekAsString(dayIndex) {
      return ["Sun","Mon","Tue","Wed","Thur","Fri","Sat"][dayIndex];
    }

    AuthService.currentUser()
    .then(function(d){

      $scope.schedule = function() {
        $state.go('reminder', {patient_id: d.id});
      }

      if(d) {

      ReminderService.getPatient(d.id)
        .then(function(d){

          console.log(d)

          $scope.scheduleLength = d.schedules.length
        _.each(d.schedules, function(e){
          e.end_date = moment(e.end_date).format('ll')
          e.start_date = moment(e.start_date).format('ll')
          e.every = e.every.split(',');

          formatted_times = []
          _.each(e.every, function(a){
            formatted_times.push(moment(a, ["HH:mm"]).format("h:mm A"))
          });
          formatted_times.sort(function (a, b) {
            return new Date('1970/01/01 ' + a) - new Date('1970/01/01 ' + b);
          });

          all_alarms = ''
          _.each(formatted_times, function(a){
            all_alarms = all_alarms + a + '|'
          });
          e.every = all_alarms

          all_days = ''
          if(e.days.length ==7) {
            e.days = 'Everyday'
          }
          else {
            _.each(e.days, function(a){
              day =  dayOfWeekAsString(a)
              all_days = all_days + day + ','
            });
            e.days = all_days
          }
        });
        $scope.patient = d
        console.log($scope.patient)
      })

      }
      else {
        $state.go('index');
      }

      $scope.edit = function(schedule_id) {
        $state.go('edit_schedule', {patient_id: $stateParams.patient_id, schedule_id: schedule_id});
      }
    })







}]);
