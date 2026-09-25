// # Google Apps Script

// > **IMPORTANT:** In the Apps Script editor, go to **Services** (left sidebar, cube icon) > **Add a service** > add **Drive API**. Then redeploy.

// ## Configuration
// ```javascript
const SHEET_ID = '1sFvESG2YhyIuECLpMD6xr9lo7RrYFVMIrm4C-TmB8E8';
const DRIVE_FOLDER_ID = '1cxcUVOi9LHuK9MBFMiYWUGHMtBtENC-9';
// ```

// ## GET Handler
// ```javascript
function doGet(e) {
  try {
    const action = e.parameter.action;

    switch (action) {
      case 'getStudents':
        return jsonResponse(getStudents());
      case 'checkSubmission':
        return jsonResponse(checkSubmission(e.parameter.roll));
      case 'verify':
        return jsonResponse(verify(e.parameter.roll));
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
// ```

// POST Handler
// javascript
function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);

    switch (data.action) {
      case 'getStudents':
        return jsonResponse(getStudents());
      case 'checkSubmission':
        return jsonResponse(checkSubmission(data.roll));
      case 'verify':
        return jsonResponse(verify(data.roll));
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
// ``

// ## Functions
// ```javascript
// GET: Read student list (Roll -> Name)
// No slice(1): sheets may start with data in row 1. Header/empty rows are
// filtered out instead (col A must contain a digit).
function getStudents() {
  const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName('students');
  const data = sheet.getDataRange().getValues();
  const rows = data
    .filter(row => row[0] !== undefined && row[0] !== null && /\d/.test(row[0].toString()))
    .map(row => [row[0].toString(), (row[1] || '').toString()]);
  return { success: true, data: rows };
}

// Check if a roll number already has a submission
// Normalized compare: Sheets may coerce an appended "017..." to a number
// and drop the leading zero, so exact string matching would miss it.
function normRoll(v) {
  var s = (v === undefined || v === null) ? '' : v.toString();
  var d = s.replace(/\D/g, '').replace(/^0+/, '');
  if (d.indexOf('880') === 0) d = d.substring(3);
  return d;
}
function checkSubmission(rollNumber) {
  if (!rollNumber) {
    return { success: false, error: 'Roll number is required' };
  }
  const want = normRoll(rollNumber);
  const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName('submissions');
  const data = sheet.getDataRange().getValues();
  // No slice(1): the sheet may start with data in row 1. Header text
  // normalizes to '' and can never equal a real number, so it is ignored.
  // submissions sheet: column B (index 1) = rollNumber (from toSheetRow)
  const exists = data.some(row => normRoll(row[1]) !== '' && normRoll(row[1]) === want);
  return { success: true, exists: exists };
}

// Combined roster + submission check in ONE execution: half the latency
// of two separate calls (one cold start instead of two).
function verify(rollNumber) {
  if (!rollNumber) {
    return { success: false, error: 'Roll number is required' };
  }
  const want = normRoll(rollNumber);
  const sheet = SpreadsheetApp.openById(SHEET_ID).getSheetByName('students');
  const data = sheet.getDataRange().getValues();
  let student = null;
  for (let i = 0; i < data.length; i++) {
    const r0 = data[i][0];
    if (r0 !== undefined && r0 !== null && normRoll(r0) !== '' && normRoll(r0) === want) {
      const r1 = data[i][1];
      student = [r0.toString(), (r1 === undefined || r1 === null) ? '' : r1.toString()];
      break;
    }
  }
  const sub = checkSubmission(rollNumber);
  return { success: true, student: student, exists: sub.exists === true };
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
//```
