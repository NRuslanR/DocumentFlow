unit BasedOnDatabaseIncomingDocumentInfoReadService;

interface

uses

  BasedOnDatabaseDocumentInfoReadService,
  DocumentFullInfoDataSetHolder,
  IncomingDocumentFullInfoDataSetHolder,
  DocumentFullInfoDTOFromDataSetMapper,
  IncomingDocumentFullInfoDTOFromDataSetMapper,
  SysUtils;

type

  TBasedOnDatabaseIncomingDocumentInfoReadService =
    class (TBasedOnDatabaseDocumentInfoReadService)

      private

      protected

      public

        function CreateDocumentFullInfoDataSetHolderInstance:
          TDocumentFullInfoDataSetHolder; override;

        procedure FillDocumentFullInfoDataSetFieldNames(
          FieldNames: TDocumentFullInfoDataSetFieldNames
        ); override;

    end;
  
implementation

uses

  AuxDebugFunctionsUnit;
  
{ TBasedOnDatabaseIncomingDocumentInfoReadService }

function TBasedOnDatabaseIncomingDocumentInfoReadService.
  CreateDocumentFullInfoDataSetHolderInstance: TDocumentFullInfoDataSetHolder;
begin

  Result := TIncomingDocumentFullInfoDataSetHolder.Create;

end;

procedure TBasedOnDatabaseIncomingDocumentInfoReadService.FillDocumentFullInfoDataSetFieldNames(
  FieldNames: TDocumentFullInfoDataSetFieldNames);
var
    IncomingDocumentFullInfoDataSetFieldNames: TIncomingDocumentFullInfoDataSetFieldNames;
begin

  IncomingDocumentFullInfoDataSetFieldNames :=
    FieldNames as TIncomingDocumentFullInfoDataSetFieldNames;
    
  inherited FillDocumentFullInfoDataSetFieldNames(
    IncomingDocumentFullInfoDataSetFieldNames
      .OriginalDocumentFullInfoDataSetFieldNames
  );

  with IncomingDocumentFullInfoDataSetFieldNames do begin

    IncomingDocumentIdFieldName := 'incoming_document_id';
    IncomingDocumentKindIdFieldName := 'incoming_document_kind_id';
    IncomingDocumentKindNameFieldName := 'incoming_document_kind_name';
    IncomingNumberFieldName := 'incoming_number';
    ReceiptDateFieldName := 'receipt_date';
    IncomingDocumentStageNumberFieldName := 'incoming_doc_stage_number';
    IncomingDocumentStageNameFieldName := 'incoming_doc_stage_name';

  end;

end;

end.
