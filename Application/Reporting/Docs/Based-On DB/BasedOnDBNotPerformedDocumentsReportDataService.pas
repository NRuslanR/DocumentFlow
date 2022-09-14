unit BasedOnDBNotPerformedDocumentsReportDataService;

interface

uses

  NotPerformedDocumentsReportData,
  NotPerformedDocumentsReportDataService,
  AbstractApplicationService,
  ZDataset,
  QueryExecutor,
  DataSetQueryExecutor,
  DataSetDataReader,
  Disposable,
  DataReader,
  ZConnection,
  SysUtils,
  Classes;

type

  TBasedOnDBNotPerformedDocumentsReportDataService =
    class (TAbstractApplicationService, INotPerformedDocumentsReportDataService)

      protected

        FQueryExecutor: IQueryExecutor;
        
      protected

        function CreateNotPerformedDocumentsReportFieldDefs:
          TNotPerformedDocumentSetFieldDefs;

        function CreateNotPerformedDocumentsReportFieldDefsInstance:
          TNotPerformedDocumentSetFieldDefs; virtual;

        procedure FillNotPerformedDocumentsReportFieldDefs(
          ReportFieldDefs: TNotPerformedDocumentSetFieldDefs
        ); virtual;

      protected

        function CreateNotPerformedDocumentSetHolderInstance: TNotPerformedDocumentSetHolder; virtual;

      protected
        
        function CreateFetchingNotPerformedDocumentInfosQuery(
          const EmployeeId: Variant;
          const DepartmentId: Variant;
          const PeriodStart: TDateTime;
          const PeriodEnd: TDateTime;
          ReportFieldDefs: TNotPerformedDocumentSetFieldDefs
        ): String; virtual; abstract;

        function ExecuteFetchingNotPerformedDocumentInfosQuery(
          const EmployeeId: Variant;
          const DepartmentId: Variant;
          const PeriodStart: TDateTime;
          const PeriodEnd: TDateTime;
          ReportFieldDefs: TNotPerformedDocumentSetFieldDefs
        ): IDataReader; virtual;
        
      public

        constructor Create(
          DataSetQueryExecutor: TDataSetQueryExecutor
        );

        function GetNotPerformedServiceNotesReportDataForEmployee(
          const EmployeeId: Variant;
          const DepartmentId: Variant;
          const PeriodStart: TDateTime = 0;
          const PeriodEnd: TDateTime = 0
        ): TNotPerformedDocumentsReportData;
        
    end;

implementation

{ TBasedOnDBNotPerformedDocumentsReportDataService }

constructor TBasedOnDBNotPerformedDocumentsReportDataService.Create(
  DataSetQueryExecutor: TDataSetQueryExecutor
);
begin

  inherited Create;

  FQueryExecutor := DataSetQueryExecutor;

end;

function TBasedOnDBNotPerformedDocumentsReportDataService.
  GetNotPerformedServiceNotesReportDataForEmployee(
    const EmployeeId: Variant;
    const DepartmentId: Variant;
    const PeriodStart, PeriodEnd: TDateTime
  ): TNotPerformedDocumentsReportData;
var
    DataReader: IDataReader;

    NotPerformedDocumentSetHolder: TNotPerformedDocumentSetHolder;
    NotPerformedDocumentSetFieldDefs: TNotPerformedDocumentSetFieldDefs;
begin


  NotPerformedDocumentSetHolder := CreateNotPerformedDocumentSetHolderInstance;

  try

    NotPerformedDocumentSetHolder.FieldDefs := CreateNotPerformedDocumentsReportFieldDefs;
      
    DataReader :=
      ExecuteFetchingNotPerformedDocumentInfosQuery(
        EmployeeId, DepartmentId, PeriodStart, PeriodEnd, NotPerformedDocumentSetHolder.FieldDefs
      );

    NotPerformedDocumentSetHolder.DataSet := TDataSetDataReader(DataReader.Self).ToDataSet;

    Result :=
      TNotPerformedDocumentsReportData.CreateFrom(
        PeriodStart,
        PeriodEnd,

        NotPerformedDocumentSetHolder.DataSet.FieldByName(
          NotPerformedDocumentSetHolder.FieldDefs.DeparmentShortNameFieldName
        ).AsString,

        NotPerformedDocumentSetHolder.DataSet.RecordCount,
        NotPerformedDocumentSetHolder
      );

  except

    on E: Exception do begin

      FreeAndNil(NotPerformedDocumentSetHolder);

      Raise;
      
    end;

  end;

end;

function TBasedOnDBNotPerformedDocumentsReportDataService.
  CreateNotPerformedDocumentSetHolderInstance: TNotPerformedDocumentSetHolder;
begin

  Result := TNotPerformedDocumentSetHolder.Create;

end;

function TBasedOnDBNotPerformedDocumentsReportDataService.
  ExecuteFetchingNotPerformedDocumentInfosQuery(
    const EmployeeId, DepartmentId: Variant;
    const PeriodStart, PeriodEnd: TDateTime;
    ReportFieldDefs: TNotPerformedDocumentSetFieldDefs
  ): IDataReader;
begin

  Result :=
    FQueryExecutor.ExecuteSelectionQuery(
      CreateFetchingNotPerformedDocumentInfosQuery(
        EmployeeId, DepartmentId, PeriodStart, PeriodEnd, ReportFieldDefs
      )
    );

end;

function TBasedOnDBNotPerformedDocumentsReportDataService.
  CreateNotPerformedDocumentsReportFieldDefs: TNotPerformedDocumentSetFieldDefs;
begin

  Result := CreateNotPerformedDocumentsReportFieldDefsInstance;

  FillNotPerformedDocumentsReportFieldDefs(Result);
  
end;

function TBasedOnDBNotPerformedDocumentsReportDataService.
  CreateNotPerformedDocumentsReportFieldDefsInstance: TNotPerformedDocumentSetFieldDefs;
begin

  Result := TNotPerformedDocumentSetFieldDefs.Create;
  
end;

procedure TBasedOnDBNotPerformedDocumentsReportDataService.
  FillNotPerformedDocumentsReportFieldDefs(
    ReportFieldDefs: TNotPerformedDocumentSetFieldDefs
  );
begin

  with ReportFieldDefs do begin

    NumberFieldName := 'number';
    CreationDateFieldName := 'creation_date';
    NameFieldName := 'name';
    ContentFieldName := 'content';
    LeaderShortNameFieldName := 'leader_short_name';
    PerformerShortNamesFieldName := 'performer_short_names';
    DeparmentShortNameFieldName := 'department_short_name';
    
  end;

end;

end.
