unit NotPerformedDocumentsReportFastReportPresenter;

interface

uses

  SysUtils,
  Classes,
  frxClass,
  frxDesgn,
  frxDBSet,
  NotPerformedDocumentsReportData,
  NotPerformedDocumentsReportPresenter;

type

  TNotPerformedDocumentsReportFastReportPresenter =
    class (TInterfacedObject, INotPerformedDocumentsReportPresenter)

      protected

        procedure LoadReportTemplate(Report: TfrxReport);
        function InternalLoadReportTemplate(Report: TfrxReport): Boolean; virtual;

        procedure SetReportVariableValues(
          Report: TfrxReport;
          ReportData: TNotPerformedDocumentsReportData
        ); virtual;

        procedure SetReportDataSetFieldNames(
          Report: TfrxReport;
          DataSet: TfrxDBDataset;
          FieldDefs: TNotPerformedDocumentSetFieldDefs
        ); virtual;

        function CreateReportDataSetFieldNameFor(
          ReportDataSet: TfrxDBDataset;
          const FieldName: String
        ): String;
        
      public

        procedure PresentReportBy(
          NotPerformedDocumentsReportData: TNotPerformedDocumentsReportData
        );

    end;

implementation

uses

  AuxDebugFunctionsUnit,
  AuxWindowsFunctionsUnit,
  Forms,
  DateUtils,
  frxNotPerformedDocumentsReportObjectsUnit;

{ TNotPerformedDocumentsReportFastReportPresenter }

function TNotPerformedDocumentsReportFastReportPresenter.InternalLoadReportTemplate(
  Report: TfrxReport): Boolean;
begin

  Result := Report.LoadFromFile('NotPerformedDocumentsReport.fr3');
  
end;

procedure TNotPerformedDocumentsReportFastReportPresenter.LoadReportTemplate(
  Report: TfrxReport
);
begin

  if not InternalLoadReportTemplate(Report) then begin

    raise TNotPerformedDocumentsReportPresenterException.Create(
      'Программная ошибка. Не удалось загрузить шаблон отчёта ' +
      'о не выполненных документах'
    );
    
  end;

end;

procedure TNotPerformedDocumentsReportFastReportPresenter.PresentReportBy(
  NotPerformedDocumentsReportData: TNotPerformedDocumentsReportData
);
var frxNotPerformedDocumentsReportObjects:
      TfrxNotPerformedDocumentsReportObjects;
begin

  if NotPerformedDocumentsReportData.ReportDataSetHolder.IsEmpty then begin

    ShowInfoMessage(
      Application.Handle,
      Format(
        'За период с %s по %s ' +
        'не выполненные документы ' +
        'не найдены',
        [
          DateToStr(NotPerformedDocumentsReportData.PeriodStart),
          DateToStr(NotPerformedDocumentsReportData.PeriodEnd)
        ]
      ),
      'Сообщение'
    );

    Exit;

  end;

  frxNotPerformedDocumentsReportObjects :=
    TfrxNotPerformedDocumentsReportObjects.Create(nil);

  try

    with frxNotPerformedDocumentsReportObjects do begin

      LoadReportTemplate(NotPerformedDocumentsReport);

      SetReportVariableValues(NotPerformedDocumentsReport, NotPerformedDocumentsReportData);

      SetReportDataSetFieldNames(
        NotPerformedDocumentsReport,
        NotPerformedDocumentsReportDataSet,
        NotPerformedDocumentsReportData.ReportDataSetHolder.FieldDefs
      );

      NotPerformedDocumentsDataSource.DataSet :=
        NotPerformedDocumentsReportData.ReportDataSetHolder.DataSet;

      NotPerformedDocumentsReport.ShowReport;

    end;

  finally

    FreeAndNil(frxNotPerformedDocumentsReportObjects);
    
  end;

end;

procedure TNotPerformedDocumentsReportFastReportPresenter.SetReportVariableValues(
  Report: TfrxReport; ReportData: TNotPerformedDocumentsReportData);
begin

  Report.Variables['PeriodStart'] := DateOf(ReportData.PeriodStart);
  Report.Variables['PeriodEnd'] := DateOf(ReportData.PeriodEnd);

  Report.Variables['ReportCreationDepartment'] :=
    '''' +
    ReportData.ReportCreationDepartment +
    '''';

  Report.Variables['NotPerformedDocumentCount'] :=
    ReportData.NotPerformedDocumentCount;

end;

procedure TNotPerformedDocumentsReportFastReportPresenter.SetReportDataSetFieldNames(
  Report: TfrxReport;
  DataSet: TfrxDBDataset;
  FieldDefs: TNotPerformedDocumentSetFieldDefs
);
var
    FieldMemo: TfrxMemoView;
begin

  with FieldDefs do begin

    FieldMemo := Report.FindObject('NumberMemo') as TfrxMemoView;

    FieldMemo.Text := CreateReportDataSetFieldNameFor(DataSet, NumberFieldName);

    FieldMemo := Report.FindObject('CreationDateMemo') as TfrxMemoView;

    FieldMemo.Text := CreateReportDataSetFieldNameFor(DataSet, CreationDateFieldName);

    FieldMemo := Report.FindObject('NameMemo') as TfrxMemoView;

    FieldMemo.Text := CreateReportDataSetFieldNameFor(DataSet, NameFieldName);

    FieldMemo := Report.FindObject('LeaderNameMemo') as TfrxMemoView;

    FieldMemo.Text := CreateReportDataSetFieldNameFor(DataSet, LeaderShortNameFieldName);

    FieldMemo := Report.FindObject('PerformerNamesMemo') as TfrxMemoView;

    FieldMemo.Text := CreateReportDataSetFieldNameFor(DataSet, PerformerShortNamesFieldName);
    
  end;

end;

function TNotPerformedDocumentsReportFastReportPresenter.
  CreateReportDataSetFieldNameFor(
    ReportDataSet: TfrxDBDataset;
    const FieldName: String
  ): String;
begin

  Result := '[' + ReportDataSet.UserName + '."' + FieldName + '"]';

end;

end.
