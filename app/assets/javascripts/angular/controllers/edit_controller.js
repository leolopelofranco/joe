angular.module('Joe.controllers')
  .controller('EditController', ["$scope", "ReminderService", "$state", "$stateParams", function($scope, ReminderService, $state, $stateParams) {
    $scope.date = {
        startDate: moment(),
        endDate: moment().add(7, "days")
    };
    c = []
    $scope.frequencies = [
        {
        name: "1 Time a Day",
        value: 1},
    {
        name: "2 Times a Day",
        value: 2},
    {
        name: "3 Times a Day",
        value: 3},
    {
        name: "4 Times a Day",
        value: 4}];

    $scope.reminder = {}

    $scope.selected =
    {
      ids: {"1": false}
    };
    $scope.alerts = []

    ReminderService.getSchedule($stateParams.patient_id,$stateParams.schedule_id)
      .then(function(d){
        console.log(d)
        // To initialize checked marks from days
        _.each(d.schedule.days, function(e) {
          $scope.selected.ids[e] = true
        });

        // To initialize checked marks from days
        _.each(d.schedule.every.split(','), function(e,index) {
          a = {
            alert: index+1,
            time:moment(e, ["HH:mm"]).toDate()
          }

          $scope.alerts.push(a)
        });

        $scope.medicines = d.medicines
        $scope.frequency = d.schedule.frequency
        $scope.reminder.days  = d.schedule.days
        $scope.reminder.every  = d.schedule.every
        $scope.reminder.start_date = moment($scope.date.startDate).format('LLLL')
        $scope.reminder.end_date = moment($scope.date.endDate).format('LLLL')
        $scope.reminder.status = d.schedule.status
        $scope.reminder.schedule_id = d.schedule.schedule_id

    });

    $scope.addMedicine= function(){
      var newItemNo =$scope.medicines.length+1;
      console.log(newItemNo);
      $scope.medicines.push({'med_count': newItemNo});

    };

    $scope.change = function() {
      $scope.alerts = []
       _.times($scope.frequency, function(e) {
         a = {
           alert: e+1,
           time:""
         }
         $scope.alerts.push(a)
       });
    }

    $scope.save = function() {

      times = _.map($scope.alerts, function(m) {return moment(m.time).format('HH:mm')});

      c=Object.keys($scope.selected.ids)
      .filter(function(k){return $scope.selected.ids[k]})
      .map(Number)
      console.log(c)
      $scope.reminder.days  = c.toString()
      $scope.reminder.every  = times.toString()
      $scope.reminder.start_date = moment($scope.date.startDate).format('LLLL')
      $scope.reminder.end_date = moment($scope.date.endDate).format('LLLL')
      $scope.reminder.frequency = $scope.frequency

      d = {
        medicines: $scope.medicines,
        schedule: $scope.reminder
      }

      console.log(d)

      ReminderService.editSchedule(d)
        .then(function(d){
          console.log(d)
      });
    }

    $scope.choose= function() {
      c=Object.keys($scope.selected.ids)
      .filter(function(k){return $scope.selected.ids[k]})
      .map(Number)

      console.log(c)

    }


}]);
