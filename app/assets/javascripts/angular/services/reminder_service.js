angular.module('Joe.services')
  .service('ReminderService', ["$q", "$http", function($q, $http) {
    this.createReminder = function(data) {

      var d = $q.defer();
      $http({
        method: 'POST',
        url: '/reminder',
        data: data
      }).success(function(data){
        d.resolve(data);
      });

      return d.promise;
    }

    this.setReminder = function() {
      var d = $q.defer();
      $http({
        method: 'GET',
        url: '/reminder/set',
      }).success(function(data){
        d.resolve(data);
      });

      return d.promise;
    }

    this.getList = function() {
      var d = $q.defer();
      $http({
        method: 'GET',
        url: '/patient/list',
      }).success(function(data){
        d.resolve(data);
      });

      return d.promise;
    }

    this.getPatient = function(patient_id) {
      var d = $q.defer();
      $http({
        method: 'GET',
        url: '/patient/' + patient_id,
      }).success(function(data){
        d.resolve(data);
      });

      return d.promise;
    }

    this.getSchedule = function(patient_id, schedule_id) {
      var d = $q.defer();
      $http({
        method: 'GET',
        url: '/patient/' + patient_id + '/schedule/' + schedule_id,
      }).success(function(data){
        d.resolve(data);
      });

      return d.promise;
    }

    this.editSchedule = function(data) {
      var d = $q.defer();
      $http({
        method: 'POST',
        url: '/reminder/edit',
        data: data
      }).success(function(data){
        d.resolve(data);
      });

      return d.promise;
    }

  }]);
