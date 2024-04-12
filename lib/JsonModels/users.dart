import 'dart:convert';

Users usersFromMap(String str) => Users.fromMap(json.decode(str));

String UsersToMap(Users data) => json.encode(data.toMap());

class Users {
    final int? userId;
    final String? firstName;
    final String? lastName;
    final String userName;
    final String userPassword;
    final String? userVerificationQuestion;
    final String? userVerificationAnswer;

    Users({
        this.userId,
        this.firstName,
        this.lastName,
        required this.userName,
        required this.userPassword,
        this.userVerificationQuestion,
        this.userVerificationAnswer
    });

    factory Users.fromMap(Map<String, dynamic> json) => Users(
        userId: json["userId"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        userName: json["userName"],
        userPassword: json["userPassword"],
        userVerificationQuestion: json["userVerificationQuestion"],
        userVerificationAnswer: json["userVerificationAnswer"],
    );

    Map<String, dynamic> toMap() => {
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
        "userName": userName,
        "userPassword": userPassword,
        "userVerificationQuestion": userVerificationQuestion,
        "userVerificationAnswer": userVerificationAnswer,
    };
}
