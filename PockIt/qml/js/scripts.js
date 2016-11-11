// Login
function get_request_token(results) {
    if (results) {
        User.setKey('request_token', results['code'])

        pageLayout.replacePage(Qt.resolvedUrl("../ui/Login.qml"))
    } else {
        var url = 'https://getpocket.com/v3/oauth/request'
        var data = "consumer_key="+ApiKeys.consumer_key+"&redirect_uri=https://api.github.com/zen"

        request(url, data, get_request_token)
    }
}

function get_access_token(results, res_code) {
    if (results) {
        if (results['access_token']) {
            User.setKey('access_token', results['access_token'])
            User.setKey('username', results['username'])

            mainView.init()
        }
    } else {
        var code = res_code ? res_code : User.getKey('request_token')

        var url = 'https://getpocket.com/v3/oauth/authorize'
        var data = "consumer_key="+ApiKeys.consumer_key+"&code="+code

        request(url, data, get_access_token)
    }
}

// Logout
function logOut() {
    User.deleteKey('access_token')
    User.deleteKey('request_token')
    User.deleteKey('username')

    mainView.init()
}

// Request
function request(url, params, callback) {
    var xhr = new XMLHttpRequest;
    xhr.open("POST", url);

    var data = params;

    xhr.setRequestHeader("Content-type","application/x-www-form-urlencoded; charset=UTF8");
    xhr.setRequestHeader("X-Accept", "application/json");

    xhr.onreadystatechange = function() {
        if (xhr.readyState === XMLHttpRequest.DONE) {

            console.log(xhr.responseText)

            if (xhr.responseText == "403 Forbidden") {
                console.log(xhr.getResponseHeader('X-Limit-User-Reset'))
                console.log(xhr.responseText)
                return false;
            }

            var results = JSON.parse(xhr.responseText);
            callback(results);
        }
    }

    xhr.send(data);
}

function extractDomain(url) {
    var domain;
    //find & remove protocol (http, ftp, etc.) and get domain
    if (typeof(url) === "undefined") {
        return '';
    }
    if (url.indexOf("://") > -1) {
        domain = url.split('/')[2];
    }
    else {
        domain = url.split('/')[0];
    }

    //find & remove port number
    domain = domain.split(':')[0];

    return domain;
}

function objectLength(obj) {
  var result = 0;
  for(var prop in obj) {
    if (obj.hasOwnProperty(prop)) {
      result++;
    }
  }
  return result;
}
