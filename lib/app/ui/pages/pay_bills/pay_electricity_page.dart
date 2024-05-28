import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nitrobills/app/data/models/electricity_service_provider.dart';
import 'package:nitrobills/app/data/models/transactions.dart';
import 'package:nitrobills/app/ui/global_widgets/nb_buttons.dart';
import 'package:nitrobills/app/ui/global_widgets/nb_field.dart';
import 'package:nitrobills/app/ui/global_widgets/nb_headers.dart';
import 'package:nitrobills/app/ui/global_widgets/electricity_service_provider_modal.dart';
import 'package:nitrobills/app/ui/pages/transactions/confirm_transaction_screen.dart';
import 'package:nitrobills/app/ui/utils/nb_colors.dart';
import 'package:nitrobills/app/ui/utils/nb_text.dart';

class PayElectricityPage extends StatefulWidget {
  const PayElectricityPage({super.key});

  @override
  State<PayElectricityPage> createState() => _PayElectricityPageState();
}

class _PayElectricityPageState extends State<PayElectricityPage> {
  bool addToBeneficiary = false;

  late final TextEditingController nameCntr;
  ElectricityServiceProvider? electricityProvider;

  @override
  void initState() {
    super.initState();
    nameCntr = TextEditingController();
  }

  @override
  void dispose() {
    nameCntr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
          ),
          child: Column(
            children: [
              36.verticalSpace,
              NbHeader.backAndTitle(
                "Electricity",
                () {
                  Get.back();
                },
                fontSize: 18.w,
                fontWeight: FontWeight.w600,
                color: NbColors.black,
              ),
              37.verticalSpace,
              NbField.buttonArrowDown(
                fieldHeight: 78.h,
                text: electricityProvider?.name ?? "Choose Provider",
                onTap: _chooseProvider,
              ),
              32.verticalSpace,
              NbField.text(
                fieldHeight: 78.h,
                hint: "Customer Id",
              ),
              32.verticalSpace,
              NbField.text(
                fieldHeight: 78.h,
                hint: "Amount",
              ),
              if (addToBeneficiary) ...[
                32.verticalSpace,
                NbField.text(
                  controller: nameCntr,
                  hint: "Name",
                  fieldHeight: 78.h,
                )
              ],
              21.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: NbText.sp16("Add this account to beneficiary")
                        .w500
                        .black,
                  ),
                  NbField.check(
                    value: addToBeneficiary,
                    onChanged: (v) {
                      setState(() {
                        addToBeneficiary = v;
                      });
                    },
                  ),
                ],
              ),
              const Spacer(),
              NbButton.primary(
                text: "Continue",
                onTap: _continue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _chooseProvider() async {
    electricityProvider = await Get.bottomSheet<ElectricityServiceProvider>(
          const ElectricityServiceProviderModal(),
          barrierColor: NbColors.black.withOpacity(0.2),
          isScrollControlled: true,
        ) ??
        electricityProvider;
    setState(() {});
  }

  void _continue() {
    Get.to(
      () => ConfirmTransactionScreen(
        transaction: Transaction.sampleElectricity,
      ),
    );
  }
}