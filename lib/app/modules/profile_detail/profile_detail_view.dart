import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_detail_controller.dart';

class ProfileDetailView extends GetView<ProfileDetailController> {
  const ProfileDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF20223F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF20223F),
        elevation: 0,
        foregroundColor: Colors.white,
        title: const Text(
          'Detil Profil',
          style: TextStyle(fontFamily: 'Urbanist'),
        ),
      ),
      body: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.06,
                vertical: size.height * 0.035,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionLabel(text: 'Nama', size: size),
                  SizedBox(height: size.height * 0.012),
                  _AppTextField(
                    controller: controller.nameController,
                    hintText: 'Nama lengkap',
                    size: size,
                  ),
                  SizedBox(height: size.height * 0.025),
                  _SectionLabel(text: 'Email', size: size),
                  SizedBox(height: size.height * 0.012),
                  _AppTextField(
                    controller: controller.emailController,
                    hintText: 'Alamat email',
                    readOnly: true,
                    size: size,
                  ),
                  SizedBox(height: size.height * 0.025),
                  _SectionLabel(text: 'Gender', size: size),
                  SizedBox(height: size.height * 0.012),
                  _GenderSelector(size: size),
                  SizedBox(height: size.height * 0.025),
                  _SectionLabel(text: 'Tanggal lahir', size: size),
                  SizedBox(height: size.height * 0.012),
                  GestureDetector(
                    onTap: () => controller.pickDate(context),
                    child: AbsorbPointer(
                      child: _AppTextField(
                        controller: controller.dateController,
                        hintText: 'dd/MM/yyyy',
                        size: size,
                        prefixIcon: Icons.calendar_month,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),
                  _SaveButton(size: size),
                ],
              ),
            ),
            if (controller.isLoading.value) const _LoadingOverlay(),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text, required this.size});

  final String text;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white70,
        fontSize: size.width * 0.04,
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _AppTextField extends StatelessWidget {
  const _AppTextField({
    required this.controller,
    required this.hintText,
    required this.size,
    this.readOnly = false,
    this.prefixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final Size size;
  final bool readOnly;
  final IconData? prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      style: TextStyle(
        color: Colors.white,
        fontFamily: 'Urbanist',
        fontSize: size.width * 0.045,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF272E49),
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white38,
          fontFamily: 'Urbanist',
        ),
        prefixIcon:
            prefixIcon == null ? null : Icon(prefixIcon, color: Colors.white70),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(size.width * 0.035),
          borderSide: BorderSide.none,
        ),
      ),
      cursorColor: const Color(0xFF00ADB5),
    );
  }
}

class _GenderSelector extends GetView<ProfileDetailController> {
  const _GenderSelector({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedGender.value;
      return Row(
        children: [
          _GenderOption(
            label: 'Perempuan',
            value: '0',
            isSelected: selected == '0',
            onTap: () => controller.selectGender('0'),
            size: size,
            asset: 'assets/images/person2.png',
          ),
          SizedBox(width: size.width * 0.04),
          _GenderOption(
            label: 'Pria',
            value: '1',
            isSelected: selected == '1',
            onTap: () => controller.selectGender('1'),
            size: size,
            asset: 'assets/images/person1.png',
          ),
        ],
      );
    });
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
    required this.size,
    required this.asset,
  });

  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;
  final Size size;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            vertical: size.height * 0.018,
            horizontal: size.width * 0.05,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF272E49),
            borderRadius: BorderRadius.circular(size.width * 0.035),
            border: Border.all(
              color: isSelected ? const Color(0xFF00ADB5) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                asset,
                width: size.width * 0.08,
                height: size.width * 0.08,
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.04,
                    fontFamily: 'Urbanist',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF00ADB5),
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaveButton extends GetView<ProfileDetailController> {
  const _SaveButton({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: size.height * 0.065,
        child: ElevatedButton(
          onPressed:
              controller.isSaving.value ? null : () => controller.save(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00ADB5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.width * 0.035),
            ),
          ),
          child: controller.isSaving.value
              ? SizedBox(
                  width: size.height * 0.03,
                  height: size.height * 0.03,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  'Simpan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Urbanist',
                  ),
                ),
        ),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFF00ADB5)),
      ),
    );
  }
}
