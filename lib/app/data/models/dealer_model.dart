class DealerModel {
  const DealerModel({
    required this.userId,
    required this.name,
    required this.firmName,
    required this.dealerCode,
    required this.mobile,
    required this.email,
    required this.creditLimit,
    required this.outstandingBalance,
    this.city = '',
    this.state = '',
  });

  final int userId;

  final String name;
  final String firmName;
  final String dealerCode;

  final String mobile;
  final String email;

  final double creditLimit;
  final double outstandingBalance;

  final String city;
  final String state;

  factory DealerModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawUser =
        json['user'];

    final user = rawUser is Map
        ? Map<String, dynamic>.from(
            rawUser,
          )
        : <String, dynamic>{};

    final rawAddresses =
        user['addresses'];

    Map<String, dynamic> address =
        <String, dynamic>{};

    if (rawAddresses is List &&
        rawAddresses.isNotEmpty) {
      for (final item
          in rawAddresses) {
        if (item is! Map) {
          continue;
        }

        final candidate =
            Map<String, dynamic>.from(
          item,
        );

        if (address.isEmpty) {
          address = candidate;
        }

        if (_asBool(
          candidate['is_default'],
        )) {
          address = candidate;
          break;
        }
      }
    }

    return DealerModel(
      userId: _asInt(
        json['user_id'] ??
            user['id'],
      ),
      name:
          user['name']
                  ?.toString() ??
              '',
      firmName:
          json['firm_name']
                  ?.toString() ??
              '',
      dealerCode:
          json['dealer_code']
                  ?.toString() ??
              '',
      mobile:
          user['mobile']
                  ?.toString() ??
              '',
      email:
          user['email']
                  ?.toString() ??
              '',
      creditLimit:
          _asDouble(
        json['credit_limit'],
      ),
      outstandingBalance:
          _asDouble(
        json[
            'outstanding_balance'],
      ),
      city:
          address['city']
                  ?.toString() ??
              '',
      state:
          address['state']
                  ?.toString() ??
              '',
    );
  }

  String get displayName {
    if (firmName.trim().isNotEmpty) {
      return firmName;
    }

    return name;
  }

  String get location {
    final values = [
      city.trim(),
      state.trim(),
    ].where(
      (item) => item.isNotEmpty,
    );

    return values.join(', ');
  }

  static int _asInt(
    dynamic value,
  ) {
    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static double _asDouble(
    dynamic value,
  ) {
    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static bool _asBool(
    dynamic value,
  ) {
    final text =
        value?.toString().toLowerCase() ??
            '';

    return text == '1' ||
        text == 'true' ||
        text == 'yes';
  }
}