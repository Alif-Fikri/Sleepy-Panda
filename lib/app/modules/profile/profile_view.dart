import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF20223F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF20223F),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Profil',
          style: TextStyle(fontFamily: 'Urbanist'),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshProfile,
        color: Colors.white,
        backgroundColor: const Color(0xFF20223F),
        child: Obx(
          () => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.03,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: size.height * 0.85,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (controller.isLoading.value)
                    Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.02),
                      child: const LinearProgressIndicator(
                        color: Color(0xFF00ADB5),
                        backgroundColor: Color(0x33272E49),
                      ),
                    ),
                  _AvatarSection(size: size),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    controller.displayName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.06,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  SizedBox(height: size.height * 0.006),
                  Text(
                    controller.displayEmail,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: size.width * 0.04,
                      fontFamily: 'Urbanist',
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  _InfoCard(size: size),
                  SizedBox(height: size.height * 0.03),
                  _ActionCard(size: size),
                  SizedBox(height: size.height * 0.04),
                  _LogoutButton(size: size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AvatarSection extends GetView<ProfileController> {
  const _AvatarSection({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final avatarPath = controller.avatarPath.value;
      final hasAvatar = avatarPath != null &&
          avatarPath.isNotEmpty &&
          File(avatarPath).existsSync();

      return Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: size.width * 0.18,
            backgroundColor: const Color(0xFF272E49),
            backgroundImage: hasAvatar ? FileImage(File(avatarPath)) : null,
            child: hasAvatar
                ? null
                : Icon(
                    Icons.person,
                    size: size.width * 0.18,
                    color: Colors.white,
                  ),
          ),
          Positioned(
            bottom: 12,
            right: size.width * 0.26,
            child: GestureDetector(
              onTap: () => controller.pickAvatar(context),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF00ADB5),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.camera_alt,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _InfoCard extends GetView<ProfileController> {
  const _InfoCard({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.055,
        vertical: size.height * 0.028,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF272E49),
        borderRadius: BorderRadius.circular(size.width * 0.04),
      ),
      child: Column(
        children: [
          _InfoRow(
            iconAsset: 'assets/images/detil.png',
            label: 'Nama',
            value: controller.displayName,
            size: size,
          ),
          SizedBox(height: size.height * 0.018),
          _InfoRow(
            iconAsset: 'assets/images/email.png',
            label: 'Email',
            value: controller.displayEmail,
            size: size,
          ),
          SizedBox(height: size.height * 0.018),
          Obx(() {
            final gender = controller.profile.value?.gender?.toLowerCase();
            final iconAsset = (gender == '0' || gender == 'female')
                ? 'assets/images/person2.png'
                : 'assets/images/person1.png';
            return _InfoRow(
              iconAsset: iconAsset,
              label: 'Gender',
              value: controller.displayGender,
              size: size,
            );
          }),
          SizedBox(height: size.height * 0.018),
          _InfoRow(
            iconAsset: 'assets/images/dob.png',
            label: 'Tanggal lahir',
            value: controller.displayDateOfBirth,
            size: size,
          ),
          SizedBox(height: size.height * 0.018),
          _InfoRow(
            iconAsset: 'assets/images/ceklis.png',
            label: 'Pekerjaan',
            value: controller.displayWork,
            size: size,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.iconAsset,
    required this.label,
    required this.value,
    required this.size,
  });

  final String iconAsset;
  final String label;
  final String value;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          iconAsset,
          width: size.width * 0.08,
          height: size.width * 0.08,
          fit: BoxFit.contain,
        ),
        SizedBox(width: size.width * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: size.width * 0.035,
                  fontFamily: 'Urbanist',
                ),
              ),
              SizedBox(height: size.height * 0.004),
              Text(
                value.isEmpty ? '-' : value,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Urbanist',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends GetView<ProfileController> {
  const _ActionCard({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF272E49),
        borderRadius: BorderRadius.circular(size.width * 0.04),
      ),
      child: Column(
        children: [
          _ActionTile(
            iconAsset: 'assets/images/detil.png',
            label: 'Detil profil',
            onTap: controller.openProfileDetail,
            size: size,
          ),
          Divider(
            color: Colors.white12,
            indent: size.width * 0.18,
            endIndent: size.width * 0.04,
            height: 1,
          ),
          _ActionTile(
            iconAsset: 'assets/images/terms.png',
            label: 'Terms & Conditions',
            onTap: () => controller.openTerms(context),
            size: size,
          ),
          Divider(
            color: Colors.white12,
            indent: size.width * 0.18,
            endIndent: size.width * 0.04,
            height: 1,
          ),
          _ActionTile(
            iconAsset: 'assets/images/feedback.png',
            label: 'Feedback',
            onTap: controller.openFeedback,
            size: size,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.iconAsset,
    required this.label,
    required this.onTap,
    required this.size,
  });

  final String iconAsset;
  final String label;
  final VoidCallback onTap;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.005,
      ),
      leading: Image.asset(
        iconAsset,
        width: size.width * 0.065,
        height: size.width * 0.065,
      ),
      title: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: size.width * 0.043,
          fontWeight: FontWeight.w600,
          fontFamily: 'Urbanist',
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white,
        size: size.width * 0.07,
      ),
      onTap: onTap,
    );
  }
}

class _LogoutButton extends GetView<ProfileController> {
  const _LogoutButton({required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        height: size.height * 0.065,
        child: ElevatedButton(
          onPressed: controller.isLoggingOut.value
              ? null
              : () => controller.confirmLogout(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(size.width * 0.035),
            ),
          ),
          child: controller.isLoggingOut.value
              ? SizedBox(
                  width: size.height * 0.03,
                  height: size.height * 0.03,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFF009090),
                  ),
                )
              : Text(
                  'Logout',
                  style: TextStyle(
                    color: const Color(0xFF009090),
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
