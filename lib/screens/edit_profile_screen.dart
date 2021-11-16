import 'package:booking_app_client/providers/auth_provider.dart';
import 'package:booking_app_client/widgets_model/custom_add_text_form_field.dart';
import 'package:booking_app_client/widgets_model/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey();

  void update(BuildContext context, AuthProvider value) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    try {
      await value.updateUserData().then((value) => Navigator.of(context).pop());
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred, please try again'.tr),
          duration: Duration(seconds: 5)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile".tr),
             ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer<AuthProvider>(
            builder: (context, valueAuth, child) => Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAddTextFormField(
                    initialValue: valueAuth.employeeModel!.name,
                    label: 'Name'.tr,
                    onSave: (String? val) {
                      valueAuth.employeeModel!.name = val!;
                    },
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return 'Enter the name'.tr;
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomAddTextFormField(
                    initialValue: valueAuth.employeeModel!.lastName,
                    label: 'Last Name'.tr,
                    onSave: (String? val) {
                      valueAuth.employeeModel!.lastName = val!;
                    },
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return 'Enter the Last name'.tr;
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomAddTextFormField(
                    initialValue: valueAuth.employeeModel!.occupationGroup,
                    label: 'Occupation Group'.tr,
                    onSave: (String? val) {
                      valueAuth.employeeModel!.occupationGroup = val!;
                    },
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return 'Enter the OccupationGroup'.tr;
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomAddTextFormField(
                    initialValue: valueAuth.employeeModel!.phone,
                    label: 'Phone'.tr,
                    keyboardType: TextInputType.number,
                    onSave: (String? val) {
                      valueAuth.employeeModel!.phone = val!;
                    },
                    validator: (String? val) {
                      if (val!.isEmpty) {
                        return 'Enter the Phone'.tr;
                      } else
                        return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  valueAuth.isLoading.value
                      ? CircularProgressIndicator()
                      : CustomElevatedButton(
                          text: 'Update'.tr,
                          onPressed: () => update(context, valueAuth),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
