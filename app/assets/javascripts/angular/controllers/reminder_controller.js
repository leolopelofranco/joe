angular.module('Joe.controllers')
  .controller('ReminderController', ["$scope", "$state", "ReminderService", function($scope, $state, ReminderService) {
    $scope.selected =
    {
      ids: {"1": false}
    };
    c = []
    $scope.reminder = {}
    $scope.frequency = 1
    $scope.alerts = [ {
      alert: 1,
      time:""
    }]

    $scope.date = {
        startDate: moment(),
        endDate: moment().add(7, "days")
    };

    $scope.medicines=[{id:1}];

    $scope.addMedicine= function(){
      var newItemNo =$scope.medicines.length+1;
      console.log(newItemNo);
      $scope.medicines.push({'id': newItemNo});

    };

    $scope.options = {
      interval: 15
    }


    $scope.submitReminderForm = function() {

      times = _.map($scope.alerts, function(m) {return moment(m.time).format('HH:mm')});

      $scope.reminder.frequency = $scope.frequency
      $scope.reminder.days  = c.toString()
      $scope.reminder.every  = times.toString()
      $scope.reminder.every_array = times
      $scope.reminder.start_date = $scope.date.startDate
      $scope.reminder.end_date = $scope.date.endDate
      $scope.reminder.status = 'active'
      $scope.reminder.mobile = "63" + $scope.reminder.mobile

      $scope.reminder.medicines = $scope.medicines

      console.log($scope.reminder)

      ReminderService.createReminder($scope.reminder)
        .then(function(d){
        console.log(d)

        $state.go('list');
      })
    }

    $scope.choose= function() {
      c=Object.keys($scope.selected.ids)
      .filter(function(k){return $scope.selected.ids[k]})
      .map(Number)

      console.log(c)

    }

    $scope.change = function() {
      $scope.alerts = []
       _.times($scope.frequency, function(e) {
         d = {
           alert: e+1,
           time:""
         }
         $scope.alerts.push(d)
       });
    }

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

  }]);
