import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // General
          'app_title': 'NTC Student Information Portal',
          'next': 'Next',
          'back': 'Back',
          'submit': 'Submit',
          'loading': 'Loading...',
          'error': 'Error',
          'success': 'Success',
          'ok': 'OK',
          'cancel': 'Cancel',

          // Landing
          'landing_title': 'NTC',
          'landing_subtitle': 'Student Information Portal',
          // 'landing_subtitle_bn': 'এনটিসি ভর্তি পোর্টাল',
          'landing_button': 'Submit Information / তথ্য জমা দিন',
          'landing_description': 'Roll-based online information form',

          // Step 1 - Phone Verification
          'step1_title': 'Phone Verification',
          'step1_subtitle': 'Enter your mobile number to verify',
          'step1_roll_hint': 'Enter Mobile Number (11 digits)',
          'step1_name_label': 'Full Name',
          'step1_name_readonly': '(Verified from records)',
          'step1_verify': 'Verify',
          'step1_verified': 'Verified',
          'step1_not_found': 'Roll number not found',
          'step1_already_submitted': 'Your data is already submitted',
          'step1_check_failed': 'Unable to verify submission status. Please try again.',
          'step1_verify_first': 'Please tap Verify above first',

          // Step 2 - Parent Info
          'step2_title': 'Parent Information',
          'step2_subtitle': 'Enter father and mother details',
          'step2_father_hint': "Father's Name",
          'step2_mother_hint': "Mother's Name",

          // Step 3 - Identity
          'step3_title': 'Identity Document',
          'step3_subtitle': 'Select document type and enter number',
          'step3_birth_cert': 'Birth Certificate (জন্ম নিবন্ধন)',
          'step3_nid': 'National ID (জাতীয় পরিচয়পত্র)',
          'step3_bc_hint': '17-digit Birth Certificate Number',
          'step3_nid_hint': '10-digit NID Number',

          // Step 4 - SSC
          'step4_title': 'SSC Information',
          'step4_subtitle': 'Enter your SSC examination details',
          'step4_roll_hint': 'SSC Roll Number',
          'step4_reg_hint': 'Registration Number',
          'step4_board_hint': 'Select Board',
          'step4_year_hint': 'Passing Year',
          'step4_gpa_hint': 'GPA (0.00 - 5.00)',
          'step4_hsc_complete': 'HSC Complete',
          'step4_hsc_complete_hint': 'Uncheck to skip HSC information',

          // Step 5 - HSC
          'step5_title': 'HSC Information',
          'step5_subtitle': 'Enter your HSC examination details',
          'step5_roll_hint': 'HSC Roll Number',
          'step5_reg_hint': 'Registration Number',
          'step5_board_hint': 'Select Board',
          'step5_year_hint': 'Passing Year',
          'step5_gpa_hint': 'GPA (0.00 - 5.00)',

          // Step 6 - Upload & Submit
          'step6_title': 'Photo & Submit',
          'step6_subtitle': 'Upload your photo and submit the form',
          'step6_upload_hint': 'Tap to upload photo (optional)',
          'step6_upload_subtext': 'JPG/PNG, max 5MB',
          'step6_change_photo': 'Change Photo',
          'step6_remove_photo': 'Remove',
          'step6_submit_button': 'Submit Application',
          'step6_confirm_title': 'Confirm Submission',
          'step6_confirm_message': 'Are you sure you want to submit? Please review your information before submitting.',

          // Success
          'success_title': 'Successfully Submitted!',
          'success_title_bn': 'সফলভাবে জমা হয়েছে!',
          'success_ref_label': 'Your Reference Number',
          'success_save_hint': 'Please save this reference number',
          'success_home_button': 'Back to Home / হোমে ফিরুন',

          // Validation
          'val_roll_required': 'Roll number is required',
          'val_roll_numeric': 'Roll number must contain only digits',
          'val_name_required': 'Name is required',
          'val_name_min': 'Name must be at least 2 characters',
          'val_father_required': "Father's name is required",
          'val_mother_required': "Mother's name is required",
          'val_bc_required': 'Birth certificate number is required',
          'val_bc_digits': 'Must be exactly 17 digits',
          'val_nid_required': 'NID number is required',
          'val_nid_digits': 'Must be exactly 10 digits',
          'val_roll_digits': 'Must contain only digits',
          'val_reg_required': 'Registration number is required',
          'val_board_required': 'Board is required',
          'val_year_required': 'Passing year is required',
          'val_year_invalid': 'Year must be between 1990 and 2028',
          'val_gpa_required': 'GPA is required',
          'val_gpa_invalid': 'GPA must be between 0.00 and 5.00',

          // Network
          'no_connection': 'No internet connection',
          'try_again': 'Try Again',
          'val_required': 'All fields are required',
          'error_message': 'An error occurred. Please try again.',
        },
        'bn_BD': {
          // General
          'app_title': 'তথ্য হালনাগাদ ফর্ম',
          'next': 'পরবর্তী',
          'back': 'পূর্ববর্তী',
          'submit': 'জমা দিন',
          'loading': 'লোড হচ্ছে...',
          'error': 'ত্রুটি',
          'success': 'সফল',
          'ok': 'ঠিক আছে',
          'cancel': 'বাতিল',

          // Landing
          'landing_title': 'এনটিসি',
          'landing_subtitle': 'Student Information Portal',
          'landing_subtitle_bn': 'এনটিসি তথ্য পোর্টাল',
          'landing_button': 'Submit Information / তথ্য জমা দিন',
          'landing_description': 'রোল-ভিত্তিক অনলাইন তথ্য ফর্ম',

          // Step 1 - Mobile Verification
          'step1_title': 'মোবাইল নম্বর যাচাই করুন',
          'step1_subtitle': 'নিচের বক্সে আপনার মোবাইল নম্বর দিন।',
          'step1_roll_hint': '১১ সংখ্যার মোবাইল নম্বর দিন',
          'step1_name_label': 'পূর্ণ নাম',
          'step1_name_readonly': '(রেকর্ড থেকে যাচাইকৃত)',
          'step1_verify': 'যাচাই করুন',
          'step1_verified': 'যাচাইকৃত',
          'step1_not_found': 'মোবাইল নম্বর পাওয়া যায়নি',
          'step1_already_submitted': 'আপনার তথ্য ইতিমধ্যে জমা হয়েছে',
          'step1_check_failed': 'সাবমিশন যাচাই করা যায়নি। অনুগ্রহ করে আবার চেষ্টা করুন।',
          'step1_verify_first': 'অনুগ্রহ করে প্রথমে উপরে যাচাই করুন চাপুন',

          // Step 2 - Parent Info
          'step2_title': 'অভিভাবক তথ্য',
          'step2_subtitle': 'বাবা ও মায়ের তথ্য প্রবেশ করুন',
          'step2_father_hint': 'বাবার নাম',
          'step2_mother_hint': 'মায়ের নাম',

          // Step 3 - Identity
          'step3_title': 'পরিচয়পত্র',
          'step3_subtitle': 'আপনার জাতীয় পরিচয় পত্র অথবা জন্ম নিবন্ধনের তথ্য দিন',
          'step3_birth_cert': 'জন্ম নিবন্ধন',
          'step3_nid': 'জাতীয় পরিচয়পত্র',
          'step3_bc_hint': '১৭ অঙ্কের জন্ম নিবন্ধন নম্বর',
          'step3_nid_hint': '১০ অঙ্কের জাতীয় পরিচয়পত্র নম্বর',

          // Step 4 - SSC
          'step4_title': 'এসএসসি তথ্য',
          'step4_subtitle': 'নিচের বক্সগুলোতে সতর্কভাবে আপনার এসএসসি পরীক্ষার তথ্য দিন',
          'step4_roll_hint': 'এসএসসি রোল নম্বর',
          'step4_reg_hint': 'রেজিস্ট্রেশন নম্বর',
          'step4_board_hint': 'বোর্ড নির্বাচন করুন',
          'step4_year_hint': 'পাসের সাল',
          'step4_gpa_hint': 'জিপিএ (০.০০ - ৫.০০)',
          'step4_hsc_complete': 'এইচএসসি সম্পন্ন',
          'step4_hsc_complete_hint': 'এইচএসসি তথ্য বাদ দিতে আনচেক করুন',

          // Step 5 - HSC
          'step5_title': 'এইচএসসি তথ্য',
          'step5_subtitle': 'আপনার এইচএসসি পরীক্ষার তথ্য প্রবেশ করুন',
          'step5_roll_hint': 'এইচএসসি রোল নম্বর',
          'step5_reg_hint': 'রেজিস্ট্রেশন নম্বর',
          'step5_board_hint': 'বোর্ড নির্বাচন করুন',
          'step5_year_hint': 'পাসের সাল',
          'step5_gpa_hint': 'জিপিএ (০.০০ - ৫.০০)',

          // Step 6 - Upload & Submit
          'step6_title': 'ছবি ও জমা',
          'step6_subtitle': 'আপনার ছবি আপলোড করুন এবং ফর্ম জমা দিন',
          'step6_upload_hint': 'ছবি আপলোড করতে ট্যাপ করুন (ঐচ্ছিক)',
          'step6_upload_subtext': 'জেপিজেপি/পিএনজি, সর্বোচ্চ ৫এমবি',
          'step6_change_photo': 'ছবি পরিবর্তন',
          'step6_remove_photo': 'সরান',
          'step6_submit_button': 'আবেদন জমা দিন',
          'step6_confirm_title': 'জমা নিশ্চিত করুন',
          'step6_confirm_message': 'আপনি কি জমা দিতে চান? জমা দেওয়ার আগে আপনার তথ্য পর্যালোচনা করুন।',

          // Success
          'success_title_bn': 'সফলভাবে জমা হয়েছে!',
          'success_title': 'Successfully Submitted!',
          'success_ref_label': 'আপনার রেফারেন্স নম্বর',
          'success_save_hint': 'অনুগ্রহ করে এই রেফারেন্স নম্বর সংরক্ষণ করুন',
          'success_home_button': 'হোমে ফিরুন / Back to Home',

          // Validation
          'val_roll_required': 'রোল নম্বর আবশ্যক',
          'val_roll_numeric': 'রোল নম্বর শুধু সংখ্যা হতে হবে',
          'val_name_required': 'নাম আবশ্যক',
          'val_name_min': 'নাম কমপক্ষে ২ অক্ষর হতে হবে',
          'val_father_required': 'বাবার নাম আবশ্যক',
          'val_mother_required': 'মায়ের নাম আবশ্যক',
          'val_bc_required': 'জন্ম নিবন্ধন নম্বর আবশ্যক',
          'val_bc_digits': 'একদম ১৭ অঙ্ক হতে হবে',
          'val_nid_required': 'জাতীয় পরিচয়পত্র নম্বর আবশ্যক',
          'val_nid_digits': 'একদম ১০ অঙ্ক হতে হবে',
          'val_roll_digits': 'শুধু সংখ্যা হতে হবে',
          'val_reg_required': 'রেজিস্ট্রেশন নম্বর আবশ্যক',
          'val_board_required': 'বোর্ড আবশ্যক',
          'val_year_required': 'পাসের সাল আবশ্যক',
          'val_year_invalid': 'সাল ১৯৯০ থেকে ২০২৮ এর মধ্যে হতে হবে',
          'val_gpa_required': 'জিপিএ আবশ্যক',
          'val_gpa_invalid': 'জিপিএ ০.০০ থেকে ৫.০০ এর মধ্যে হতে হবে',

          // Network
          'no_connection': 'ইন্টারনেট সংযোগ নেই',
          'try_again': 'আবার চেষ্টা করুন',
          'val_required': 'সব ক্ষেত্র আবশ্যক',
          'error_message': 'একটি ত্রুটি ঘটেছে। অনুগ্রহ করে আবার চেষ্টা করুন।',
        },
      };
}
