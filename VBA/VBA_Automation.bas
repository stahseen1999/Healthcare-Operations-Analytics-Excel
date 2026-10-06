Attribute VB_Name = "Module1"
Option Explicit


Sub RefreshAndExportDashboard()

    Dim ws As Worksheet
    Dim pt As PivotTable
    Dim exportPath As String

    On Error GoTo CleanFail

    Application.ScreenUpdating = False
    Application.EnableEvents = False
    Application.DisplayAlerts = False

    'Refresh workbook data and queries
    ThisWorkbook.RefreshAll

    'Refresh PivotTables
    For Each ws In ThisWorkbook.Worksheets
        For Each pt In ws.PivotTables
            pt.RefreshTable
        Next pt
    Next ws

    'Update refresh timestamp
    With ThisWorkbook.Worksheets("Dashboard")
        .Range("B30").Value = "Last refreshed:"
        .Range("C30").Value = Now
        .Range("C30").NumberFormat = "dd-mmm-yyyy hh:mm"
    End With

    'Export Dashboard to PDF
    exportPath = ThisWorkbook.Path & Application.PathSeparator & _
                 "Healthcare_Dashboard_" & Format(Now, "yyyymmdd_hhmm") & ".pdf"

    ThisWorkbook.Worksheets("Dashboard").ExportAsFixedFormat _
        Type:=xlTypePDF, _
        Filename:=exportPath, _
        Quality:=xlQualityStandard, _
        IncludeDocProperties:=True, _
        IgnorePrintAreas:=False, _
        OpenAfterPublish:=False

CleanExit:

    Application.DisplayAlerts = True
    Application.EnableEvents = True
    Application.ScreenUpdating = True

    If Err.Number = 0 Then
        MsgBox "Dashboard refreshed and exported successfully.", _
               vbInformation, "Healthcare Analytics"
    End If

    Exit Sub

CleanFail:

    MsgBox "Dashboard refresh failed:" & vbCrLf & _
           Err.Description, vbExclamation, "Healthcare Analytics"

    Resume CleanExit

End Sub


Sub ResetAllFilters()

    Dim sc As SlicerCache

    Application.ScreenUpdating = False

    For Each sc In ThisWorkbook.SlicerCaches
        On Error Resume Next
        sc.ClearManualFilter
        On Error GoTo 0
    Next sc

    Application.ScreenUpdating = True

    MsgBox "All dashboard filters have been reset.", _
           vbInformation, "Healthcare Analytics"

End Sub
