// This function is used to write a key into the database
function setKey(key, value) {
    var db = LocalDB.init();
    db.transaction(function(tx) {
        var rs = tx.executeSql('INSERT OR REPLACE INTO user VALUES (?,?);', [key,""+value]);
        if (rs.rowsAffected == 0) {
            throw "Error updating key";
        } else {
            //console.log("User record updated:"+key+" = "+value);
        }
    });
}

// This function is used to retrieve a key from the database
function getKey(key) {
    var db = LocalDB.init();
    var returnValue = undefined;

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT value FROM user WHERE key=?;', [key]);
        if (rs.rows.length > 0)
          returnValue = rs.rows.item(0).value;
    })

    return returnValue;
}

// This function is used to delete a key from the database
function deleteKey(key) {
    var db = LocalDB.init();
    db.transaction(function(tx) {
        var rs = tx.executeSql('DELETE FROM user WHERE key=?;', [key]);
    })
}
