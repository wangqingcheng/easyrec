<%-- 
    Document   : apitestjson
    Created on : 19.08.2015, 11:20:15
    Author     : stephan
--%>

<script>
    var easyrec = angular.module('easyrec', ['easyrecControllers']);
    
    var easyrecControllers = angular.module('easyrecControllers', []);
    
    easyrecControllers.controller('TestController', ['$scope', '$http', 
        function ($scope, $http) {
            
            /**
            * The workhorse; converts an object to x-www-form-urlencoded serialization.
            * @param {Object} obj
            * @return {String}
            */ 
           var encodeParam = function(obj) {
             var query = '', name, value, fullSubName, subName, subValue, innerObj, i;

             for(name in obj) {
               value = obj[name];

               if(value instanceof Array) {
                 for(i=0; i<value.length; ++i) {
                   subValue = value[i];
                   fullSubName = name + '[' + i + ']';
                   innerObj = {};
                   innerObj[fullSubName] = subValue;
                   query += param(innerObj) + '&';
                 }
               }
               else if(value instanceof Object) {
                 for(subName in value) {
                   subValue = value[subName];
                   fullSubName = name + '[' + subName + ']';
                   innerObj = {};
                   innerObj[fullSubName] = subValue;
                   query += param(innerObj) + '&';
                 }
               }
               else if(value !== undefined && value !== null)
                 query += encodeURIComponent(name) + '=' + encodeURIComponent(value) + '&';
             }

             return query.length ? query.substr(0, query.length - 1) : query;
           };
            
            $scope.calls = [
                {name: 'store', method :'POST'},
                {name: 'delete', method :'DELETE'},
                {name: 'load', method :'GET'},
                {name: 'field/store', method :'PUT'},
                {name: 'field/push', method :'PUT'},
                {name: 'field/load', method :'GET'},
                {name: 'field/delete', method :'DELETE'},
                {name: 'storeitemwithprofile', method :'POST'}
            ];
            
            $scope.host = "http://localhost:8084/easyrec-web/api/1.1/json/profile/";
            $scope.apicall = $scope.calls[0];
            $scope.apikey = "8ab9dc3ffcdac576d0f298043a60517a";
            $scope.tenantid = "EASYREC_DEMO";
            $scope.itemid = "42";
            $scope.itemtype = "ITEM";
            $scope.encode = "json";
            
            $scope.req = function() {
                
                var url = $scope.host + $scope.apicall.name;
                var option = {
                    apikey : $scope.apikey,
                    tenantid : $scope.tenantid,
                    itemid : $scope.itemid,
                    itemtype : $scope.itemtype,
                    itemdescription : $scope.itemdescription,
                    itemurl : $scope.itemurl,
                    itemimageurl : $scope.itemimageurl,
                    profile : $scope.profile,
                    path : $scope.path,
                    key : $scope.key,
                    value : $scope.value
                };
                var meth = $scope.apicall.method;
                var pars = {
                    method: meth,
                    url: url
                };
                if (meth==='GET' || meth==='DELETE') {
                    pars.params = option;
                } else {
                    if ($scope.encode==='json') {
                        pars.data = option;
                    } else {
                        pars.data = encodeParam(option);
                        pars.headers = {'Content-Type' : 'application/x-www-form-urlencoded'};
                    }
                }
                
                $http(pars).
                success(function(data, status){
                    $scope.status = status;
                    $scope.data = data;
                }).
                error(function(data, status){
                    $scope.status = status;
                    $scope.data = data || "Request failed";
                });
            };
            
    }]);
    
</script>
<div ng-app="easyrec">
<div ng-controller="TestController">
    <input id="host" ng-model="host" style="width:100%" value="http://localhost:8080/easyrec-web/api/1.1/json/profile/"><br>
    Profile API call<br>
    <select ng-model="apicall" ng-options="call.name group by call.method for call in calls" id="servletname" style="width:30%;">
    </select>
    {{apicall}}
    <div ng-hide="apicall.method === 'GET' || apicall.method === 'DELETE'" >
        <input type="radio" ng-model="encode" value="json">json
        <input type="radio" ng-model="encode" value="form">x-www-form-urlencoded<br>
    </div>
    <hr/>
    apikey<input ng-model="apikey" id="apikey" style="width:100%"><br>
    tenantid<input ng-model="tenantid" id="tenantid" style="width:100%"><br>
    <hr/>
    itemid<input ng-model="itemid" id="itemid" style="width:100%"><br>
    itemtype<input ng-model="itemtype" id="itemtype" style="width:100%"><br>
    <div ng-show="apicall.name === 'storeitemwithprofile'">
        itemdescription<input ng-model="itemdescription" id="itemdescription" style="width:100%"><br>
        itemurl<input ng-model="itemurl" id="itemurl" style="width:100%"><br>
        itemimageurl<input ng-model="itemimageurl" id="itemimageurl" style="width:100%"><br>
    </div>
    <hr/>
    <div ng-show="apicall.name === 'store' || apicall.name === 'storeitemwithprofile'">
        profile<input ng-model="profile" id="profile" style="width:100%" /><br>
    </div>
    <div ng-show="apicall.name === 'field/store' || apicall.name === 'field/push' || apicall.name === 'field/load' || apicall.name === 'field/delete'">
        path<input ng-model="path" id="path" style="width:100%" /><br>
    </div>
    <div ng-show="apicall.name === 'field/store'">
        key<input ng-model="key" id="key" style="width:100%" /><br>
    </div>
    <div ng-show="apicall.name === 'field/store' || apicall.name === 'field/push'">
        value<input ng-model="value" id="value" style="width:100%" /><br>
    </div>
    <a href="#" ng-click="req()">SEND ACTION</a>

    {{status}}
    {{data}}
</div>
    </div>
