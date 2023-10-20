unit BasedOnDatabasePersonnelOrderInfoReadService;

interface

uses

  BasedOnDatabaseDocumentInfoReadService,
  DocumentFullInfoDataSetHolder,
  AbstractQueryExecutor,
  DocumentFullInfoDTOFromDataSetMapper,
  PersonnelOrderFullInfoDTOFromDataSetMapper,
  PersonnelOrderFullInfoDataSetHolder,
  SysUtils;

type

  TBasedOnDatabasePersonnelOrderInfoReadService =
    class (TBasedOnDatabaseDocumentInfoReadService)

      protected

        function CreateDocumentFullInfoDataSetHolderInstance:
          TDocumentFullInfoDataSetHolder; override;

        procedure FillDocumentFullInfoDataSetFieldNames(
          FieldNames: TDocumentFullInfoDataSetFieldNames
        ); override;

      public

        constructor Create(
          QueryExecutor: TAbstractQueryExecutor;
          DocumentInfoFetchingQueryBuilder: TDocumentInfoFetchingQueryBuilder;
          PersonnelOrderFullInfoDTOFromDataSetMapper: TPersonnelOrderFullInfoDTOFromDataSetMapper
        ); 

    end;
    
implementation

{ TBasedOnDatabasePersonnelOrderInfoReadService }


constructor TBasedOnDatabasePersonnelOrderInfoReadService.Create(
  QueryExecutor: TAbstractQueryExecutor;
  DocumentInfoFetchingQueryBuilder: TDocumentInfoFetchingQueryBuilder;
  PersonnelOrderFullInfoDTOFromDataSetMapper: TPersonnelOrderFullInfoDTOFromDataSetMapper);
begin

  inherited Create(
    QueryExecutor,
    DocumentInfoFetchingQueryBuilder,
    PersonnelOrderFullInfoDTOFromDataSetMapper
  );
  
end;

function TBasedOnDatabasePersonnelOrderInfoReadService
  .CreateDocumentFullInfoDataSetHolderInstance: TDocumentFullInfoDataSetHolder;
begin

  Result := TPersonnelOrderFullInfoDataSetHolder.Create;

end;

procedure TBasedOnDatabasePersonnelOrderInfoReadService.
  FillDocumentFullInfoDataSetFieldNames(
    FieldNames: TDocumentFullInfoDataSetFieldNames
  );
begin

  inherited FillDocumentFullInfoDataSetFieldNames(FieldNames);

  with TPersonnelOrderFullInfoDataSetFieldNames(FieldNames) do begin

    IsSelfRegisteredFieldName := '';
    SubKindIdFieldName := 'sub_type_id';
    SubKindNameFieldName := 'sub_type_name';
    
  end;

end;

end.
