unit PersonnelOrderSubKindPostgresRepository;

interface

uses

  AbstractPostgresRepository,
  PersonnelOrderSubKind,
  PersonnelOrderSubKindFinder,
  PersonnelOrderSubKindRepository,
  PersonnelOrderSubKindTableDef,
  DBTableMapping,
  QueryExecutor,
  SysUtils;

type

  TPersonnelOrderSubKindPostgresRepository =
    class (
      TAbstractPostgresRepository,
      IPersonnelOrderSubKindFinder,
      IPersonnelOrderSubKindRepository
    )

      protected

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      public

        constructor Create(
          QueryExecutor: IQueryExecutor;
          TableDef: TPersonnelOrderSubKindTableDef
        );
        
        function FindPersonnelOrderSubKindById(const SubKindId: Variant): TPersonnelOrderSubKind;
        
    end;
    
implementation

uses AbstractRepository;

{ TPersonnelOrderSubKindPostgresRepository }

constructor TPersonnelOrderSubKindPostgresRepository.Create(
  QueryExecutor: IQueryExecutor; TableDef: TPersonnelOrderSubKindTableDef);
begin

  inherited Create(QueryExecutor, TableDef);

end;

procedure TPersonnelOrderSubKindPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  inherited CustomizeTableMapping(TableMapping);

  with TableMapping, TPersonnelOrderSubKindTableDef(FTableDef) do begin

    SetTableNameMapping(TableName, TPersonnelOrderSubKind, TPersonnelOrderSubKinds);
    
    AddColumnMappingForSelect(IdColumnName, 'Identity');
    AddColumnMappingForSelect(NameColumnName, 'Name');


    AddColumnMappingForModification(NameColumnName, 'Name');

    AddPrimaryKeyColumnMapping(IdColumnName, 'Identity');
    
  end;

end;

function TPersonnelOrderSubKindPostgresRepository.FindPersonnelOrderSubKindById(
  const SubKindId: Variant): TPersonnelOrderSubKind;
begin

  Result := TPersonnelOrderSubKind(FindDomainObjectByIdentity(SubKindId));

end;

end.
