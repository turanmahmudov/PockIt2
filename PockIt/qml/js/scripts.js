// Get request token from API & Save request token to DB and open login page
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

// Get access token from API & Save access token, username to DB and "start" the app
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

// Logout (Delete access_token, request_token and username from DB)
function logOut() {
    User.deleteKey('access_token')
    User.deleteKey('request_token')
    User.deleteKey('username')

    mainView.init()
}

// Get list from Pocket API & Start syncing
function get_list(results) {
    console.log('get list started')

    if (results) {
        var entriesData = {}
        for (var k in results['list']) {
            entriesData[k] = results['list'][k]
        }

        // Check if 'stop syncing' pressed
        if (syncing_stopped) {
            syncing = false
            screenSaver.screenSaverEnabled = true
            return false
        }

        // Start syncing
        sync_start(entriesData)
    } else {
        syncing_stopped = false
        syncing = true
        entryworksfinished(false)

        var access_token = User.getKey('access_token');

        var url = 'https://getpocket.com/v3/get';
        var data = "state=all&sort=oldest&detailType=complete&consumer_key="+ApiKeys.consumer_key+"&access_token="+access_token;

        request(url, data, get_list);
    }
}

// Sync start (GET all entries from DB and send data to sync worker)
function sync_start(api_entries) {
    console.log('sync loop worked')

    firstSync = false

    screenSaver.screenSaverEnabled = false

    var db = LocalDB.init();
    db.transaction(function(tx) {
        var rs = tx.executeSql("SELECT item_id, time_updated FROM Entries")
        var dbEntriesData = {}
        for(var i = 0; i < rs.rows.length; i++) {
            dbEntriesData[rs.rows.item(i).item_id] = rs.rows.item(i);
        }

        // Check if 'stop syncing' pressed
        if (syncing_stopped) {
            syncing = false
            screenSaver.screenSaverEnabled = true
            return false
        }

        // Start sync worker
        sync_worker.sendMessage({'api_entries': api_entries, 'db_entries': dbEntriesData});
    })
}

// Complete entries work (Worker sends processed data here)
function complete_entries_works(entries_works, api_entries) {
    console.log('complete entries worked')

    var mustGetArticlesList = []

    var db = LocalDB.init();
    db.transaction(function(tx) {
        var loop_index = 0
        for (var ew_i in entries_works) {

            // Check if 'stop syncing' pressed
            if (syncing_stopped) {
                syncing = false
                screenSaver.screenSaverEnabled = true
                return false
            }

            if (entries_works[ew_i].action === 'INSERT') {
                // Entries
                var image = (api_entries[ew_i].has_image == '1' && api_entries[ew_i].image) ? JSON.stringify(api_entries[ew_i].image) : '{}';
                var rs = tx.executeSql("INSERT INTO Entries(item_id, resolved_id, given_url, resolved_url, given_title, resolved_title, sortid, is_article, has_image, has_video, favorite, status, excerpt, word_count, tags, authors, images, videos, image, is_index, time_added, time_updated) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [api_entries[ew_i].item_id, api_entries[ew_i].resolved_id, api_entries[ew_i].given_url, api_entries[ew_i].resolved_url, api_entries[ew_i].given_title, api_entries[ew_i].resolved_title, api_entries[ew_i].sort_id, api_entries[ew_i].is_article, api_entries[ew_i].has_image, api_entries[ew_i].has_video, api_entries[ew_i].favorite, api_entries[ew_i].status, api_entries[ew_i].excerpt, api_entries[ew_i].word_count, JSON.stringify(api_entries[ew_i].tags), JSON.stringify(api_entries[ew_i].authors), JSON.stringify(api_entries[ew_i].images), JSON.stringify(api_entries[ew_i].videos), image, api_entries[ew_i].is_index, api_entries[ew_i].time_added, api_entries[ew_i].time_updated])

                // Tags
                for (var t in api_entries[ew_i].tags) {
                    var rs_t = tx.executeSql('INSERT INTO Tags(item_id, item_key, tag, entry_id) VALUES (?, ?, ?, ?)', [api_entries[ew_i].tags[t].item_id, t, api_entries[ew_i].tags[t].tag, api_entries[ew_i].item_id]);
                }

                // Fill must-get-articles list
                mustGetArticlesList.push({'item_id': ew_i, 'resolved_url': api_entries[ew_i].resolved_url})
            } else if (entries_works[ew_i].action === 'UPDATE') {
                // Entries
                var image = (api_entries[ew_i].has_image == '1' && api_entries[ew_i].image) ? JSON.stringify(api_entries[ew_i].image) : '{}';
                rs = tx.executeSql("UPDATE Entries SET resolved_id = ?, given_url = ?, resolved_url = ?, given_title = ?, resolved_title = ?, sortid = ?, is_article = ?, has_image = ?, has_video = ?, favorite = ?, status = ?, excerpt = ?, word_count = ?, tags = ?, authors = ?, images = ?, videos = ?, image = ?, is_index = ?, time_added = ?, time_updated = ? WHERE item_id = ?", [api_entries[ew_i].resolved_id, api_entries[ew_i].given_url, api_entries[ew_i].resolved_url, api_entries[ew_i].given_title, api_entries[ew_i].resolved_title, api_entries[ew_i].sort_id, api_entries[ew_i].is_article, api_entries[ew_i].has_image, api_entries[ew_i].has_video, api_entries[ew_i].favorite, api_entries[ew_i].status, api_entries[ew_i].excerpt, api_entries[ew_i].word_count, JSON.stringify(api_entries[ew_i].tags), JSON.stringify(api_entries[ew_i].authors), JSON.stringify(api_entries[ew_i].images), JSON.stringify(api_entries[ew_i].videos), image, api_entries[ew_i].is_index, api_entries[ew_i].time_added, api_entries[ew_i].time_updated, api_entries[ew_i].item_id])

                // Tags
                for (var t in api_entries[ew_i].tags) {
                    var rs_t_c = tx.executeSql("SELECT * FROM Tags WHERE item_key = ? AND entry_id = ?", [t, api_entries[ew_i].item_id]);
                    if (rs_t_c.rows.length === 0) {
                        var rs_t = tx.executeSql('INSERT INTO Tags(item_id, item_key, tag, entry_id) VALUES (?, ?, ?, ?)', [api_entries[ew_i].tags[t].item_id, t, api_entries[ew_i].tags[t].tag, api_entries[ew_i].item_id]);
                    } else {
                        var rs_t = tx.executeSql("UPDATE Tags SET tag = ? WHERE item_key = ? AND entry_id = ?", [api_entries[ew_i].tags[t].tag, t, api_entries[ew_i].item_id]);
                    }
                }

                // Fill must-get-articles list
                mustGetArticlesList.push({'item_id': ew_i, 'resolved_url': api_entries[ew_i].resolved_url})
            } else if (entries_works[ew_i].action === 'KEEP') {
                // Tags
                for (var t in api_entries[ew_i].tags) {
                    var rs_t_c = tx.executeSql("SELECT * FROM Tags WHERE item_key = ? AND entry_id = ?", [t, api_entries[ew_i].item_id]);
                    if (rs_t_c.rows.length === 0) {
                        var rs_t = tx.executeSql('INSERT INTO Tags(item_id, item_key, tag, entry_id) VALUES (?, ?, ?, ?)', [api_entries[ew_i].tags[t].item_id, t, api_entries[ew_i].tags[t].tag, api_entries[ew_i].item_id]);
                    } else {
                        var rs_t = tx.executeSql("UPDATE Tags SET tag = ? WHERE item_key = ? AND entry_id = ?", [api_entries[ew_i].tags[t].tag, t, api_entries[ew_i].item_id]);
                    }
                }

                // Fill must-get-articles list
                var rs_a = tx.executeSql("SELECT item_id FROM Articles WHERE item_id = ?", ew_i);
                if (rs_a.rows.length === 0) {
                    mustGetArticlesList.push({'item_id': ew_i, 'resolved_url': api_entries[ew_i].resolved_url})
                }
            } else {
                console.log('Something goes wrong.')
            }

            loop_index++
            if (loop_index === objectLength(entries_works)) {
                reinit_pages()
                entryworksfinished(true)
                if (mustGetArticlesList.length > 0 && downloadArticlesSync) {
                    get_article(mustGetArticlesList, 0)
                } else {
                    syncing = false
                    syncing_stopped = false
                    screenSaver.screenSaverEnabled = true
                }
            }

        }
    })
}

// Get article from API
function get_article(mustGetArticlesList, index) {

    // Check if 'stop syncing' pressed
    if (syncing_stopped) {
        syncing = false
        screenSaver.screenSaverEnabled = true
        return false
    }

    // Start articles sync worker
    articles_sync_worker.sendMessage({'item_id': mustGetArticlesList[index].item_id, 'resolved_url': mustGetArticlesList[index].resolved_url, 'index': index, 'mustGetArticlesList': mustGetArticlesList, 'consumer_key': ApiKeys.consumer_key});
}

// Complete articles works (Worker sends processed data here)
function complete_articles_works(article_result, item_id, finish) {
    console.log('complete articles worked')

    var db = LocalDB.init();
    db.transaction(function(tx) {

        // Check if 'stop syncing' pressed
        if (syncing_stopped) {
            syncing = false
            screenSaver.screenSaverEnabled = true
            return false
        }

        var rs_a = tx.executeSql("SELECT item_id FROM Articles WHERE item_id = ?", item_id);
        if (rs_a.rows.length === 0) {
            tx.executeSql("INSERT INTO Articles(item_id, resolved_url, title, host, article, datePublished) VALUES(?, ?, ?, ?, ?, ?)", [item_id, article_result.resolvedUrl, article_result.title, article_result.host, article_result.article, article_result.datePublished]);
        } else {
            tx.executeSql("UPDATE Articles SET resolved_url = ?, title = ?, host = ?, article = ?, datePublished = ? WHERE item_id = ?", [article_result.resolvedUrl, article_result.title, article_result.host, article_result.article, article_result.datePublished, item_id]);
        }

        if (finish) {
            syncing = false
            syncing_stopped = false
            screenSaver.screenSaverEnabled = true
        }
    })
}

// Clear downloaded files
function clear_list() {
    firstSync = true

    var db = LocalDB.init();
    db.transaction(function(tx) {
        var rsen = tx.executeSql("DELETE FROM Entries");
        var rse = tx.executeSql("DELETE FROM Articles");
        var rst = tx.executeSql("DELETE FROM Tags");

        reinit_pages()
    })
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

            //console.log(xhr.responseText)

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

// Extract only domain from url
function extractDomain(url) {
    var domain

    //find & remove protocol (http, ftp, etc.) and get domain
    if (typeof(url) === "undefined" || url === null) {
        return ''
    }
    if (url.indexOf("://") > -1) {
        domain = url.split('/')[2]
    } else {
        domain = url.split('/')[0]
    }

    //find & remove port number
    domain = domain.split(':')[0]

    return domain
}

function objectLength(obj) {
    var result = 0

    for(var prop in obj) {
        if (obj.hasOwnProperty(prop)) {
          result++
        }
    }

    return result
}
