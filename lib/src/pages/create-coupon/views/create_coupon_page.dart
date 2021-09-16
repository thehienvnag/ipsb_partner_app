import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ipsb_partner_app/src/pages/create-coupon/controllers/create_coupon_controller.dart';
import 'package:ipsb_partner_app/src/pages/create-coupon/views/discount_type_dropdown.dart';
import 'package:ipsb_partner_app/src/pages/create-coupon/views/select_product.dart';
import 'package:ipsb_partner_app/src/utils/utils.dart';
import 'package:ipsb_partner_app/src/widgets/custom_text_field.dart';
import 'package:ipsb_partner_app/src/widgets/date_time_picker.dart';

class CreateCouponPage extends GetView<CreateCouponController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'TẠO KHUYẾN MÃI',
          style: TextStyle(color: Colors.black87),
        ),
        leading: _buildLeading(),
        actions: [_buildActions()],
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Obx(() => _buildStepsDisplay(controller.currentStep.value)),
              Obx(() {
                return GestureDetector(
                  onTap: () => controller.getImage(),
                  child: Container(
                    width: 240,
                    height: 140,
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: controller.showImage(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black12),
                    ),
                  ),
                );
              }),
              Obx(() => _buildStep(controller.currentStep.value)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepsDisplay(int step) {
    return Container(
      height: 75,
      child: CupertinoStepper(
        currentStep: step,
        onStepTapped: (value) => controller.gotoStep(value),
        type: StepperType.horizontal,
        controlsBuilder: (context, {onStepCancel, onStepContinue}) =>
            SizedBox(),
        steps: [
          Step(
            title: Text(''),
            content: SizedBox(),
            isActive: step == 0,
          ),
          Step(
            title: Text(''),
            content: SizedBox(),
            isActive: step == 1,
          ),
          Step(
            title: Text(''),
            content: SizedBox(),
            isActive: step == 2,
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return _buildStepGeneral(stepIndex);
      case 1:
        return _buildStepDetails(stepIndex);
      case 2:
        return _buildStepFinal(stepIndex);
    }
    return _buildStepGeneral(stepIndex);
  }

  Widget _buildStepGeneral(int step) {
    final couponData = controller.couponData;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 25.0, // soften the shadow
            spreadRadius: 5.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Form(
        key: controller.formStates[step],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              value: couponData[CouponFieldsName.name],
              label: 'Tên ưu đãi',
              validator: TextFieldValidator.require,
              onSubmitted: (value) =>
                  controller.inputValue(CouponFieldsName.name, value),
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              value: couponData[CouponFieldsName.code] ?? '',
              label: 'Mã ưu đãi',
              validator: TextFieldValidator.require,
              onSubmitted: (value) => controller.inputValue(
                  CouponFieldsName.code, value?.toUpperCase()),
            ),
            SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () => controller.inputValue(
                  CouponFieldsName.code, Utils.genRandStr(10)),
              child: Text('TẠO NGẪU NHIÊN'),
            ),
            SizedBox(height: 15),
            SelectProduct(
              label: 'Sản phẩm áp dụng (Tùy chọn)',
              items: controller.products,
              onSubmitted: (value) => controller.chooseProducts(
                  CouponFieldsName.productInclude, value),
              selectedProducts: controller.productIncludes,
            ),
            SizedBox(height: 20),
            SelectProduct(
              label: 'Sản phẩm không áp dụng (Tùy chọn)',
              items: controller.products,
              onSubmitted: (value) => controller.chooseProducts(
                  CouponFieldsName.productExclude, value),
              selectedProducts: controller.productExcludes,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              value: couponData[CouponFieldsName.description],
              label: 'Chi tiết ưu đãi',
              validator: TextFieldValidator.require,
              onSubmitted: (value) =>
                  controller.inputValue(CouponFieldsName.description, value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepDetails(int step) {
    final couponData = controller.couponData;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 25.0, // soften the shadow
            spreadRadius: 5.0, //extend the shadow
            offset: Offset(5.0, 5.0),
          )
        ],
      ),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Form(
        key: controller.formStates[step],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DiscountTypeDropdown(
              label: 'Loại khuyến mãi',
              fieldName: CouponFieldsName.discountType,
              items: controller.dropdownItems,
              onChanged: (value, fieldName) =>
                  controller.inputDropdown(fieldName, value),
              selectedItem: controller.selectedItem.value,
            ),
            SizedBox(
              height: 20,
            ),
            CustomTextField(
              value: couponData[CouponFieldsName.amount],
              label: 'Giá trị khuyến mãi',
              validator: TextFieldValidator.require,
              onSubmitted: (value) =>
                  controller.inputValue(CouponFieldsName.amount, value),
              counterText: 'VNĐ',
            ),
            CustomTextField(
              value: controller.couponData[CouponFieldsName.maxDiscount],
              label: 'Giá trị ưu đãi tối đa',
              validator: TextFieldValidator.require,
              onSubmitted: (value) =>
                  controller.inputValue(CouponFieldsName.maxDiscount, value),
              counterText: 'VNĐ',
              inputType: TextInputType.number,
            ),
            SizedBox(height: 20),
            CustomTextField(
              value: controller.couponData[CouponFieldsName.minSpend],
              label: 'Giá trị đơn hàng tối thiểu',
              validator: TextFieldValidator.require,
              onSubmitted: (value) =>
                  controller.inputValue(CouponFieldsName.minSpend, value),
              inputType: TextInputType.number,
              counterText: 'VNĐ',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepFinal(int step) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 25.0, // soften the shadow
            spreadRadius: 5.0, //extend the shadow
            offset: Offset(
              5.0, // Move to right 10  horizontally
              5.0, // Move to bottom 10 Vertically
            ),
          )
        ],
      ),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Form(
        key: controller.formStates[step],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              value: controller.couponData[CouponFieldsName.limit],
              label: 'Giới hạn sử dụng',
              onSubmitted: (value) =>
                  controller.inputValue(CouponFieldsName.limit, value),
              counterText: 'Lần sử dụng',
            ),
            SizedBox(
              height: 20,
            ),
            DateTimePicker(
              label: 'Ngày bắt đầu',
              onSubmitted: (value) => controller.inputValue(
                  CouponFieldsName.publishDate, value?.toIso8601String()),
              validator: (value) =>
                  value == null ? 'Vui lòng chọn ngày bắt đầu!' : null,
              value: controller.couponData[CouponFieldsName.publishDate],
            ),
            SizedBox(
              height: 20,
            ),
            DateTimePicker(
              label: 'Ngày hết hạn',
              onSubmitted: (value) => controller.inputValue(
                  CouponFieldsName.expireDate, value?.toIso8601String()),
              value: controller.couponData[CouponFieldsName.expireDate],
              validator: (value) {
                if (value == null) {
                  return 'Vui lòng chọn ngày hết hạn!';
                }
                String? previousDate =
                    controller.couponData[CouponFieldsName.publishDate];
                if (previousDate == null) {
                  return 'Vui lòng chọn ngày bắt đầu!';
                }
                DateTime previous = DateTime.parse(previousDate);
                if (value.isBefore(previous)) {
                  return 'Ngày kết thúc phải lớn hơn ngày bắt đầu';
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return Obx(() {
      int step = controller.currentStep.value;
      return Container(
        padding: const EdgeInsets.all(12),
        child: ClipOval(
          child: Material(
            color: Colors.grey.shade300,
            // Button color
            child: InkWell(
              splashColor: Colors.blueAccent, // Splash color
              onTap: () {
                print(step);
                if (step == 0)
                  Get.back();
                else {
                  controller.formStates[step].currentState?.save();
                  controller.backToPrevious();
                }
              },
              child: Icon(
                Icons.chevron_left,
                size: 32,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildActions() {
    return Obx(() {
      int step = controller.currentStep.value;
      switch (step) {
        case 0:
        case 1:
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: OutlinedButton(
              onPressed: () => controller.moveToNext(),
              child: Text('TIẾP TỤC'),
            ),
          );
      }
      return Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ElevatedButton(
          onPressed: () => controller.submitForm(),
          child: Text('HOÀN TẤT'),
        ),
      );
    });
  }
}
