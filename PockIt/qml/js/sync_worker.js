WorkerScript.onMessage = function(msg) {
    var api_entries = msg.api_entries
    var db_entries = msg.db_entries

    var entries_works = {}

    for(var api_i in api_entries) {
        var api_item_id = api_entries[api_i].item_id

        // Entry exists in DB
        if (db_entries.hasOwnProperty(api_item_id)) {
            // Entry hasn't updated
            if (db_entries[api_item_id].time_updated === api_entries[api_i].time_updated) {
                entries_works[api_item_id] = {'action': 'KEEP'}
            } else {
                entries_works[api_item_id] = {'action': 'UPDATE'}
            }
        } else {
            entries_works[api_item_id] = {'action': 'INSERT'}
        }
    }

    WorkerScript.sendMessage({'action': 'ENTRIES_WORKS', 'entries_works': entries_works, 'api_entries': api_entries})
}
