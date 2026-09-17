# Google Apps Script

> **IMPORTANT:** In the Apps Script editor, go to **Services** (left sidebar, cube icon) > **Add a service** > add **Drive API**. Then redeploy.

## Configuration
```javascript
const SHEET_ID = '1sFvESG2YhyIuECLpMD6xr9lo7RrYFVMIrm4C-TmB8E8';
const DRIVE_FOLDER_ID = '1cxcUVOi9LHuK9MBFMiYWUGHMtBtENC-9';
```

## GET Handler
```javascript
function doGet(e) {
  try {
    const action = e.parameter.action;

    switch (action) {
      case 'getStudents':
        return jsonResponse(getStudents());
      case 'checkSubmission':
        return jsonResponse(checkSubmission(e.parameter.roll));
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
```

## POST Handler
```javascript
function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);

    switch (data.action) {
      case 'getStudents':
        return jsonResponse(getStudents());
      case 'checkSubmission':
        return jsonResponse(checkSubmission(data.roll));
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
```

## Functions
```javascript
// GET: Read student list (Roll -> Name)
function getStudents() {
  const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName('students');
  const data = sheet.getDataRange().getValues();
  const rows = data.slice(1).map(row => [row[0].toString(), row[1].toString()]);
  return { success: true, data: rows };
}

// Check if a roll number already has a submission
function checkSubmission(rollNumber) {
  if (!rollNumber) {
    return { success: false, error: 'Roll number is required' };
  }
  const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName('submissions');
  const data = sheet.getDataRange().getValues();
  // submissions sheet: column B (index 1) = rollNumber (from toSheetRow)
  const exists = data.slice(1).some(row => row[1].toString().trim() === rollNumber.trim());
  return { success: true, exists: exists };
}

// Append submission row (with server-side duplicate guard)
// submissions sheet: column B (index 1) = rollNumber (from toSheetRow)
function appendSubmission(rowData) {
  const rollNumber = rowData[1].toString().trim();
  if (checkSubmission(rollNumber).exists) {
    return { success: false, error: 'already_submitted' };
  }
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

// JSON response helper
function jsonResponse(data) {
  return ContentService.createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);
}
```
