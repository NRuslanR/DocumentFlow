unit DocumentApprovingSheetFastReportPresenter;

interface

uses

  DocumentApprovingSheetViewModel,
  DocumentApprovingSheetApprovingSetHolder,
  DocumentApprovingSheetPresenter,
  unFastReportApprovingSheetDataModule,
  frxClass,
  frxDBSet,
  SysUtils;

type

  TDocumentApprovingSheetFastReportPresenter =
    class (TInterfacedObject, IDocumentApprovingSheetPresenter)

      protected

        procedure FillApprovingSheetTitle(
          ApprovingSheetReport: TfrxReport;
          DocumentApprovingSheetViewModel: TDocumentApprovingSheetViewModel
        );

        procedure FillApprovingSheetApprovingSet(
          FastReportApprovingSheetDataModule: TFastReportApprovingSheetDataModule;
          ApprovingSetHolder: TDocumentApprovingSheetApprovingSetHolder
        );

      public

        procedure PresentDocumentApprovingSheet(
          DocumentApprovingSheetViewModel: TDocumentApprovingSheetViewModel
        );

    end;
  
implementation

uses

  StrUtils,
  AbstractDataSetHolder;

{ TDocumentApprovingSheetFastReportPresenter }

procedure TDocumentApprovingSheetFastReportPresenter.PresentDocumentApprovingSheet(
  DocumentApprovingSheetViewModel: TDocumentApprovingSheetViewModel
);
var
    FastReportApprovingSheetDataModule: TFastReportApprovingSheetDataModule;
begin

  FastReportApprovingSheetDataModule :=
    TFastReportApprovingSheetDataModule.Create(nil);

  try

    FillApprovingSheetTitle(
      FastReportApprovingSheetDataModule.ApprovingSheetReport,
      DocumentApprovingSheetViewModel
    );

    FillApprovingSheetApprovingSet(
      FastReportApprovingSheetDataModule,
      DocumentApprovingSheetViewModel.ApprovingSetHolder
    );

    FastReportApprovingSheetDataModule.ApprovingSheetReport.ShowReport;
    
  finally

    FreeAndNil(FastReportApprovingSheetDataModule);
    
  end;

end;

procedure TDocumentApprovingSheetFastReportPresenter.FillApprovingSheetTitle(
  ApprovingSheetReport: TfrxReport;
  DocumentApprovingSheetViewModel: TDocumentApprovingSheetViewModel
);
begin

  with DocumentApprovingSheetViewModel do begin

    ApprovingSheetReport.Variables['DocumentKindName'] := '''' + AnsiLowerCase(PChar(DocumentKindName)) + '''';
    ApprovingSheetReport.Variables['DocumentName'] := '''' + DocumentName + '''';
     
  end;

end;

procedure TDocumentApprovingSheetFastReportPresenter.FillApprovingSheetApprovingSet(
  FastReportApprovingSheetDataModule: TFastReportApprovingSheetDataModule;
  ApprovingSetHolder: TDocumentApprovingSheetApprovingSetHolder
);

  procedure SetReportApprovingSetFieldName(
    const ReportMemoName: String;
    const FieldName: String
  );
  begin

    TfrxMemoView(
      FastReportApprovingSheetDataModule
        .ApprovingSheetReport
          .FindObject(ReportMemoName)
    ).Text :=
      '[' +
        FastReportApprovingSheetDataModule.ApprovingSet.UserName + '."' +
        FieldName +
      '"]';

  end;
var
    ApprovingListBand: TfrxMasterData;
begin

  with ApprovingSetHolder, FastReportApprovingSheetDataModule do begin

    SetReportApprovingSetFieldName(
      'ApproverSpecialityMemo',
      ApproverSpecialityFieldName
    );

    SetReportApprovingSetFieldName(
      'ApprovingPerformingResultNameMemo',
      ApprovingPerformingStatusNameFieldName
    );

    SetReportApprovingSetFieldName(
      'IsApprovedWithNotesMemo',
      IsApprovedWithNotesFieldName
    );

    SetReportApprovingSetFieldName(
      'ApprovingPerformingDateMemo',
      ApprovingPerformingDateFieldName
    );

    SetReportApprovingSetFieldName(
      'ApproverNameMemo',
      ApproverNameFieldName
    );

    ApprovingSetDataSource.DataSet := DataSet;
    ApprovingSet.DataSource := ApprovingSetDataSource;

  end;

end;

end.
