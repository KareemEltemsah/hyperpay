import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hyperpay_plugin/flutter_hyperpay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {

  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late FlutterHyperPay flutterHyperPay ;
  @override
  void initState() {
    flutterHyperPay = FlutterHyperPay(
      shopperResultUrl: InAppPaymentSetting.shopperResultUrl, // For Android
      paymentMode:  PaymentMode.test,
      lang: InAppPaymentSetting.getLang(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text("Payment"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getCheckOut(finalPrice: 1.0);
        },
        child: const Icon(Icons.ads_click),
      ),
    );
  }

  /// URL TO GET CHECKOUT ID FOR TEST
  /// http://dev.hyperpay.com/hyperpay-demo/getcheckoutid.php

  getCheckOut({required double finalPrice}) async {
    payRequestNow(checkoutId: 'F922A63D20D8185529C74556EF65C5FD.uat01-vm-tx04', cardName: "VISA");
  }

  payRequestNow({required String cardName, required String checkoutId}) async {

    PaymentResultData paymentResultData;
    if (cardName.toLowerCase() ==
        InAppPaymentSetting.applePay.toLowerCase()) {
      paymentResultData = await flutterHyperPay.payWithApplePay(
        applePay: ApplePay(
          /// ApplePayBundel refer to Merchant ID
            applePayBundel: InAppPaymentSetting.merchantId,
            checkoutId: checkoutId,
            countryCode: InAppPaymentSetting.countryCode,
            currencyCode: InAppPaymentSetting.currencyCode),
      );
    } else {
      paymentResultData = await flutterHyperPay.readyUICards(
        readyUI: ReadyUI(
          brandName: cardName,
          checkoutId: checkoutId,
          setStorePaymentDetailsMode: false,
        ),
      );
    }

    if (paymentResultData.paymentResult == PaymentResult.success ||
        paymentResultData.paymentResult == PaymentResult.sync) {
      // do something
      try {
      } catch (message) {
        return ;
      }
    }

  }
}

class InAppPaymentSetting {
  static const String applePay="APPLEPAY";
  static  String shopperResultUrl= "com.testpayment.payment";
  static  String merchantId= "MerchantId";
  static const String countryCode="SA";
  static const String currencyCode="SAR";
  static getLang() {
    if (Platform.isIOS) {
      return  "en"; // ar
    } else {
      return "en_US"; // ar_AR
    }
  }
}