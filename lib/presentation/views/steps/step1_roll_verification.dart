import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/utils/validators.dart';
import '../../controllers/admission_controller.dart';
import '../widgets/step_header.dart';
import '../widgets/custom_text_field.dart';

class Step1RollVerification extends StatefulWidget {
  const Step1RollVerification({super.key});

  @override
  State<Step1RollVerification> createState() => _Step1RollVerificationState();
}

class _Step1RollVerificationState extends State<Step1RollVerification> {
  final _formKey = GlobalKey<FormState>();
  final _rollController = TextEditingController();
  final _scrollController = ScrollController();
  final _rollFocus = FocusNode();
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _rollController.addListener(_onTextChanged);
    // Auto-focus roll field + pop keyboard when screen opens.
    // Route transition steals focus, so retry after it settles.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_rollFocus.hasFocus) {
        _rollFocus.requestFocus();
      }
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted && !_rollFocus.hasFocus) {
          _rollFocus.requestFocus();
        }
      });
    });
    // When keyboard opens, scroll Verify button into view above keyboard.
    _rollFocus.addListener(() {
      if (_rollFocus.hasFocus) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted && _scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
              );
            }
          });
        });
      }
    });
  }

  void _onTextChanged() {
    if (!mounted) return;
    try {
      Get.find<AdmissionController>()
          .onRollTextChanged(_rollController.text);
    } catch (_) {}
  }

  void _doVerify(AdmissionController controller) {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      controller.verifyRoll(_rollController.text);
    }
  }

  @override
  void dispose() {
    _rollController.removeListener(_onTextChanged);
    _rollController.dispose();
    _rollFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdmissionController>();

    if (!_initialized && controller.formData.value.rollNumber.isNotEmpty) {
      _rollController.text = controller.formData.value.rollNumber;
      _initialized = true;
    }

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: SingleChildScrollView(
          controller: _scrollController,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.fromLTRB(
            16,
            12,
            16,
            // Keep Verify button above the keyboard on mobile.
            24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StepHeader(
                  title: 'step1_title'.tr,
                  subtitle: 'step1_subtitle'.tr,
                  icon: Icons.badge,
                ),
                const SizedBox(height: 18),
                // Form card (visual only wrapper — logic unchanged)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.divider, width: 1),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomTextField(
                        label: 'step1_roll_hint'.tr,
                        hint: 'step1_roll_hint'.tr,
                        controller: _rollController,
                        validator: Validators.rollNumber,
                        keyboardType: TextInputType.number,
                        focusNode: _rollFocus,
                        autofocus: true,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) {
                          if (!controller.isLoading.value &&
                              !controller.isRollVerified.value) {
                            _doVerify(controller);
                          }
                        },
                        prefix: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.search, color: Colors.white, size: 18),
                        ),
                        suffix: Obx(() {
                          if (controller.isRollVerified.value) {
                            return IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFF43F5E), Color(0xFFFB7185)],
                                  ),
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.ntcRed.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 15),
                              ),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                _rollController.clear();
                                controller.isRollVerified.value = false;
                                controller.verifiedRoll.value = '';
                                controller.studentName.value = '';
                                controller.rollError.value = '';
                                controller.alreadySubmitted.value = false;
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ),
                      const SizedBox(height: 6),
                      Obx(() {
                        if (controller.rollError.value.isNotEmpty) {
                          final isAlreadySubmitted = controller.alreadySubmitted.value;
                          final bannerColor = isAlreadySubmitted
                              ? const Color(0xFFF59E0B)
                              : AppColors.ntcRed;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: bannerColor.withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: bannerColor.withValues(alpha: 0.22)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: bannerColor.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isAlreadySubmitted
                                        ? Icons.warning_amber_rounded
                                        : Icons.error_outline,
                                    color: bannerColor,
                                    size: 17,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    controller.rollError.value,
                                    style: GoogleFonts.inter(
                                      color: bannerColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      const SizedBox(height: 8),
                      Obx(() {
                        final isLoading = controller.isLoading.value;
                        final isVerified = controller.isRollVerified.value;
                        return Container(
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: isVerified
                                ? const LinearGradient(
                                    colors: [Color(0xFF059669), Color(0xFF065F46)],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  )
                                : isLoading
                                    ? null
                                    : AppColors.primaryGradient,
                            color: isLoading ? AppColors.ntcBlue : null,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (isVerified
                                        ? Color(0xFF059669)
                                        : AppColors.ntcBlue)
                                    .withValues(alpha: 0.32),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: InkWell(
                            onTap: (isLoading || isVerified)
                                ? null
                                : () => _doVerify(controller),
                            borderRadius: BorderRadius.circular(16),
                            child: isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Verifying',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white.withValues(alpha: 0.9),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      _buildSwimmingDots(),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(alpha: 0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isVerified ? Icons.check_circle : Icons.search,
                                          size: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 9),
                                      Text(
                                        isVerified ? 'step1_verified'.tr : 'step1_verify'.tr,
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  if (controller.isRollVerified.value) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFD1FAE5), Color(0xFFECFDF5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: AppColors.ntcGreen.withValues(alpha: 0.5),
                          width: 1.4,
                        ),
                        boxShadow: AppColors.successShadow,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              gradient: AppColors.successGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.ntcGreen.withValues(alpha: 0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.person, color: Colors.white, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.studentName.value,
                                  style: GoogleFonts.poppins(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'step1_name_readonly'.tr,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              gradient: AppColors.successGradient,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'OK',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1);
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwimmingDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fadeIn(
              delay: (index * 200).ms,
              duration: 350.ms,
              begin: 0.25,
              curve: Curves.easeInOut,
            )
            .scale(
              delay: (index * 200).ms,
              duration: 350.ms,
              begin: const Offset(0.6, 0.6),
              end: const Offset(1.2, 1.2),
              curve: Curves.easeInOut,
            );
      }),
    );
  }
}
