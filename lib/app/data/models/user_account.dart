import 'package:equatable/equatable.dart';
import 'package:nitrobills/app/ui/pages/home/models/api_secrets.dart';
import 'package:nitrobills/app/ui/pages/home/models/bank_info.dart';

class UserAccount extends Equatable {
  static const String _idKey = "id";
  static const String _emailKey = "email";
  static const String _pinKey = "pin_code";
  static const String _referralCountKey = "referral_count";
  static const String _firstNameKey = "first_name";
  static const String _dateJoinedKey = "date_joined";
  static const String _lastLoginKey = "last_login";
  static const String _lastNameKey = "last_name";
  static const String _usernameKey = "username";
  static const String _emailVerifiedKey = "email_verified";
  static const String _phoneVerifiedKey = "phone_verified";
  static const String _phoneNumberKey = "phone_number";
  static const String _referralCodeKey = "referral_code";
  static const String _secretsKey = "secrets";
  static const String _bankKey = "banks";

  final int id;
  final String email;
  final String pin;
  final int referralCount;
  final String firstName;
  final DateTime dateJoined;
  final DateTime lastLogin;
  final String lastName;
  final String username;
  final bool emailVerified;
  final bool phoneVerified;
  final String phoneNumber;
  final String referralCode;
  final ApiSecrets secrets;
  final List<BankInfo> banks;

  const UserAccount({
    required this.id,
    required this.email,
    required this.pin,
    required this.referralCount,
    required this.firstName,
    required this.dateJoined,
    required this.lastLogin,
    required this.lastName,
    required this.username,
    required this.emailVerified,
    required this.phoneVerified,
    required this.phoneNumber,
    required this.referralCode,
    required this.secrets,
    required this.banks,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      id: json[_idKey],
      email: json[_emailKey],
      pin: json[_pinKey],
      referralCount: json[_referralCountKey],
      firstName: json[_firstNameKey],
      dateJoined: DateTime.parse(json[_dateJoinedKey]),
      lastLogin: DateTime.tryParse(json[_lastLoginKey] ?? "") ?? DateTime.now(),
      lastName: json[_lastNameKey],
      username: json[_usernameKey],
      emailVerified: json[_emailVerifiedKey],
      phoneVerified: json[_phoneVerifiedKey],
      phoneNumber: json[_phoneNumberKey],
      referralCode: json[_referralCodeKey],
      secrets: ApiSecrets.fromJson(json[_secretsKey]),
      banks: List<Map<String, dynamic>>.from(json[_bankKey])
          .map((e) => BankInfo.fromJson(e))
          .toList(),
    );
  }

  UserAccount copy({
    int? id,
    String? email,
    String? pin,
    int? referralCount,
    String? firstName,
    DateTime? dateJoined,
    DateTime? lastLogin,
    String? lastName,
    String? username,
    bool? emailVerified,
    bool? phoneVerified,
    String? phoneNumber,
    String? referralCode,
    ApiSecrets? secrets,
    List<BankInfo>? banks,
  }) =>
      UserAccount(
        id: id ?? this.id,
        email: email ?? this.email,
        pin: pin ?? this.pin,
        referralCount: referralCount ?? this.referralCount,
        firstName: firstName ?? this.firstName,
        dateJoined: dateJoined ?? this.dateJoined,
        lastLogin: lastLogin ?? this.lastLogin,
        lastName: lastName ?? this.lastName,
        username: username ?? this.username,
        emailVerified: emailVerified ?? this.emailVerified,
        phoneVerified: phoneVerified ?? this.phoneVerified,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        referralCode: referralCode ?? this.referralCode,
        secrets: secrets ?? this.secrets,
        banks: banks ?? this.banks,
      );

  @override
  List<Object?> get props => [
        id,
        email,
        referralCount,
        firstName,
        dateJoined,
        lastLogin,
        lastName,
        username,
        emailVerified,
        phoneVerified,
        phoneNumber,
        referralCode,
        secrets,
        banks
      ];
}
