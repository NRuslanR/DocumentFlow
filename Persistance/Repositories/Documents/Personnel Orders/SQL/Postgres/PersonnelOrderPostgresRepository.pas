unit PersonnelOrderPostgresRepository;

interface

uses

  DocumentPostgresRepository,
  PersonnelOrder,
  DBTableMapping,
  PersonnelOrdersTableDef,
  DocumentTypeStageTableDef,
  DocumentApprovingPostgresRepository,
  DocumentSigningPostgresRepository,
  DocumentChargePostgresRepository,
  DocumentChargeSheetPostgresRepository,
  DocumentWorkCycleRepository,
  QueryExecutor,
  Document,
  SysUtils;

type

  TPersonnelOrderPostgresRepository = class (TDocumentPostgresRepository)

    protected

      procedure CustomizeTableMapping(
        TableMapping: TDBTableMapping
      ); override;

      procedure CustomizeDocumentSelectMappings(
        DocumentMappings: TDBTableMapping
      ); override;

      procedure CustomizeDocumentModificationMappings(
        DocumentMappings: TDBTableMapping
      ); override;

    public

      constructor Create(
        QueryExecutor: IQueryExecutor;
        DocumentTableDef: TPersonnelOrdersTableDef;
        DocumentTypeStageTableDef: TDocumentTypeStageTableDef;
        ApprovingPostgresRepository: TDocumentApprovingPostgresRepository;
        SigningPostgresRepository: TDocumentSigningPostgresRepository;
        ChargePostgresRepository: TDocumentChargePostgresRepository;
        ChargeSheetPostgresRepository: TDocumentChargeSheetPostgresRepository;
        WorkCycleRepository: IDocumentWorkCycleRepository
      );

  end;
  
implementation

uses

  AbstractDBRepository,
  PostgresTypeNameConstants;
  
{ TPersonnelOrderPostgresRepository }


{ TPersonnelOrderPostgresRepository }

constructor TPersonnelOrderPostgresRepository.Create(
  QueryExecutor: IQueryExecutor;
  DocumentTableDef: TPersonnelOrdersTableDef;
  DocumentTypeStageTableDef: TDocumentTypeStageTableDef;
  ApprovingPostgresRepository: TDocumentApprovingPostgresRepository;
  SigningPostgresRepository: TDocumentSigningPostgresRepository;
  ChargePostgresRepository: TDocumentChargePostgresRepository;
  ChargeSheetPostgresRepository: TDocumentChargeSheetPostgresRepository;
  WorkCycleRepository: IDocumentWorkCycleRepository
);
begin

  inherited Create(
    QueryExecutor,
    DocumentTableDef,
    DocumentTypeStageTableDef,
    TPersonnelOrder,
    ApprovingPostgresRepository,
    SigningPostgresRepository,
    ChargePostgresRepository,
    ChargeSheetPostgresRepository,
    WorkCycleRepository
  );
  
end;

procedure TPersonnelOrderPostgresRepository.
  CustomizeTableMapping(TableMapping: TDBTableMapping);
begin

  if not Assigned(FDocumentTableDef) then Exit;

  inherited CustomizeTableMapping(TableMapping);

end;

procedure TPersonnelOrderPostgresRepository.CustomizeDocumentSelectMappings(
  DocumentMappings: TDBTableMapping);
begin

  inherited CustomizeDocumentSelectMappings(DocumentMappings);
  
  with TableMapping, TPersonnelOrdersTableDef(FDocumentTableDef) do begin

    AddColumnMappingForSelect(SubKindIdColumnName, 'SubKindId');
    
  end;

end;

procedure TPersonnelOrderPostgresRepository.CustomizeDocumentModificationMappings(
  DocumentMappings: TDBTableMapping);
begin

  inherited CustomizeDocumentModificationMappings(DocumentMappings);
  
  with TableMapping, TPersonnelOrdersTableDef(FDocumentTableDef) do begin

    AddColumnMappingForModification(
      SubKindIdColumnName, 'SubKindId', PostgresTypeNameConstants.INTEGER_TYPE_NAME
    );

  end;

end;


end.
