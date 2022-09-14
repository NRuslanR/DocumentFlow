unit BasedOnDBNotPerformedIncomingDocumentsReportDataService;

interface

uses

  BasedOnDBNotPerformedDocumentsReportDataService,
  NotPerformedDocumentsReportData,
  NotPerformedIncomingDocumentsReportData,
  DataSetQueryExecutor,
  SysUtils,
  Classes;

type

  TBasedOnDBNotPerformedIncomingDocumentsReportDataService =
    class (TBasedOnDBNotPerformedDocumentsReportDataService)

      protected

        function CreateNotPerformedDocumentSetHolderInstance: TNotPerformedDocumentSetHolder; override;
        
      protected

        function CreateNotPerformedDocumentsReportFieldDefsInstance:
          TNotPerformedDocumentSetFieldDefs; override;

        procedure FillNotPerformedDocumentsReportFieldDefs(
          ReportFieldDefs: TNotPerformedDocumentSetFieldDefs
        ); override;

        
      public

        constructor Create(
          DataSetQueryExecutor: TDataSetQueryExecutor
        );
        
    end;
    
implementation

{ TBasedOnDBNotPerformedIncomingDocumentsReportDataService }

constructor TBasedOnDBNotPerformedIncomingDocumentsReportDataService.Create(
  DataSetQueryExecutor: TDataSetQueryExecutor
);
begin

  inherited Create(DataSetQueryExecutor);
  
end;

function TBasedOnDBNotPerformedIncomingDocumentsReportDataService.CreateNotPerformedDocumentSetHolderInstance: TNotPerformedDocumentSetHolder;
begin

  Result := TNotPerformedIncomingDocumentSetHolder.Create;
  
end;

function TBasedOnDBNotPerformedIncomingDocumentsReportDataService.
  CreateNotPerformedDocumentsReportFieldDefsInstance: TNotPerformedDocumentSetFieldDefs;
begin

  Result := TNotPerformedIncomingDocumentSetFieldDefs.Create;

end;

procedure TBasedOnDBNotPerformedIncomingDocumentsReportDataService.
  FillNotPerformedDocumentsReportFieldDefs(
    ReportFieldDefs: TNotPerformedDocumentSetFieldDefs
  );
begin

  inherited;

  with TNotPerformedIncomingDocumentSetFieldDefs(ReportFieldDefs) do begin

    IncomingNumberFieldName := 'incoming_number';
    ReceiptDateFieldName := 'receipt_date';
    
  end;

end;

end.
