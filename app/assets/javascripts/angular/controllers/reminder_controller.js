angular.module('Joe.controllers')
  .controller('ReminderController', ["$scope", "$state", "ReminderService", "AuthService", function($scope, $state, ReminderService, AuthService) {
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

    $scope.directions = [
      {
        "name":"none"
      },
      {
        "name": "Before Meals"
      },
      {
        "name": "After Meals"
      }
    ]

    $scope.direction = $scope.directions[0]

    $scope.medicines=[{id:1}];

    $scope.addMedicine= function(){
      var newItemNo =$scope.medicines.length+1;
      console.log(newItemNo);
      $scope.medicines.push({'id': newItemNo});

    };

    $scope.options = {
      interval: 15
    }

    AuthService.currentUser()
    .then(function(d){
      $scope.submitReminderForm = function() {

        times = _.map($scope.alerts, function(m) {return moment(m.time).format('HH:mm')});

        $scope.reminder.frequency = $scope.frequency
        $scope.reminder.days  = c.toString()
        $scope.reminder.every  = times.toString()
        $scope.reminder.every_array = times
        $scope.reminder.start_date = $scope.date.startDate
        $scope.reminder.end_date = $scope.date.endDate
        $scope.reminder.status = 'active'
        $scope.reminder.user_id = d.id

        $scope.reminder.medicines = $scope.medicines

        console.log($scope.reminder)

        ReminderService.createReminder($scope.reminder)
          .then(function(d){
          console.log(d)

          $state.go('detail', {patient_id: d.id});
        })
      }
    });

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
