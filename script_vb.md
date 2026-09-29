# Excel VB Uploader — students sheet only

Sends one student per request to the same backend as the Flutter web app.
Target: `students!A=phone, B=name`. Never touches `submissions` or Drive.

## Setup
1. Sheet name must be `students`, row 1 header, data from row 2.
2. Format column A as Text (Format > Text) before typing `017...`.
3. In Excel: `Alt+F11 > Insert > Module`, paste the code below.
4. Set `APPS_URL` to the same `/exec` URL as `AppConstants.appsScriptUrl`.
5. `Run > UploadStudents`. One POST per row. Result written in column C.

## Code (Module1.bas)
```vba
Option Explicit
Const APPS_URL As String = "https://script.google.com/macros/s/AKfycbzyIv8TCgyW85LKHFqyrIFPsBvw6fJsMiiUf78_tZUccW74jyyLVO2iIudTp9_18OftZQ/exec"

Sub UploadStudents()
    Dim ws As Worksheet: Set ws = ThisWorkbook.Sheets("students")
    Dim last As Long: last = ws.Cells(ws.Rows.Count, 1).End(xlUp).Row
    Dim i As Long
    For i = 2 To last
        Dim ph As String: ph = Trim$(ws.Cells(i, 1).Text)
        Dim nm As String: nm = Trim$(ws.Cells(i, 2).Value)
        If ph = "" Or nm = "" Then
            ws.Cells(i, 3).Value = "SKIP"
        Else
            Dim json As String
            json = "{""action"":""addStudents"",""data"":[[""" & Esc(ph) & """,""" & Esc(nm) & """]]}"
            Dim resp As String: resp = PostJson(json)
            Debug.Print "row " & i & ": " & resp
            ws.Cells(i, 3).Value = ParseResult(resp)
        End If
    Next i
    MsgBox "Done, " & (last - 1) & " hit(s). See column C.", vbInformation
End Sub

Private Function PostJson(p As String) As String
    Dim h As Object: Set h = CreateObject("MSXML2.XMLHTTP.60")
    h.Open "POST", APPS_URL, False
    h.setRequestHeader "Content-Type", "text/plain"
    h.send p
    PostJson = h.responseText
End Function

Private Function ParseResult(resp As String) As String
    If InStr(1, resp, """added"":1") > 0 Then ParseResult = "OK"
    ElseIf InStr(1, resp, """added"":0") > 0 Then ParseResult = "DUPLICATE"
    Else ParseResult = "FAIL"
    End If
End Function

Private Function Esc(s As String) As String
    Esc = Replace(Replace(Replace(s, "\", "\\"), """", "\"""), vbLf, "")
    Esc = Replace(Esc, vbCr, "")
End Function
```
