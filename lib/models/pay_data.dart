class PayData {
  PayData({
    required this.order,
    required this.customer,
     this.card,
     this.user,
  });

  final Order? order;
  final Customer? customer;
  Card? card;
  User? user;

  PayData copyWith({
    Order? order,
    Customer? customer,
    Card? card,
    User? user,
  }) {
    return PayData(
      order: order ?? this.order,
      customer: customer ?? this.customer,
      card: card ?? this.card,
      user: user ?? this.user,
    );
  }

  factory PayData.fromJson(Map<String, dynamic> json) {
    return PayData(
      order: json["order"] == null ? null : Order.fromJson(json["order"]),
      customer:
          json["customer"] == null ? null : Customer.fromJson(json["customer"]),
      card: json["card"] == null ? null : Card.fromJson(json["card"]),
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "order": order?.toJson(),
        "customer": customer?.toJson(),
        "card": card?.toJson(),
        "user": user?.toJson(),
      };
}

class Card {
  Card({
    required this.number,
    required this.exMonth,
    required this.exYear,
    required this.cvv,
  });

  String number;
  String exMonth;
  String exYear;
  String cvv;

  Card copyWith({
    String? number,
    String? exMonth,
    String? exYear,
    String? cvv,
  }) {
    return Card(
      number: number ?? this.number,
      exMonth: exMonth ?? this.exMonth,
      exYear: exYear ?? this.exYear,
      cvv: cvv ?? this.cvv,
    );
  }

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      number: json["number"] ?? "",
      exMonth: json["ex_month"] ?? "",
      exYear: json["ex_year"] ?? "",
      cvv: json["cvv"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "number": number,
        "ex_month": exMonth,
        "ex_year": exYear,
        "cvv": cvv,
      };
}

class Customer {
  Customer({
     this.name,
     this.lastName,
    required this.email,
    required this.phone,
    required this.city,
    required this.country,
    required this.address,
    this.zip = "12345",
    this.ip,
    // required this.redirect,
  });

  late  String? name;
  final String? lastName;
  final String email;
  final String phone;
  final String city;
  final String country;
  final String address;
  String? zip;
  String? ip;
  // final String redirect;

  Customer copyWith({
    String? name,
    String? email,
    String? phone,
    String? city,
    String? address,
    String? zip,
    String? ip,
    String? redirect,
  }) {
    return Customer(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      address: address ?? this.address,
      zip: zip ?? this.zip,
      ip: ip ?? this.ip,
      country: country ?? this.country, lastName: '',
      // redirect: redirect ?? this.redirect,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      city: json["city"] ?? "",
      address: json["address"] ?? "",
      zip: json["zip"] ?? "",
      ip: json["ip"] ?? "", lastName: '', country: '',
      // redirect: json["redirect"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "city": city,
        "address": address,
        "zip": zip,
        "ip": ip,
        "redirect": "https://royat.sa",
      };
}

class Order {
  Order({
    required this.id,
    required this.amount,
	      required this.currency,

    required this.description,
  });

  final String id;
  final num amount;
	final String                                     currency;
  final String description;

  Order copyWith({
    String? id,
    num? amount,
    String? description,
	  String? currency,
  }) {
    return Order(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
	    currency: currency ?? this.currency,
    );
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json["id"] ?? "",
      amount: json["amount"] ?? 0,
	   currency: json["currency"] ?? "SAR", 
      description: json["description"] ?? "",
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount.toStringAsFixed(2),
        "description": description,
	  "currency" : currency
      };
}

class User {
  User({
    this.key,
    this.password,
  });

  User.fromJson(dynamic json) {
    key = json['key'];
    password = json['password'];
  }
  String? key;
  String? password;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['password'] = password;
    return map;
  }
}

/*
{
	"order": {
		"id": "Test-1",
		"amount": 1.03,
		"description": "test prod"
	},
	"customer": {
		"name": "Ahmed Saied",
		"email": "notsaied@pm.me",
		"phone": "96650056568",
		"city": "Alqusier",
		"address": "Alqusier",
		"zip": "84745",
		"ip": "156.204.81.116",
		"redirect": "https://google.com/"
	},
	"card": {
		"number": "411111111111111111",
		"ex_month": "00",
		"ex_year": "00",
		"cvv": "000"
	}
}*/
