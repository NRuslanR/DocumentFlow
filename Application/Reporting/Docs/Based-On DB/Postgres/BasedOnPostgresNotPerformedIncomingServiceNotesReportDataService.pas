unit BasedOnPostgresNotPerformedIncomingServiceNotesReportDataService;

interface

uses

  BasedOnDBNotPerformedIncomingDocumentsReportDataService,
  NotPerformedDocumentsReportDataService,
  NotPerformedDocumentsReportData,
  NotPerformedIncomingDocumentsReportData,
  ZDataset,
  SysUtils,
  Classes;

type

  TBasedOnPostgresNotPerformedIncomingServiceNotesReportDataService =
    class (TBasedOnDBNotPerformedIncomingDocumentsReportDataService)

      protected                         

        function CreateFetchingNotPerformedDocumentInfosQuery(
          const EmployeeId: Variant;
          const DepartmentId: Variant;
          const PeriodStart: TDateTime;
          const PeriodEnd: TDateTime;
          ReportFieldDefs: TNotPerformedDocumentSetFieldDefs
        ): String; override;

    end;

implementation

uses

  Variants,
  DateUtils,
  StrUtils,
  BasedOnDBNotPerformedDocumentsReportDataService;

{ TBasedOnPostgresNotPerformedIncomingServiceNotesReportDataService }

function TBasedOnPostgresNotPerformedIncomingServiceNotesReportDataService.
  CreateFetchingNotPerformedDocumentInfosQuery(
    const EmployeeId: Variant;
    const DepartmentId: Variant;
    const PeriodStart: TDateTime;
    const PeriodEnd: TDateTime;
    ReportFieldDefs: TNotPerformedDocumentSetFieldDefs
  ): String;
begin

    Result :=
      Format(
        'SELECT ' +
        '* ' +
        'FROM doc.get_not_performed_incoming_service_notes_report_data_for(%s,%s,%s,%s) ' +
        'ORDER BY %s',
        [
          VarToStr(EmployeeId),
          VarToStr(DepartmentId),

          IfThen(
            PeriodStart <> 0,
            QuotedStr(FormatDateTime('yyyy-MM-dd', PeriodStart)),
            'NULL'
          ),

          IfThen(
            PeriodEnd <> 0,
            QuotedStr(FormatDateTime('yyyy-MM-dd', PeriodEnd)),
            'NULL'
          ),

          ReportFieldDefs.CreationDateFieldName
        ]
      );

end;

end.
