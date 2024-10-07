import 'package:flutter/material.dart' hide Card;
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:royat_pay/models/pay_data.dart';
import 'package:royat_pay/royat_pay.dart';

import 'app_colors.dart';

class RoyatPayWidget extends StatefulWidget {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  PayData payData;
  Function onSuccess;
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;

  RoyatPayWidget(
      {required this.payData,
      required this.onSuccess,
      this.isCvvFocused = false,
      this.useGlassMorphism = false,
      this.useBackgroundImage = false,
      this.useFloatingAnimation = true,
      super.key});

  @override
  State<RoyatPayWidget> createState() => _RoyatPayWidgetState();
}

class _RoyatPayWidgetState extends State<RoyatPayWidget> {
  @override
  void initState() {
    super.initState();
  }

  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                onPressed: () => setState(() {
                  widget.isLightTheme = !widget.isLightTheme;
                }),
                icon: Icon(
                  widget.isLightTheme ? Icons.light_mode : Icons.dark_mode,
                ),
              ),
              CreditCardWidget(
                enableFloatingCard: widget.useFloatingAnimation,
                glassmorphismConfig: _getGlassmorphismConfig(),
                cardNumber: widget.cardNumber,
                expiryDate: widget.expiryDate,
                cardHolderName: widget.cardHolderName,
                cvvCode: widget.cvvCode,
                bankName: 'RoyatPay',
                frontCardBorder: widget.useGlassMorphism
                    ? null
                    : Border.all(color: Colors.grey),
                backCardBorder: widget.useGlassMorphism
                    ? null
                    : Border.all(color: Colors.grey),
                showBackView: widget.isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                cardBgColor: widget.isLightTheme
                    ? AppColors.cardBgLightColor
                    : AppColors.cardBgColor,
                backgroundImage:
                    widget.useBackgroundImage ? 'assets/card_bg.png' : null,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                customCardTypeIcons: <CustomCardTypeIcon>[],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: false,
                        cardNumber: widget.cardNumber,
                        cvvCode: widget.cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName: widget.cardHolderName,
                        expiryDate: widget.expiryDate,
                        inputConfiguration: const InputConfiguration(
                          cardNumberDecoration: InputDecoration(
                            labelText: 'Card Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                          ),
                          expiryDateDecoration: InputDecoration(
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: InputDecoration(
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: InputDecoration(
                            labelText: 'Card Holder',
                          ),
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      // const SizedBox(height: 20),
                      // Padding(
                      //   padding:
                      //   const EdgeInsets.symmetric(horizontal: 16),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: <Widget>[
                      //       const Text('Glassmorphism'),
                      //       const Spacer(),
                      //       Switch(
                      //         value:  widget.useGlassMorphism,
                      //         inactiveTrackColor: Colors.grey,
                      //         activeColor: Colors.white,
                      //         activeTrackColor: AppColors.colorE5D1B2,
                      //         onChanged: (bool value) => setState(() {
                      //           widget.useGlassMorphism = value;
                      //         }),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding:
                      //   const EdgeInsets.symmetric(horizontal: 16),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: <Widget>[
                      //       const Text('Card Image'),
                      //       const Spacer(),
                      //       Switch(
                      //         value:  widget.useBackgroundImage,
                      //         inactiveTrackColor: Colors.grey,
                      //         activeColor: Colors.white,
                      //         activeTrackColor: AppColors.colorE5D1B2,
                      //         onChanged: (bool value) => setState(() {
                      //           widget.useBackgroundImage = value;
                      //         }),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Padding(
                      //   padding:
                      //   const EdgeInsets.symmetric(horizontal: 16),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: <Widget>[
                      //       const Text('Floating Card'),
                      //       const Spacer(),
                      //       Switch(
                      //         value:  widget.useFloatingAnimation,
                      //         inactiveTrackColor: Colors.grey,
                      //         activeColor: Colors.white,
                      //         activeTrackColor: AppColors.colorE5D1B2,
                      //         onChanged: (bool value) => setState(() {
                      //           widget.useFloatingAnimation = value;
                      //         }),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          widget.payData.card = Card(
                              number: widget.cardNumber.replaceAll(" ", ""),
                              exMonth: widget.expiryDate.split('/')[0],
                              exYear:
                                  widget.expiryDate.split('/')[1].length == 2
                                      ? "20${widget.expiryDate.split('/')[1]}"
                                      : widget.expiryDate.split('/')[1],
                              cvv: widget.cvvCode);
                          widget.payData.customer?.name = widget.cardHolderName;

                          _onValidate(
                              payData: widget.payData,
                              context: context,
                              onSuccess: widget.onSuccess);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xff101010),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          child: const Text(
                            'Pay',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.network(
                        "https://www.royat.sa/wp-content/plugins/RoyatPayPlugin/assets/royat.png",
                        width: 120,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onValidate(
      {required PayData payData,
      required BuildContext context,
      required Function onSuccess}) {
    if (formKey.currentState?.validate() ?? false) {
      RoyatPay.instance.payWithCard(
          context: context, payData: payData, onSuccess: onSuccess);
    } else {
      print('invalid!');
    }
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (!widget.useGlassMorphism) {
      return null;
    }

    final LinearGradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: <Color>[Colors.grey.withAlpha(50), Colors.grey.withAlpha(50)],
      stops: const <double>[0.3, 0],
    );

    return widget.isLightTheme
        ? Glassmorphism(blurX: 8.0, blurY: 16.0, gradient: gradient)
        : Glassmorphism.defaultConfig();
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      widget.cardNumber = creditCardModel.cardNumber;
      widget.expiryDate = creditCardModel.expiryDate;
      widget.cardHolderName = creditCardModel.cardHolderName;
      widget.cvvCode = creditCardModel.cvvCode;
      widget.isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}
