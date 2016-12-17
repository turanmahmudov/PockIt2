WorkerScript.onMessage = function(msg) {
    var entries_feed = msg.entries_feed
    var entries_model = msg.entries_model
    var db_entries = msg.db_entries
    var db_tags = msg.db_tags

    if (msg.clear_model) {
        entries_model.clear()
    }

    for(var db_i = 0; db_i < db_entries.length; db_i++) {
        var item_id = db_entries[db_i].item_id
        var given_title = db_entries[db_i].given_title;
        var resolved_title = db_entries[db_i].resolved_title ? db_entries[db_i].resolved_title : (db_entries[db_i].given_title ? db_entries[db_i].given_title : db_entries[db_i].resolved_url)
        var resolved_url = db_entries[db_i].resolved_url;
        var sort_id = db_entries[db_i].sortid;
        var only_domain = extractDomain(db_entries[db_i].resolved_url);
        var favorite = db_entries[db_i].favorite;
        var status = db_entries[db_i].status;
        var has_video = db_entries[db_i].has_video;
        var image_obj = JSON.parse(db_entries[db_i].image);
        var image = ''
        if (image_obj.hasOwnProperty('src')) {
            image = image_obj.src
        } else {
            if (objectLength(JSON.parse(db_entries[db_i].images)) > 0) {
                var images = JSON.parse(db_entries[db_i].images);
                image = images['1'] ? images['1']['src'] : '';
            } else {
                image = '';
            }
        }

        entries_model.append({"item_id":item_id, "given_title":given_title, "resolved_title":resolved_title, "resolved_url":resolved_url, "sort_id":sort_id, "only_domain":only_domain, "image":image, "favorite":favorite, "status":status, "has_video":has_video, "tags":db_tags[item_id]});
    }

    entries_model.sync()
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
