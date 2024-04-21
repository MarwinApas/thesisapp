import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thesis_app/JsonModels/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
class DatabaseHelper {
    final databaseName = "usersDB.db";

    String user = '''
    CREATE TABLE users(
        userId INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        userName TEXT UNIQUE,
        userPassword TEXT,
        userVerificationQuestion TEXT,
        userVerificationAnswer TEXT
    )
    ''';

    //open database
    Future<Database> initDB() async {
        final databasePath = await getDatabasesPath();
        final path = join(databasePath, databaseName);

        return openDatabase(path, version: 1, onCreate: (db, version) async {
            await db.execute(user);
        });
    }

    // Check if the username already exists in the database
    Future<bool> checkUsernameExists(String userName) async {
        final Database db = await initDB();
        var result = await db.query("users", where: 'userName = ?', whereArgs: [userName]);
        return result.isNotEmpty;
    }

    // Authentication function
    Future<bool> authenticate(Users user) async {
        final Database db = await initDB();
        var result = await db.query("users", where: 'userName = ? AND userPassword = ?', whereArgs: [user.userName, user.userPassword]);
        return result.isNotEmpty;
    }

    // Register function
    Future<int> createUser(Users user) async {
        final Database db = await initDB();
        return db.insert("users", user.toMap());
    }

    // Get current user details
    Future<Users?> getUser(String userName) async {
        final Database db = await initDB();
        var res = await db.query("users", where: "userName = ?", whereArgs: [userName]);
        return res.isNotEmpty ? Users.fromMap(res.first) : null;
    }

    Future<String?> getLoggedInUsername() async {
        final Database db = await initDB();
        // Assuming you have a way to store the logged-in username, such as in shared preferences or a global variable
        String? loggedInUsername = await DatabaseHelper().getLoggedInUsername();
        var res = await db.query(
            "users",
            columns: ['userName'],
            where: "userName = ?",
            whereArgs: [loggedInUsername],
        );
        return res.isNotEmpty ? res.first['userName'] as String : null;
    }

    Future<String?> getVerificationQuestion(String userName) async {
        final Database db = await initDB();
        var res = await db.query("users", columns: ['userVerificationQuestion'], where: 'userName = ?', whereArgs: [userName]);
        if (res.isNotEmpty) {
            return res.first['userVerificationQuestion'] as String?;
        } else {
            return null;
        }
    }

    Future<bool> verifyAnswer(String userName, String answer) async {
        final Database db = await initDB();
        var res = await db.query("users", where: 'userName = ? AND userVerificationAnswer = ?', whereArgs: [userName, answer]);
        return res.isNotEmpty;
    }

    Future<bool> verifyUserDetails(String username, String question, String answer) async {
        final Database db = await initDB();
        var res = await db.query("users", where: 'userName = ? AND userVerificationQuestion = ? AND userVerificationAnswer = ?', whereArgs: [username, question, answer]);
        return res.isNotEmpty;
    }

    Future<bool> updateUserPassword(String userName, String newUserPassword) async {
        final Database db = await initDB();
        var res = await db.update(
            "users",
            {'userPassword': newUserPassword},
            where: 'userName = ?',
            whereArgs: [userName],
        );
        return res > 0; // Returns true if at least one row was affected
    }

    Future<bool> updateUsername(String oldUsername, String newUsername) async {
        final Database db = await initDB();
        var res = await db.update(
            "users",
            {'userName': newUsername},
            where: 'userName = ?',
            whereArgs: [oldUsername],
        );
        return res > 0; // Returns true if at least one row was affected
    }

    // Get the userPassword of the current logged-in user from SharedPreferences
    Future<String?> getLoggedInUserPassword() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? loggedInUsername = prefs.getString('userName');

        if (loggedInUsername != null) {
            final Database db = await initDB();
            var res = await db.query("users",
                columns: ['userPassword'],
                where: "userName = ?",
                whereArgs: [loggedInUsername]);

            if (res.isNotEmpty) {
                return res.first['userPassword'] as String?;
            }
        }

        return null; // Return null if user not found or userPassword not available
    }

    //gets the firstname and lastname based from the username
    Future<Map<String, String>?> fetchUserName(String userName) async {
        final Database db = await initDB();
        var res = await db.query(
            "users",
            columns: ['firstName', 'lastName'],
            where: "userName = ?",
            whereArgs: [userName],
        );
        if (res.isNotEmpty) {
            return {
                'firstName': res.first['firstName'] as String,
                'lastName': res.first['lastName'] as String,
            };
        } else {
            return null;
        }
    }


    Future<bool> updateName(String firstName, String lastName, String userName) async {
        final Database db = await initDB();
        var res = await db.update(
            "users",
            {
                'firstName': firstName,
                'lastName': lastName,
            },
            where: 'userName = ?',
            whereArgs: [userName],
        );
        return res > 0; // Returns true if at least one row was affected
    }
}

