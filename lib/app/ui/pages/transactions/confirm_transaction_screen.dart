import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nitrobills/app/controllers/account/transactions_controller.dart';
import 'package:nitrobills/app/controllers/bills/airtime_controller.dart';
import 'package:nitrobills/app/controllers/bills/betting_controller.dart';
import 'package:nitrobills/app/controllers/bills/cable_controller.dart';
import 'package:nitrobills/app/controllers/bills/data_controller.dart';
import 'package:nitrobills/app/controllers/bills/electricity_controller.dart';
import 'package:nitrobills/app/data/enums/button_enum.dart';
import 'package:nitrobills/app/data/services/bills/bulk_sms_service.dart';
import 'package:nitrobills/app/ui/global_widgets/nb_headers.dart';
import 'package:nitrobills/app/ui/pages/transactions/models/bill.dart';
import 'package:nitrobills/app/ui/pages/transactions/transaction_details_screen.dart';
import 'package:nitrobills/app/ui/pages/transactions/widgets/instant_transaction_tile.dart';
import 'package:nitrobills/app/ui/pages/transactions/widgets/make_recurring_payment_modal.dart';
import 'package:nitrobills/app/ui/pages/transactions/widgets/overview_provider_tile.dart';
import 'package:nitrobills/app/ui/pages/transactions/widgets/transaction_payment_preference_widget.dart';
import 'package:nitrobills/app/ui/utils/nb_colors.dart';
import 'package:nitrobills/app/ui/utils/nb_text.dart';
import 'package:nitrobills/app/ui/utils/nb_toast.dart';

class ConfirmTransactionScreen extends StatefulWidget {
  final Bill bill;

  const ConfirmTransactionScreen({
    super.key,
    required this.bill,
  });

  @override
  State<ConfirmTransactionScreen> createState() =>
      _ConfirmTransactionScreenState();
}

class _ConfirmTransactionScreenState extends State<ConfirmTransactionScreen> {
  bool makeAutopay = false;
  bool enableDataManagement = false;

  ButtonEnum btnStatus = ButtonEnum.disabled;

  int? avatarColor;
  int? avatarIdx;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            36.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: NbHeader.backAndTitle(
                "Transaction overview",
                () {
                  Get.back();
                },
                fontSize: 18.w,
                fontWeight: FontWeight.w600,
                color: NbColors.black,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  child: Column(
                    children: [
                      21.verticalSpace,
                      OverviewProviderTile(
                        bill: widget.bill,
                        colorIdx: avatarColor,
                        avatarIdx: avatarIdx,
                        onSetAvatar: (col, idx) {
                          setState(() {
                            avatarColor = col;
                            avatarIdx = idx;
                          });
                        },
                      ),
                      6.verticalSpace,
                      Row(
                        children: [
                          16.horizontalSpace,
                          NbText.sp13("Available balance")
                              .w500
                              .setColor(const Color(0xFF7F7F7F)),
                          8.horizontalSpace,
                          NbText.sp13("NGN ${widget.bill.amount}").w500.black,
                        ],
                      ),
                      InstantTransactionTile(bill: widget.bill),
                      30.verticalSpace,
                      TransactionPaymentPreferenceWidget(
                        bill: widget.bill,
                        autopayment: makeAutopay,
                        dataManagement: enableDataManagement,
                        onSetAutopayment: (v) {
                          _makeRecurringPayment(v);
                        },
                        onSetDataManagement: (v) {
                          _setDataManagement(v);
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _makeRecurringPayment(bool value) async {
    if (value) {
      bool? hasSetData = await Get.bottomSheet<bool>(
        const MakeRecurringPaymentModal(),
        backgroundColor: Colors.black.withOpacity(0.2),
        isScrollControlled: true,
      );

      if (hasSetData ?? false) {
        setState(() {
          makeAutopay = value;
        });
      }
    } else {
      setState(() {
        makeAutopay = value;
      });
    }
  }

  Future _setDataManagement(bool value) async {}

  void _continue() async {
    btnStatus = ButtonEnum.loading;
    bool success = await pay();
    if (success) {
      btnStatus = ButtonEnum.active;
      await Future.delayed(const Duration(milliseconds: 500));
      Get.to(() => TransactionDetailsScreen(bill: widget.bill));
    } else {
      btnStatus = ButtonEnum.disabled;
    }
  }

  Future<bool> pay() async {
    bool success;
    final bill = widget.bill;
    if (bill is AirtimeBill) {
      success = await Get.find<AirtimeController>().buy(bill);
    } else if (bill is DataBill) {
      success = await Get.find<DataController>().buy(bill);
    } else if (bill is BetBill) {
      success = await Get.find<BettingController>().buy(bill);
    } else if (bill is ElectricityBill) {
      success = await Get.find<ElectricityController>().buy(bill);
    } else if (bill is CableBill) {
      success = await Get.find<CableController>().buy(bill);
    } else if (bill is BulkSMSBill) {
      final tran = await BulkSmsService.buy(bill);
      if (tran.isRight) {
        Get.find<TransactionsController>().addTransaction(tran.right);
        success = true;
      } else {
        NbToast.error(tran.left.message);
        success = false;
      }
    } else {
      throw Exception("Nitrobills error: not a valid bill type");
    }
    return success;
  }
}
