import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "pages"

/*
Database in:                /home/slimittn/.local/share/Foodiary/Foodiary/QML/OfflineStorage/Databases/database.sqlite
Icons to use in projet in:  /usr/share/themes/jolla-ambient/meegotouch/icons/
*/

ApplicationWindow
{
    QtObject
    {
        id: foodiary

        property string currentUser: ""
        property string currentEntry: ""
        property string currentLocation: ""
        property string currentMeal: ""
        property string newestEntry: ""
        property var db: null
        property var table: null
        property ListModel users: ListModel {id: users}
        property ListModel entries: ListModel {id: entries}
        property ListModel locations: ListModel {id: locations}
        property ListModel meals: ListModel {id: meals}
        signal sendReport(string file, string msg)

        function change() {
            openDB();

            try{
                db.transaction(function(tx){
                    tx.executeSql(
                                'CREATE TABLE Temp AS SELECT * FROM Diary'
                                );
                    });

                db.transaction(function(tx){
                    tx.executeSql(
                                'DROP TABLE Diary'
                                );
                    });

                db.transaction(function(tx){
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Diary(
                                      id INTEGER PRIMARY KEY,
                                      user INTEGER,
                                      date DATETIME,
                                      time DATETIME,
                                      picture TEXT,
                                      bloodsugar REAL,
                                      description TEXT,
                                      location TEXT,
                                      other TEXT,
                                      meal TEXT
                                   )');

                });
                db.transaction(function(tx){
                    tx.executeSql(
                                'INSERT INTO Diary SELECT * FROM Temp'
                                );
                    });

                db.transaction(function(tx){
                    tx.executeSql(
                                'DROP TABLE Temp'
                                );
                    });
                console.log("Sql: OK");
            }catch(err){
                console.log("Sql: " + err);
            }
        }

        function openDB() {
            if(db !== null) return;

            db = LocalStorage.openDatabaseSync("Foodiary", "0.1", "Food Diary", 100000);

            try {
                db.transaction(function(tx){
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Users(
                                      id INTEGER PRIMARY KEY,
                                      name TEXT,
                                      age INTEGER,
                                      gender TEXT,
                                      weight REAL,
                                      length REAL,
                                      type TEXT
                                   )');

                    tx.executeSql('CREATE TABLE IF NOT EXISTS Diary(
                                      id INTEGER PRIMARY KEY,
                                      user INTEGER,
                                      date DATETIME,
                                      time DATETIME,
                                      picture TEXT,
                                      bloodsugar REAL,
                                      description TEXT,
                                      location TEXT,
                                      other TEXT,
                                      meal TEXT
                                   )');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Locations(
                                      id INTEGER PRIMARY KEY,
                                      name TEXT,
                                      description TEXT,
                                      coordinates TEXT
                                   )');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS Meals(
                                      id INTEGER PRIMARY KEY,
                                      name TEXT,
                                      description TEXT
                                   )');
                });
            } catch (err) {
                console.log("Sql error: " + err);
            };
        }

        function getUsers() {
            openDB();
            users.clear()

            try{
                db.transaction(function(tx) {
                    var rs = tx.executeSql('SELECT * FROM Users;');

                    if(rs.rows.length == 0){
                        console.log("Sql: No users in DB");
                    }

                    for(var i=0; i < rs.rows.length; i++) {
                        users.append({"id": rs.rows.item(i).id, "name":rs.rows.item(i).name, "age":rs.rows.item(i).age, "gender":rs.rows.item(i).gender, "weight":rs.rows.item(i).weight, "length":rs.rows.item(i).length, "type":rs.rows.item(i).type})
                    }
                    if(rs.rows.length > 0){
                        console.log("Last user: " + ReportWriter.lastUser())
                        if(ReportWriter.lastUser() == "") {
                            currentUser = rs.rows.item(0).id
                        }
                        else
                            currentUser = ReportWriter.lastUser()
                    }

                    console.log("Sql: Current user: " + currentUser + ". " + rs.rows.item(currentUser - 1).name);
                }
                );
            }catch(err){
                console.log("Sql: " + err);
            }
        }

        function getLocations() {
            openDB();
            locations.clear()

            try {
                db.transaction(function(tx) {
                    var rs = tx.executeSql('SELECT * FROM Locations;');

                    console.log("Sql: " + rs.rows.length + " locations found on in Locations");

                    for(var i=0; i < rs.rows.length; i++) {
                        locations.append({"id": rs.rows.item(i).id, "name":rs.rows.item(i).name, "description":rs.rows.item(i).description, "coordinates":rs.rows.item(i).coordinates})
                    }
                    if(rs.rows.length > 0){
                        currentLocation = rs.rows.item(0).id
                    }
                    console.log("Sql: Current location: " + rs.rows.item(0).name);
                }
                );
            }catch(err){
                console.log("Sql: " + err);
            }
        }

        function getMeals() {
            openDB();
            meals.clear()
            meals.append({"id": 0, "name": "", "description": ""})
            currentMeal = 0
            try{
                db.transaction(function(tx) {
                    var rs = tx.executeSql('SELECT * FROM Meals;');

                    console.log("Sql: " + rs.rows.length + " meals found on in Meals");

                    for(var i=0; i < rs.rows.length; i++) {
                        meals.append({"id": rs.rows.item(i).id, "name":rs.rows.item(i).name, "description":rs.rows.item(i).description})
                    }
//                    if(rs.rows.length > 0){
//                        currentMeal = rs.rows.item(0).id
//                    }
                    console.log("Sql: Current meal: " + currentMeal);
                }
                );
            }catch(err){
                console.log("Sql: " + err);
            }
        }

        function deleteEntry(id) {
            openDB();

            try{
                db.transaction(function(tx) {
                    var rs = tx.executeSql('DELETE FROM Diary WHERE id =?;', [id]);
                    console.log("Sql: Deleted id=" + id + " from Diary");
                }
                );
            }
            catch(err)
            {
                console.log("Sql: Error when trying to delete id: " + id + " " + err);
            }
        }

        function getEntries(user) {
            openDB();
            entries.clear()
            try{
                db.transaction(function(tx) {
                    var rs = tx.executeSql('SELECT * FROM Diary WHERE user = ? ORDER BY date DESC, time DESC;', [user]);
                    console.log("Sql: " + rs.rows.length + " entries found on " + user + " ");

                    for(var i=0; i < rs.rows.length; i++) {
                        var ind = rs.rows.item(i).id || ""
                        var u = rs.rows.item(i).user || ""
                        var d = rs.rows.item(i).date || ""
                        var t = rs.rows.item(i).time || ""
                        var b = rs.rows.item(i).bloodsugar || 0.0
                        var p = rs.rows.item(i).picture || ""
                        var desc = rs.rows.item(i).description || ""
                        var l = rs.rows.item(i).location || ""
                        var o = rs.rows.item(i).other || ""
                        var m = rs.rows.item(i).meal || ""

                        entries.append({"id": ind, "user": u, "date": d, "time": t, "bs": b, "picture": p, "description": desc, "location": l, "other": o, "meal": m})
                    }
                    if(rs.rows.length > 0){
                        newestEntry = rs.rows.item(0).id
                    }
                    console.log("Sql: Newest entry: " + rs.rows.item(0).id);
                }
                );
            }
            catch(err)
            {
                console.log("Sql: " + err);
            }
        }

        function exportDiary(fileName, user, type, startDate, endDate) {
            ReportWriter.init()
            console.log("Creating report " + fileName + " of type " + type)
            var select = "SELECT * FROM Diary "
            var where = "WHERE user = '" + user + "' "
            var order = "ORDER BY date ASC, time ASC "

            console.log("Fromdate: " + startDate + ", Todate: " + endDate)
            if(startDate != "" && endDate == ""){
                where += "AND date = '" + startDate + "' "
            }
            else if(startDate == endDate && startDate != ""){
             where += "AND date = '" + startDate + "' "
            }
            else if(startDate != "" && endDate != "")
                where += "AND date >= '" + startDate + "' AND date <= '" + endDate + "' "
            //ReportWriter.addEntry()
            var sql = select + where + order
            console.log("Executing select: " + sql)
            //var header = "Name: " + users.get(currentUser - 1).name + "\r\nWeight: " + users.get(currentUser - 1).weight + "\r\nLength: " + users.get(currentUser - 1).length + "\r\nAge: " + users.get(currentUser - 1).age + "\r\n"
            //FileIO.appendToReport(fileName, header + "\r\n")

//            if(type == "VCS")
//                FileIO.appendToReport(fileName, "Location, Date, Time, BS(mmol/l), Description, Other\r\n")
//            else
//                FileIO.appendToReport(fileName, "ID,User,Date,Time,BS(mmol/l),Picture URL,Location,Other,Meal ID\r\n")
            var splitDesc = ""
            openDB();
            var oldDate = ""
            try{
                db.transaction(function(tx) {
                    var rs = tx.executeSql(sql);
                    console.log("Sql: Exporting " + rs.rows.length + " entries for " + user + " ");

                    for(var i=0; i < rs.rows.length; i++)
                    {
                        //power of javascript O_o
                        var ind = rs.rows.item(i).id || ""
                        var u = rs.rows.item(i).user || ""
                        var d = rs.rows.item(i).date || ""
                        var t = rs.rows.item(i).time || ""
                        var b = rs.rows.item(i).bloodsugar || 0.0
                        var p = rs.rows.item(i).picture || ""
                        var desc = rs.rows.item(i).description || ""
                        var l = rs.rows.item(i).location || ""
                        var o = rs.rows.item(i).other || ""
                        var m = rs.rows.item(i).meal || ""

                        try
                        {
                            if(d != oldDate) {
                                ReportWriter.addHeader(users.get(u - 1).name, d)
                                oldDate = d
                            }

                            if(desc !== "")
                            {
                                var res = desc.split("\n");
                                console.log("Found " + res.length + " rows in description " + desc)

                                for(var j = 0; j < res.length; j++)
                                {
                                    console.log("Index j " + j)
                                    if(type == "VCS")
                                    {
                                        if(j == 0)
                                            ReportWriter.addEntry(locations.get(l - 1).name, t, b, res[j], o)
                                        else
                                            ReportWriter.addEntry("", "", "", res[j], "")
                                    }
                                    else
                                    {
//                                        if(j == 0)
//                                            FileIO.appendToReport(fileName, ind + "," + u  + "," + d  + "," + t  + "," + b  + "," + p  + "," + res[j]  + "," + fileName, locations.get(l - 1).name  + "," + o + "," + m + "\r\n")
//                                        else
//                                            FileIO.appendToReport(fileName, ",,,,,," + res[j]  + ",,,\r\n")
                                    }
                                }
                            }
                            else
                            {
                                console.log("Description " + desc)
                                if(type == "VCS")
                                    ReportWriter.addEntry(locations.get(l - 1).name, t, b, desc, o)
//                                else
//                                    FileIO.appendToReport(fileName, ind + "," + u  + "," + d  + "," + t  + "," + b  + "," + p  + "," + desc  + "," + fileName, locations.get(l).name  + "," + o + "," + m + "\r\n")
                            }
                        }
                        catch(er){
                            console.log("Split: " + er);
                        }
                    }
                    ReportWriter.write(fileName, type)
                }
                );
            }
            catch(err)
            {
                console.log("Sql: " + err);
            }
        }

        function saveDiary(user, date, time, image, bs, description, location, other, meal) {
            openDB()
            try
            {
                db.transaction(function(tx) {
                    tx.executeSql("INSERT INTO Diary VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [null, user, date, time, image, bs, description, location, other, meal]);
                }
                );
                console.log("Sql : Diary insterted with values user: '"+ user + "', date: '" + date + "', time: '" + time + "', picture: '" + image + "', bs: " + bs + ", description: '" + description + "', location: '" + location + "', other: '" + other + "', meal: '" + meal + "'");
            }
            catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function updateDiary(id, user, date, time, picture, bloodsugar, description, location, other, meal) {
            openDB()
            try
            {
                db.transaction(function(tx) {
                    tx.executeSql("UPDATE Diary SET user = '" + user
                                  + "', date = '" + date
                                  + "', time = '" + time
                                  + "', picture = '" + picture
                                  + "', bloodsugar = " + bloodsugar
                                  + ", description = '" + description
                                  + "', location = '" + location
                                  + "', other = '" + other
                                  + "', meal = '" + meal
                                  + "' WHERE id = " + id);
                }
                );
                console.log("Sql: Updated Diary page: " + id + " with values user: '"+ user + "', date: '" + date + "', time: '" + time + "', picture: '" + picture + "', bs: " + bloodsugar + ", description: '" + description + "', location: '" + location + "', other: '" + other + "', meal: '" + meal + "'");
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function saveUser(name, age, gender, weight, lenght, type) {
            openDB()
            try
            {
                db.transaction(function(tx) {
                    tx.executeSql("INSERT INTO Users VALUES(?, ?, ?, ?, ?, ?, ?)", [null, name, age, gender, weight, lenght, type]);
                    console.log("Sql : Users insterted with values name: '"+ name + "', age: '" + age + "', gender: '" + gender + "', weight: '" + weight + "', length: " + lenght + ", type: '" + type);
                }
                );
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function saveLocation(name, description, coordinates) {
            openDB()
            try
            {
                db.transaction(function(tx) {
                    tx.executeSql("INSERT INTO Locations VALUES(?, ?, ?, ?)", [null, name, description, coordinates]);
                    console.log("Sql : Locations insterted with values name: '"+ name + "', description: '" + description + "', coordinates: '" + coordinates);
                }
                );
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function saveMeal(name, description) {
            openDB()
            try
            {
                db.transaction(function(tx) {
                    tx.executeSql("INSERT INTO Meals VALUES(?, ?, ?)", [null, name, description]);
                    console.log("Sql : Meals insterted with values name: '"+ name + "', description: '" + description);
                }
                );
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function updateUser(id, name, age, gender, weight, lenght, type) {
            openDB()
            try
            {
                db.transaction(function(tx) {
                    tx.executeSql("UPDATE Users SET name = '" + name
                                  + "', age = " + age
                                  + ", gender = '" + gender
                                  + "', weight = " + weight
                                  + ", length = " + lenght
                                  + ", type = '" + type
                                  + "' WHERE id = " + id);
                }
                );
                console.log("Sql: Updated " + name);
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function updateLocation(id, name, description, coordinates) {
            openDB()
            try
            {
                db.transaction(function(tx) {
                    tx.executeSql("UPDATE Locations SET name = '" + name
                                  + "', description = '" + description
                                  + "', coordinates = '" + coordinates
                                  + "' WHERE id = " + id);
                }
                );
                console.log("Sql: Updated " + name);
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function updateMeal(id, name, description) {
            openDB()
            try
            {
                db.transaction(function(tx) {
                    tx.executeSql("UPDATE Meals SET name = '" + name
                                  + "', description = '" + description
                                  + "' WHERE id = " + id);
                }
                );
                console.log("Sql: Updated " + name);
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function clearDB(){
            openDB()
            try{
            db.transaction(function(tx) {
                tx.executeSql('DELETE FROM Diary');
                tx.executeSql('DELETE FROM Users');
                tx.executeSql('DELETE FROM Locations');
            });
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function clearEntries(user){
            openDB()
            try{
            db.transaction(function(tx) {
                tx.executeSql("DELETE FROM Diary WHERE user = '" + user + "' ");
                console.log("Entries cleared for " + user);
            });
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function clearLocations(){
            openDB()
            try{
            db.transaction(function(tx) {
                tx.executeSql('DELETE FROM Locations');
                console.log("Locations cleared");
            });
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function runCmd(cmd){
            openDB()
            try{
            db.transaction(function(tx) {
                tx.executeSql(cmd);
                console.log("Command: " + cmd + " run successfully");
            });
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function deleteLocation(id){
            openDB()
            try{
            db.transaction(function(tx) {
                tx.executeSql("DELETE FROM Locations WHERE id = " + id);
                console.log("Location " + id + " deleted");
            });
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function deleteMeal(id){
            openDB()
            try{
            db.transaction(function(tx) {
                tx.executeSql("DELETE FROM Meals WHERE id = " + id);
                console.log("Meal " + id + " deleted");
            });
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }

        function deleteUser(id){
            openDB()
            try{
            db.transaction(function(tx) {
                tx.executeSql("DELETE FROM Users WHERE id = " + id);
                console.log("User " + id + " deleted");
            });
            }catch(err)
            {
                console.log("Sql error: " + err);
            }
        }
    }

    initialPage: Component {
        DiaryPage { }
    }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
}


