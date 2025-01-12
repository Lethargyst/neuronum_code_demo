import 'package:common/gen/translations.g.dart';

class Validators {
  static final _instance = Validators._();

  factory Validators() => _instance;

  Validators._();

  String? validateMobile(String? value) {
    final patttern = r'(^((\+7)[\-]?)?(\(?\d{3}\)?[\-]?)?[\d\-]{10}$)';
    final regExp = RegExp(patttern);
    if (value == null || value.isEmpty) {
      return t.validators.emptyValidation;
    } else if (!regExp.hasMatch(value)) {
      return t.validators.incorrectPhone;
    }
    return null;
  }

  String? validateEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return t.validators.emptyValidation;
    }
    return null;
  }

  String? validateEmail(String? value) {
    final isEmail = RegExp(r"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$").hasMatch(value!);
    if (!isEmail) return t.validators.incorrectEmail;

    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final isValid = RegExp(r"^([A-zА-ёЁ-я'\- \(\)\,\.]{1,})$").hasMatch(value.trim());
    if (!isValid) {
      return t.validators.validateName;
    }
    return null;
  }

  String? valdiateCardNumber(String? value) {
    if (value?.trim().length == 16) {
      return null;
    }
    return t.validators.incorrectCardNumber;
  }

  String? valdiateCvv(String? value) {
    if (value?.trim().length == 3) {
      return null;
    }
    return t.validators.incorrectCvv;
  }

  String? valdiateCardValidityPeriod(String? value) {
    if (value == null || value.length < 2) {
      return t.validators.incorrectCardValidityPeriod;
    }

    final month = int.tryParse(value.substring(0, 2));
    if (month == null || value.length == 5 && month <= 12 && month > 0) {
      return null;
    }

    return t.validators.incorrectCardValidityPeriod;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().length < 6) {
      return t.validators.minPasswordLength;
    }

    final isValid = RegExp(r"^[a-zA-Z0-9~!@#%^&*_\-+=\'|\(){}[\]:;<>,.?/\\\\s]+$")
      .hasMatch(value.trim());
    if (!isValid) {
      return t.validators.correctPasswordSymblos;
    }

    return null;
  }
}