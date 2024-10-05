import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'app_colors.dart';

class RoyatPayWidget extends StatefulWidget {
  bool isLightTheme = false;
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  bool useFloatingAnimation = true;

  RoyatPayWidget(
      {
      required this.cardNumber,
      required this.expiryDate,
      required this.cardHolderName,
      required this.cvvCode,
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
                enableFloatingCard:  widget.useFloatingAnimation,
                glassmorphismConfig: _getGlassmorphismConfig(),
                cardNumber:  widget.cardNumber,
                expiryDate:  widget.expiryDate,
                cardHolderName:  widget.cardHolderName,
                cvvCode:  widget.cvvCode,
                bankName: 'Royat Pay',
                frontCardBorder:  widget.useGlassMorphism
                    ? null
                    : Border.all(color: Colors.grey),
                backCardBorder:  widget.useGlassMorphism
                    ? null
                    : Border.all(color: Colors.grey),
                showBackView:  widget.isCvvFocused,
                obscureCardNumber: true,
                obscureCardCvv: true,
                isHolderNameVisible: true,
                cardBgColor: widget.isLightTheme
                    ? AppColors.cardBgLightColor
                    : AppColors.cardBgColor,
                backgroundImage:
                widget.useBackgroundImage ? 'assets/card_bg.png' : null,
                isSwipeGestureEnabled: true,
                onCreditCardWidgetChange:
                    (CreditCardBrand creditCardBrand) {},
                customCardTypeIcons: <CustomCardTypeIcon>[
                  // CustomCardTypeIcon(
                  //   cardType: CardType.mastercard,
                  //   cardImage: Image.asset(
                  //     'assets/mastercard.png',
                  //     height: 48,
                  //     width: 48,
                  //   ),
                  // ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber:  widget.cardNumber,
                        cvvCode:  widget.cvvCode,
                        isHolderNameVisible: true,
                        isCardNumberVisible: true,
                        isExpiryDateVisible: true,
                        cardHolderName:  widget.cardHolderName,
                        expiryDate:  widget.expiryDate,
                        inputConfiguration: const InputConfiguration(
                          cardNumberDecoration: InputDecoration(
                            labelText: 'Number',
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
                        onTap: _onValidate,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                AppColors.colorB58D67,
                                AppColors.colorB58D67,
                                AppColors.colorE5D1B2,
                                AppColors.colorF9EED2,
                                AppColors.colorEFEFED,
                                AppColors.colorF9EED2,
                                AppColors.colorB58D67,
                              ],
                              begin: Alignment(-1, -4),
                              end: Alignment(1, 4),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                          ),
                          padding:
                          const EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          child: const Text(
                            'Validate',
                            style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'halter',
                              fontSize: 14,
                              package: 'flutter_credit_card',
                            ),
                          ),
                        ),
                      ),
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

  void _onValidate() {
    if (formKey.currentState?.validate() ?? false) {
      print('valid!');
    } else {
      print('invalid!');
    }
  }

  Glassmorphism? _getGlassmorphismConfig() {
    if (! widget.useGlassMorphism) {
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