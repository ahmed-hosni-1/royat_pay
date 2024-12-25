## RoyatPay
#### RoyatPay is a library that allows Flutter applications to accept online card and apple payments through the Royat service.

## :rocket: Installation

Add this to `dependencies` in your app's `pubspec.yaml`

```yaml
royat_pay : latest_version
```


## ⭐: Initialization
### To initialize the RoyatPay instance, you can use the init method. Here's how you can initialize it:
In the main.dart file, make sure the RoyatPay library is configured correctly:

```dart
  void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ...
  RoyatPay.instance.init(
  key: "auth key",
  password: "auth password");
  ...
  runApp(const MyApp());
}
```

## :💡: Usage
### To use the RoyatPay instance after it has been initialized, you can make payment attempts using either a card or a apple pay. Here's how you can use it:


## 💳 Payment with Apple Pay
### To initiate a payment with a card using the RoyatPay instance, you can use the payWithApple method. Here's how you can use it:

```dart
// Initiates a payment with a Apple Pay using the RoyatPay instance
RoyatApplePayButton(
    merchantId: "merchantId",
    order: Order(id: "id", amount: 100, description: "description"),
    customer: Customer(
    name: "name",
    email: "email",
    phone: "phone",
    address: "address",
    city: "city",
    country: "country",
    lastName: "lastName",
    ),
    onError: (error) {},
    onTransactionFailure: (response) {},
    onTransactionSuccess: (response) {},
    onAuthentication: (response) {},
),


```


## 📲 Payment with Card
### To initiate a payment with a card using the RoyatPay instance, you can use the payWithCard method. Here's how you can use it:

```dart
// Initiates a payment with a Card using the RoyatPay widget
RoyatPayWidget(
    useFloatingAnimation: false,
    useGlassMorphism: false,
    useBackgroundImage: true,
    onSuccess: () {},
    payData: PayData(
    order: Order(
    id: "id",
    amount: 100,
    description: "description"),
    customer: Customer(
    name: "name name",
    email: "info@royat.sa",
    phone: "1234536453",
    address: "address",
    city: "city",
    country: "Saudi Arabia",
    lastName: "lastName",
    zip: "12345")),
),

```
👍
That's it, you've successfully finalized your Mobile Wallets Payments integration with Accept :tada:.
Now, prepare endpoints to receive payment notifications from Accept's server, to learn more about the transactions webhooks

###  Contact with   [Royat](https://www.royat.sa)