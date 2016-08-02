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

          $scope.scheduleLength = d.schedules.length
        _.each(d.schedules, function(e){
          e.schedule.end_date = moment(e.schedule.end_date).format('ll')
          e.schedule.start_date = moment(e.schedule.start_date).format('ll')
          e.schedule.every = e.schedule.every.split(',');

          formatted_times = []
          _.each(e.schedule.every, function(a){
            formatted_times.push(moment(a, ["HH:mm"]).format("h:mm A"))
          });
          formatted_times.sort(function (a, b) {
            return new Date('1970/01/01 ' + a) - new Date('1970/01/01 ' + b);
          });

          all_alarms = ''
          _.each(formatted_times, function(a){
            all_alarms = all_alarms + a + '|'
          });
          e.schedule.every = all_alarms

          all_days = ''
          if(e.schedule.days.length ==7) {
            e.schedule.days = 'Everyday'
          }
          else {
            _.each(e.schedule.days, function(a){
              day =  dayOfWeekAsString(a)
              all_days = all_days + day + ','
            });
            e.schedule.days = all_days
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
