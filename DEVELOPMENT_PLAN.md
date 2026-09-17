# NTC Student Admission Portal - Development Plan

## Project Overview
**Platform**: Flutter Web & Mobile (Android/iOS)
**Architecture**: MVC with GetX State Management
**Backend**: Google Apps Script (Web App) — handles Sheets read/write + Drive upload
**Language**: Bilingual - English & Bengali (GetX Translations)
**Design**: Material 3, Modern, Minimalistic, Gradient Theme (Red, Black, Blue, Yellow, Green)
**Network**: Online only

---

## 1. Responsive Breakpoints (4 Breakpoints)

| Breakpoint | Width Range | Target Devices |
|------------|-------------|----------------|
| **Mobile** | < 600px | Phones (portrait) |
| **Tablet** | 600px - 900px | Tablets, Large phones (landscape) |
| **Desktop** | 900px - 1200px | Laptops, Small desktops |
| **Large Desktop** | > 1200px | Large monitors, Wide screens |

**Implementation**: Custom `ResponsiveBuilder` widget using `LayoutBuilder` + `MediaQuery`

---

## 2. Application Flow (6 Steps)

### Step 1: Roll Number Verification
- Input: Roll Number (provided at admission)
- Action: GET request to Google Sheets API (look up roll in student list tab)
- Output: Display full name (read-only)
- Validation: Required, numeric, exists in database

### Step 2: Parent Information
- Fields: Father's Name, Mother's Name
- Validation: Required, text only, max 100 chars

### Step 3: Identity Document
- Radio Group: Birth Certificate (জন্ম নিবন্ধন) / NID (জাতীয় পরিচয়পত্র)
- Input: Dynamic based on selection
- Validation: Required, exact digit count, numeric

### Step 4: SSC Information
- Fields: SSC Roll, Registration Number, Board (dropdown), Passing Year, GPA
- Validation: All required, GPA 0.00-5.00, Year 4 digits

### Step 5: HSC Information
- Fields: HSC Roll, Registration Number, Board (dropdown), Passing Year, GPA
- Validation: Same as SSC

### Step 6: Image Upload & Submit
- Optional: Profile photo upload (max 5MB, JPG/PNG)
- Image saved as `{roll_number}.jpg` in Google Drive
- Submit button: Saves all data to Google Sheets
- Success: Confirmation dialog with reference number

---

## 3. Google Sheets Structure

### Tab 1: "students" (Roll → Name lookup, pre-populated)
| Column | Field |
|--------|-------|
| A | Roll Number |
| B | Full Name |

### Tab 2: "submissions" (All form data, app appends rows)
| Column | Field |
|--------|-------|
| A | Reference Number |
| B | Roll Number |
| C | Full Name |
| D | Father Name |
| E | Mother Name |
| F | Document Type (BC/NID) |
| G | Document Number |
| H | SSC Roll |
| I | SSC Reg No |
| J | SSC Board |
| K | SSC Year |
| L | SSC GPA |
| M | HSC Roll |
| N | HSC Reg No |
| O | HSC Board |
| P | HSC Year |
| Q | HSC GPA |
| R | Image URL (Google Drive link) |
| S | Submitted At |
| T | Language (EN/BN) |

---

## 4. Backend Integration (Google Apps Script - Sole Backend)

### Setup: Single Google Apps Script handles ALL operations
- **Read**: Look up student roll → name from Google Sheet
- **Write**: Append submission data to Google Sheet
- **Upload**: Save student photo to Google Drive

### Why Apps Script only (no API key)?
- No Google Cloud project needed
- No API key / service account setup
- Apps Script has built-in access to Sheets + Drive
- Deploy as Web App → anyone can call it via HTTP POST

### API Contract

**Request:**
```
POST https://script.google.com/macros/s/{DEPLOYMENT_ID}/exec
Content-Type: application/json
```

**Action: getStudents** (Step 1 - Roll verification)
```json
{ "action": "getStudents" }
Response: { "success": true, "data": [["12345","John Doe"], ...] }
```

**Action: appendSubmission** (Step 6 - Submit form)
```json
{
  "action": "appendSubmission",
  "data": ["NTC-12345-20260917", "12345", "John Doe", ...]
}
Response: { "success": true }
```

**Action: uploadImage** (Step 6 - Upload photo)
```json
{
  "action": "uploadImage",
  "image": "<base64>",
  "rollNumber": "12345",
  "folderId": "<DRIVE_FOLDER_ID>"
}
Response: { "success": true, "url": "https://drive.google.com/file/d/..." }
```

### Data Flow
```
Step 1: POST { action: "getStudents" } → find roll → display name
Steps 2-5: Local form state (no API calls)
Step 6: [Optional] POST { action: "uploadImage" } → image saved as {roll}.jpg → get URL
         POST { action: "appendSubmission" } → save all data
         Generate reference number (NTC-{ROLL}-{TIMESTAMP})
```

---

## 5. Bilingual Support (English + Bengali)

### Package: `GetX` Translations
### Implementation
```dart
// lib/translations/app_translations.dart
class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'step1_title': 'Roll Verification',
      'step1_subtitle': 'Enter your roll number',
      'step1_roll_hint': 'Enter Roll Number',
      'step1_name_label': 'Full Name',
      'btn_next': 'Next',
      'btn_back': 'Back',
      'btn_submit': 'Submit',
      'validation_roll_required': 'Roll number is required',
      // ... all English strings
    },
    'bn_BD': {
      'step1_title': 'রোল যাচাই',
      'step1_subtitle': 'আপনার রোল নম্বর প্রবেশ করুন',
      'step1_roll_hint': 'রোল নম্বর প্রবেশ করুন',
      'step1_name_label': 'পূর্ণ নাম',
      'btn_next': 'পরবর্তী',
      'btn_back': 'পূর্ববর্তী',
      'btn_submit': 'জমা দিন',
      'validation_roll_required': 'রূল নম্বর আবশ্যক',
      // ... all Bengali strings
    },
  };
}
```

### Files
```
lib/
  translations/
    app_translations.dart     # All translation keys
    locale_constants.dart     # Supported locales
  presentation/
    controllers/
      language_controller.dart  # Toggle EN↔BN, persists to SharedPreferences
```

### Language Toggle Widget
- AppBar flag/icon toggle (🇧🇩 / 🇬🇧)
- Default: Bengali (primary audience)
- Persisted to SharedPreferences

---

## 6. Project Structure (MVC + GetX)

```
lib/
├── main.dart                         # App entry point
├── app/
│   ├── routes/
│   │   ├── app_pages.dart            # Route definitions
│   │   └── app_routes.dart           # Route name constants
│   ├── theme/
│   │   ├── app_colors.dart           # Color palette + gradients
│   │   ├── app_theme.dart            # ThemeData (light/dark)
│   │   └── app_text_styles.dart      # Typography system
│   ├── translations/
│   │   └── app_translations.dart     # EN + BN translation keys
│   └── utils/
│       ├── responsive.dart           # Breakpoint helpers
│       ├── validators.dart           # Form validation functions
│       ├── constants.dart            # Sheet ID, API key, URLs
│       └── helpers.dart              # Utility functions
├── data/
│   ├── models/
│   │   ├── student_model.dart        # Roll + full name
│   │   ├── parent_model.dart         # Father + mother name
│   │   ├── identity_model.dart       # Doc type + number
│   │   ├── ssc_model.dart            # SSC details
│   │   ├── hsc_model.dart            # HSC details
│   │   └── admission_model.dart      # Complete form (aggregates all)
│   ├── repositories/
│   │   └── admission_repository.dart # Handles Sheets read/write
│   └── services/
│       ├── google_sheets_service.dart # HTTP calls to Sheets API
│       └── google_drive_service.dart  # HTTP calls to Apps Script
├── presentation/
│   ├── controllers/
│   │   ├── admission_controller.dart  # Main flow orchestrator
│   │   ├── step1_controller.dart      # Roll verification logic
│   │   ├── step2_controller.dart      # Parent info form
│   │   ├── step3_controller.dart      # Identity document form
│   │   ├── step4_controller.dart      # SSC info form
│   │   ├── step5_controller.dart      # HSC info form
│   │   ├── step6_controller.dart      # Upload + submit logic
│   │   └── language_controller.dart   # EN/BN toggle
│   ├── views/
│   │   ├── admission_flow_page.dart   # Main flow wrapper
│   │   ├── landing_page.dart          # Initial landing screen
│   │   ├── success_page.dart          # Submission success screen
│   │   ├── steps/
│   │   │   ├── step1_roll_verification.dart
│   │   │   ├── step2_parent_info.dart
│   │   │   ├── step3_identity_doc.dart
│   │   │   ├── step4_ssc_info.dart
│   │   │   ├── step5_hsc_info.dart
│   │   │   └── step6_upload_submit.dart
│   │   ├── widgets/
│   │   │   ├── progress_stepper.dart     # Horizontal/vertical stepper
│   │   │   ├── custom_text_field.dart    # Gradient-bordered input
│   │   │   ├── custom_dropdown.dart      # Custom dropdown
│   │   │   ├── custom_radio_group.dart   # Radio with custom styling
│   │   │   ├── gradient_button.dart      # Gradient-filled button
│   │   │   ├── image_upload_widget.dart  # Camera/gallery picker
│   │   │   ├── responsive_layout.dart    # LayoutBuilder wrapper
│   │   │   ├── language_toggle.dart      # EN/BN switch
│   │   │   └── step_header.dart          # Title + subtitle per step
│   │   └── common/
│   │       ├── app_bar.dart              # NTC branded AppBar
│   │       ├── loading_overlay.dart      # Full-screen loading
│   │       ├── error_dialog.dart         # Error alert
│   │       └── success_dialog.dart       # Success confirmation
│   └── bindings/
│       └── admission_binding.dart        # GetX DI for admission flow
└── core/
    └── di/
        └── initial_binding.dart          # App-wide DI
```

---

## 7. Theme & Design System

### Color Palette
```dart
// === Brand Colors ===
static const Color ntcRed       = Color(0xFFE53935);   // Primary action
static const Color ntcBlack     = Color(0xFF1A1A1A);   // Text, AppBar
static const Color ntcBlue      = Color(0xFF1E88E5);   // Links, info
static const Color ntcYellow    = Color(0xFFFDD835);   // Warning, accent
static const Color ntcGreen     = Color(0xFF43A047);   // Success

// === Gradients ===
static const LinearGradient primaryGradient = LinearGradient(
  colors: [ntcRed, ntcBlue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
static const LinearGradient headerGradient = LinearGradient(
  colors: [ntcBlack, Color(0xFF2D2D2D), ntcBlue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
static const LinearGradient successGradient = LinearGradient(
  colors: [ntcGreen, ntcBlue],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
static const LinearGradient buttonGradient = LinearGradient(
  colors: [ntcRed, Color(0xFFFF6F00)],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

// === Surfaces ===
static const Color backgroundLight = Color(0xFFF5F5F5);
static const Color cardWhite       = Color(0xFFFFFFFF);
static const Color inputBorder     = Color(0xFFE0E0E0);
static const Color inputFocus      = ntcBlue;
static const Color textPrimary     = Color(0xFF212121);
static const Color textSecondary   = Color(0xFF757575);
static const Color errorColor      = ntcRed;
```

### Typography
- **Headlines**: Poppins SemiBold/Bold (EN), Noto Sans Bengali (BN)
- **Body**: Inter Regular/Medium (EN), Noto Sans Bengali (BN)
- **Caption**: Inter Regular

### Component Style
- **Cards**: White, elevation 2, border-radius 16px
- **Buttons**: Gradient fill, border-radius 12px, padding 16x32
- **Inputs**: Outlined border, floating label, focus glow (blue)
- **Stepper**: Horizontal on desktop, vertical on mobile

---

## 8. GetX State Management

### Main Controller
```dart
class AdmissionController extends GetxController {
  final currentStep = 0.obs;
  final isLoading = false.obs;
  final formData = AdmissionModel().obs;
  final studentName = ''.obs;
  
  void nextStep() => currentStep.value++;
  void previousStep() => currentStep.value--;
  Future<void> verifyRoll(String roll) async { ... }
  Future<void> submitForm() async { ... }
}
```

### Dependency Injection
```dart
// initial_binding.dart
Get.lazyPut<LanguageController>(() => LanguageController());
Get.lazyPut<GoogleSheetsService>(() => GoogleSheetsService());
Get.lazyPut<GoogleDriveService>(() => GoogleDriveService());
Get.lazyPut<AdmissionRepository>(() => AdmissionRepository(Get.find(), Get.find()));
Get.lazyPut<AdmissionController>(() => AdmissionController(Get.find()));
```

---

## 9. Validation Rules

| Field | Validation |
|-------|------------|
| Roll Number | Required, numeric, 1-20 chars, must exist in sheet |
| Father/Mother Name | Required, 2-100 chars |
| Document Number | Required, numeric, 17 digits (BC) or 10 digits (NID) |
| SSC/HSC Roll | Required, numeric |
| Registration No | Required, alphanumeric |
| Board | Required, dropdown (must select) |
| Passing Year | Required, 4 digits, 1990-2026 |
| GPA | Required, 0.00-5.00, up to 2 decimals |
| Image | Optional, max 5MB, JPG/PNG, saved as `{roll}.jpg` |

---

## 10. Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  get: ^4.6.6                    # State management, routing, translations
  http: ^1.2.0                   # HTTP client (Apps Script API calls)
  image_picker: ^1.0.7           # Camera/gallery image selection
  flutter_svg: ^2.0.9            # SVG icons
  intl: ^0.19.0                  # Date formatting
  uuid: ^4.3.3                   # Reference number generation
  shared_preferences: ^2.2.2     # Language persistence
  connectivity_plus: ^5.0.2      # Network check
  flutter_animate: ^4.5.0        # Page transitions + micro-animations
  google_fonts: ^6.1.0           # Poppins + Inter + Noto Sans Bengali
```

---

## 11. Implementation Phases

### Phase 1: Foundation
- [ ] Project setup with all dependencies
- [ ] Theme system (colors, gradients, typography, text styles)
- [ ] Responsive utilities and `ResponsiveBuilder` widget
- [ ] GetX initial binding and DI setup
- [ ] Routing configuration
- [ ] Translation setup (EN + BN keys)

### Phase 2: Data Layer
- [ ] Data models (Student, Parent, Identity, SSC, HSC, Admission)
- [ ] Google Sheets service (HTTP GET/PUT with API Key)
- [ ] Google Apps Script proxy (image upload to Drive)
- [ ] Admission repository (orchestrates services)
- [ ] Validation utilities

### Phase 3: UI Components
- [ ] Custom text field (gradient border, floating label)
- [ ] Custom dropdown (board selection)
- [ ] Custom radio group (BC/NID)
- [ ] Gradient button with loading state
- [ ] Progress stepper (horizontal + vertical)
- [ ] Image upload widget (camera/gallery, preview)
- [ ] Language toggle widget
- [ ] Step header widget (title + subtitle)
- [ ] Loading overlay
- [ ] Error/success dialogs
- [ ] Responsive layout wrapper

### Phase 4: Admission Flow Steps
- [ ] Step 1: Roll verification (API call, name display)
- [ ] Step 2: Parent information form
- [ ] Step 3: Identity document (radio + dynamic input)
- [ ] Step 4: SSC information form
- [ ] Step 5: HSC information form
- [ ] Step 6: Image upload + submit (API calls)
- [ ] Landing page
- [ ] Success page (reference number display)

### Phase 5: Integration & Polish
- [ ] End-to-end flow testing
- [ ] Google Sheets read/write testing
- [ ] Image upload testing
- [ ] Responsive testing on all 4 breakpoints
- [ ] Bengali/English toggle testing
- [ ] Animations (page transitions, button press)
- [ ] Error handling (network, validation, API errors)
- [ ] Performance optimization

### Phase 6: Deployment
- [ ] Web build (`flutter build web`)
- [ ] Android build (`flutter build apk`)
- [ ] iOS build (`flutter build ios`)
- [ ] Environment config (API keys, Sheet ID, Script URL)
- [ ] Google Apps Script deployment
- [ ] Google Sheet setup (tabs, sharing)

---

## 12. Google Apps Script (Complete Backend)

Go to [script.google.com](https://script.google.com) → New Project → Paste this:

```javascript
// === CONFIGURATION ===
const SHEET_ID = 'YOUR_GOOGLE_SHEET_ID_HERE';
const DRIVE_FOLDER_ID = 'YOUR_DRIVE_FOLDER_ID_HERE';

// GET handler (used by Flutter to avoid CORS issues)
function doGet(e) {
  try {
    const action = e.parameter.action;
    
    switch (action) {
      case 'getStudents':
        return jsonResponse(getStudents());
      case 'appendSubmission':
        const data = JSON.parse(e.parameter.data);
        return jsonResponse(appendSubmission(data));
      case 'uploadImage':
        return jsonResponse(uploadImage(e.parameter.image, e.parameter.rollNumber, e.parameter.folderId));
      default:
        return jsonResponse({ success: false, error: 'Unknown action' });
    }
  } catch (err) {
    return jsonResponse({ success: false, error: err.toString() });
  }
}

// POST handler (backup)
function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);
    
    switch (data.action) {
      case 'getStudents':
        return jsonResponse(getStudents());
      case 'appendSubmission':
        return jsonResponse(appendSubmission(data.data));
      case 'uploadImage':
        return jsonResponse(uploadImage(data.image, data.rollNumber, data.folderId));
      default:
        return jsonResponse({ success: false, error: 'Unknown action' });
    }
  } catch (err) {
    return jsonResponse({ success: false, error: err.toString() });
  }
}

// GET: Read student list (Roll -> Name)
function getStudents() {
  const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName('students');
  const data = sheet.getDataRange().getValues();
  const rows = data.slice(1).map(row => [row[0].toString(), row[1].toString()]);
  return { success: true, data: rows };
}

// Append submission row
function appendSubmission(rowData) {
  const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName('submissions');
  sheet.appendRow(rowData);
  return { success: true };
}

// Upload image to Google Drive as {rollNumber}.jpg
function uploadImage(base64Image, rollNumber, folderId) {
  const folder = DriveApp.getFolderById(folderId || DRIVE_FOLDER_ID);
  const filename = rollNumber + '.jpg';
  
  // Delete existing file if re-submitting
  const existing = folder.getFilesByName(filename);
  while (existing.hasNext()) {
    existing.next().setTrashed(true);
  }
  
  // Create new file
  const blob = Utilities.newBlob(
    Utilities.base64Decode(base64Image),
    'image/jpeg',
    filename
  );
  const file = folder.createFile(blob);
  file.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);
  
  const url = 'https://drive.google.com/uc?export=view&id=' + file.getId();
  return { success: true, url: url };
}

function jsonResponse(data) {
  return ContentService.createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);
}
```

### Setup Steps:
1. Replace `SHEET_ID` and `DRIVE_FOLDER_ID`
2. Deploy → **New deployment** → **Web app**
3. Execute as: **Me**
4. Who has access: **Anyone**
5. Click **Deploy** → Copy URL → Paste in `constants.dart` as `appsScriptUrl`

### Google Sheet Tabs Required:
- **Tab "students"**: Columns A (Roll), B (Name) — pre-populated with student data
- **Tab "submissions"**: All admission data — app appends rows here

---

## 13. File Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Controllers | `*_controller.dart` | `admission_controller.dart` |
| Views/Pages | `*_page.dart` | `step1_roll_verification_page.dart` |
| Widgets | `*_widget.dart` | `gradient_button_widget.dart` |
| Models | `*_model.dart` | `student_model.dart` |
| Repositories | `*_repository.dart` | `admission_repository.dart` |
| Services | `*_service.dart` | `google_sheets_service.dart` |
| Bindings | `*_binding.dart` | `admission_binding.dart` |
| Translations | `*_translations.dart` | `app_translations.dart` |

---

## 14. Success Criteria

- [ ] All 6 steps functional with validation
- [ ] Responsive on 4 breakpoints (Mobile, Tablet, Desktop, Large Desktop)
- [ ] Data persists to Google Sheets (read from "students", write to "submissions")
- [ ] Image uploads to Google Drive via Apps Script (saved as `{roll}.jpg`)
- [ ] Bilingual (English + Bengali) with toggle
- [ ] Reference number generated (NTC-{ROLL}-{TIMESTAMP})
- [ ] Theme consistent with gradient colors (red, black, blue, yellow, green)
- [ ] Smooth animations (60fps)
- [ ] Builds for Web, Android, iOS

---
*Version: 2.1 - Image naming as roll number applied*