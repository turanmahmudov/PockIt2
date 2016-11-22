// Login
function get_request_token(results) {
    if (results) {
        User.setKey('request_token', results['code'])

        pageLayout.replacePageSource(Qt.resolvedUrl("../ui/Login.qml"))
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

// Get list from Pocket API
function get_list(results) {
    if (results) {
        var entriesData = []
        for (var k in results['list']) {
            entriesData.push(results['list'][k]);
        }
    } else {
        var access_token = User.getKey('access_token');

        var url = 'https://getpocket.com/v3/get';
        var data = "state=all&sort=oldest&detailType=complete&consumer_key="+ApiKeys.consumer_key+"&access_token="+access_token;

        request(url, data, get_list);
    }
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
