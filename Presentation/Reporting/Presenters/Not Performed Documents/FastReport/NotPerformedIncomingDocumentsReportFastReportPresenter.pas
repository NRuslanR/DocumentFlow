unit NotPerformedIncomingDocumentsReportFastReportPresenter;

interface

uses

  NotPerformedDocumentsReportFastReportPresenter,
  NotPerformedDocumentsReportData,
  NotPerformedIncomingDocumentsReportData,
  frxClass,
  Forms,
  frxDBSet,
  SysUtils;

type

  TNotPerformedIncomingDocumentsReportFastReportPresenter =
    class (TNotPerformedDocumentsReportFastReportPresenter)

      protected

        function InternalLoadReportTemplate(Report: TfrxReport): Boolean; override;

        procedure SetReportVariableValues(
          Report: TfrxReport;
          ReportData: TNotPerformedDocumentsReportData
        ); override;

        procedure SetReportDataSetFieldNames(
          Report: TfrxReport;
          DataSet: TfrxDBDataset;
          FieldDefs: TNotPerformedDocumentSetFieldDefs
        ); override;
      
    end;

implementation

uses

  AuxWindowsFunctionsUnit;
  
{ TNotPerformedIncomingDocumentsReportFastReportPresenter }

function TNotPerformedIncomingDocumentsReportFastReportPresenter.
  InternalLoadReportTemplate(Report: TfrxReport): Boolean;
var
    ReportTemplatePath: String;
begin

  ReportTemplatePath :=
    ExtractFileDir(Application.ExeName) + PathDelim + 'NotPerformedIncomingDocumentsReport.fr3';

  if not FileExists(ReportTemplatePath) then begin

    ShowErrorMessage(
      Application.Handle,
      'Шаблон отчёта не найден или отсутствуют необходимые права доступа',
      'Ошибка'
    );

  end

  else Result := Report.LoadFromFile(ReportTemplatePath);

end;

procedure TNotPerformedIncomingDocumentsReportFastReportPresenter.SetReportDataSetFieldNames(
  Report: TfrxReport;
  DataSet: TfrxDBDataset;
  FieldDefs: TNotPerformedDocumentSetFieldDefs
);
var
    FieldMemo: TfrxMemoView;
begin

  inherited SetReportDataSetFieldNames(Report, DataSet, FieldDefs);

  with TNotPerformedIncomingDocumentSetFieldDefs(FieldDefs) do begin

    FieldMemo := Report.FindObject('IncomingNumberMemo') as TfrxMemoView;

    FieldMemo.Text := CreateReportDataSetFieldNameFor(DataSet, IncomingNumberFieldName);

    FieldMemo := Report.FindObject('ReceiptDateMemo') as TfrxMemoView;

    FieldMemo.Text := CreateReportDataSetFieldNameFor(DataSet, ReceiptDateFieldName);
    
  end;

end;

procedure TNotPerformedIncomingDocumentsReportFastReportPresenter.SetReportVariableValues(
  Report: TfrxReport;
  ReportData: TNotPerformedDocumentsReportData
);
begin

  inherited;

end;

end.
