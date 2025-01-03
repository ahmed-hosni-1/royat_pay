import 'package:flutter/material.dart' hide Card;
import 'package:royat_pay/models/order_model.dart';
import 'package:royat_pay/models/pay_data.dart';
import 'package:royat_pay/models/payer_model.dart';
import 'package:royat_pay/models/payer_option_model.dart';
import 'package:royat_pay/royat_pay.dart';
import 'package:royat_pay/widgets/apple_pay_buttom.dart';
import 'package:royat_pay/widgets/royat_pay_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  RoyatPay.instance.init(
      key: "",
      password: "");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RoyatApplePayButton(
              merchantId: "merchantId",
              order: RoyatOrder(id: "1", amount: 100, description: "description",currency: "SAR"),
              payer: RoyatPayer(
                firstName: "firstName",
                ip: "ip",
                zip: "123",
                options: RoyatPayerOption(
                  address2: "address2",
                  birthdate: DateTime.now(),
                  middleName: "middleName",
                  state: "state",
                ),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RoyatPayWidget(
                  useFloatingAnimation: false,
                  useGlassMorphism: false,
                  useBackgroundImage: true,
                  onSuccess: () {},
                  payData: PayData(
                      order: Order(
                          id: "234234",
                          amount: 100,
                          description: "description", currency: ''),
                      customer: Customer(
                          name: "na me",
                          email: "ahmed@gmail.com",
                          phone: "1234536453",
                          address: "address",
                          city: "city",
                          country: "egypt",
                          lastName: "lastName",
                          zip: "12345")),
                ),
              ),
            ),
            // ElevatedButton(onPressed: () {}, child: const Text("Pay"))
          ],
        ),
      ),
    );
  }
}
