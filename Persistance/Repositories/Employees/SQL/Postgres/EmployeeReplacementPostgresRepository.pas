unit EmployeeReplacementPostgresRepository;

interface

uses

  DB,
  AbstractPostgresRepository,
  Employee,
  DomainObjectUnit,
  DomainObjectListUnit,
  AbstractRepositoryCriteriaUnit,
  EmployeeReplacementTableDef,
  AbstractDBRepository,
  DBTableMapping,
  TableColumnMappings,
  DomainObjectCompiler,
  QueryExecutor,
  DataReader,
  SysUtils,
  Classes;

type

  TEmployeeReplacementPostgresRepository =
    class (TAbstractPostgresRepository)

      protected

        procedure Initialize; override;
        
        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      protected

        function CreateDomainObjectCompiler(
          ColumnMappings: TTableColumnMappings
        ): TDomainObjectCompiler; override;
        
      protected

        procedure PrepareRemoveDomainObjectQuery(
          DomainObject: TDomainObject;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

      public

        destructor Destroy; override;
        function FindEmployeeReplacements(
          const EmployeeId: Variant
        ): TEmployeeReplacements;

        procedure AddEmployeeReplacements(
          Replacements: TEmployeeReplacements
        );

        procedure RemoveAllEmployeeReplacements(const EmployeeId: Variant);

    end;

implementation

uses

  Variants,
  AbstractRepository,
  EmployeeReplacementQueryTexts;

type

  TRemovingAllEmployeeReplacementsWrapper = class (TDomainObject)

    public

      EmployeeId: Variant;

    public

      constructor Create(const EmployeeId: Variant);

  end;

  TFindReplacementsForEmployeeCriterion = class (TAbstractRepositoryCriterion)

    private

      FEmployeeId: Variant;

    protected

      function GetExpression: String; override;
      
    public

      constructor Create(

        const EmployeeId: Variant

      );

  end;

  TEmployeeReplacementCompiler = class (TDomainObjectCompiler)

    protected

      function CanBeValueAssignedToObjectProperty(
        const ObjectPropertyName: String;
        Value: Variant;
        const FieldName: String;
        DataReader: IDataReader
      ): Boolean; override;

  end;


{ TEmployeeReplacementPostgresRepository }

procedure TEmployeeReplacementPostgresRepository.AddEmployeeReplacements(
  Replacements: TEmployeeReplacements
);
begin

  AddDomainObjectList(Replacements);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

function TEmployeeReplacementPostgresRepository.
  CreateDomainObjectCompiler(
    ColumnMappings: TTableColumnMappings
  ): TDomainObjectCompiler;
begin

  Result := TEmployeeReplacementCompiler.Create(ColumnMappings);

end;

procedure TEmployeeReplacementPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping
);
begin

  TableMapping.SetTableNameMapping(
    EMPLOYEE_REPLACEMENT_TABLE_NAME,
    TEmployeeReplacement,
    TEmployeeReplacements
  );

  begin

    TableMapping.AddColumnMappingForSelect(
      EMPLOYEE_REPLACEMENT_TABLE_ID_FIELD,
      'Identity'
    );

    TableMapping.AddColumnMappingForSelect(
      EMPLOYEE_REPLACEMENT_TABLE_REPLACEABLE_ID_FIELD,
      'ReplaceableEmployeeId'
    );

    TableMapping.AddColumnMappingForSelect(
      EMPLOYEE_REPLACEMENT_TABLE_DEPUTY_ID_FIELD,
      'DeputyId'
    );

    TableMapping.AddColumnMappingForSelect(
      EMPLOYEE_REPLACEMENT_TABLE_REPLACEMENT_PERIOD_START,
      'PeriodStart'
    );

    TableMapping.AddColumnMappingForSelect(
      EMPLOYEE_REPLACEMENT_TABLE_REPLACEMENT_PERIOD_END,
      'PeriodEnd'
    );

  end;

  begin

    TableMapping.AddColumnMappingForModification(
      EMPLOYEE_REPLACEMENT_TABLE_REPLACEABLE_ID_FIELD,
      'ReplaceableEmployeeId'
    );

    TableMapping.AddColumnMappingForModification(
      EMPLOYEE_REPLACEMENT_TABLE_DEPUTY_ID_FIELD,
      'DeputyId'
    );

    TableMapping.AddColumnMappingForModification(
      EMPLOYEE_REPLACEMENT_TABLE_REPLACEMENT_PERIOD_START,
      'PeriodStart'
    );

    TableMapping.AddColumnMappingForModification(
      EMPLOYEE_REPLACEMENT_TABLE_REPLACEMENT_PERIOD_END,
      'PeriodEnd'
    );

  end;

  begin

    TableMapping.AddPrimaryKeyColumnMapping(
      EMPLOYEE_REPLACEMENT_TABLE_ID_FIELD,
      'Identity'
    );
    
  end;

end;

destructor TEmployeeReplacementPostgresRepository.Destroy;
begin

  inherited;
end;

function TEmployeeReplacementPostgresRepository.FindEmployeeReplacements(
  const EmployeeId: Variant
): TEmployeeReplacements;
var FindReplacementsForEmployeeCriterion:
      TFindReplacementsForEmployeeCriterion;
    DomainObjectList: TDomainObjectList;
begin

  FindReplacementsForEmployeeCriterion :=
    TFindReplacementsForEmployeeCriterion.Create(EmployeeId);
    
  try

    DomainObjectList :=
      FindDomainObjectsByCriteria(FindReplacementsForEmployeeCriterion);

    ThrowExceptionIfErrorIsNotUnknown;
    
    if not Assigned(DomainObjectList) then
      Result := nil

    else Result := DomainObjectList as TEmployeeReplacements;
    
  finally

    FreeAndNil(FindReplacementsForEmployeeCriterion);

  end;

end;

procedure TEmployeeReplacementPostgresRepository.Initialize;
begin

  inherited;

  DomainObjectInvariantsComplianceEnabled := False;
  
end;

procedure TEmployeeReplacementPostgresRepository.
  PrepareRemoveDomainObjectQuery(
    DomainObject: TDomainObject;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
var Wrapper: TRemovingAllEmployeeReplacementsWrapper;
begin

  if not (DomainObject is TRemovingAllEmployeeReplacementsWrapper) then begin

    inherited;
    Exit;

  end;
  
  Wrapper := DomainObject as TRemovingAllEmployeeReplacementsWrapper;

  QueryPattern := DELETE_ALL_REPLACEMENT_FOR_EMPLOYEE_QUERY;

  QueryParams := TQueryParams.Create;

  QueryParams.Add(REPLACEABLE_EMPLOYEE_ID_PARAM_NAME, Wrapper.EmployeeId);

end;

procedure TEmployeeReplacementPostgresRepository.
  RemoveAllEmployeeReplacements(
    const EmployeeId: Variant
  );
var Wrapper: TRemovingAllEmployeeReplacementsWrapper;
begin

  Wrapper := TRemovingAllEmployeeReplacementsWrapper.Create(EmployeeId);
  
  try

    Remove(Wrapper);

    ThrowExceptionIfErrorIsNotUnknown;
    
  finally

    FreeAndNil(Wrapper);

  end;

end;

{ TRemovingAllEmployeeReplacementsWrapper }

constructor TRemovingAllEmployeeReplacementsWrapper.Create(
  const EmployeeId: Variant
);
begin

  inherited Create;

  Self.EmployeeId := EmployeeId;

end;

{ TFindReplacementsForEmployeeCriterion }

constructor TFindReplacementsForEmployeeCriterion.Create(

  const EmployeeId: Variant
  
);
begin

  inherited Create;

  FEmployeeId := EmployeeId;

end;

function TFindReplacementsForEmployeeCriterion.GetExpression: String;
begin

  Result :=
    EMPLOYEE_REPLACEMENT_TABLE_REPLACEABLE_ID_FIELD +
    '=' +
    VarToStr(FEmployeeId);

end;

{ TEmployeeReplacementCompiler }

function TEmployeeReplacementCompiler.
  CanBeValueAssignedToObjectProperty(
    const ObjectPropertyName: String;
    Value: Variant;
    const FieldName: String;
    DataReader: IDataReader
  ): Boolean;
var OtherPeriodPartPropertyName: String;
    OtherPeriodPartFieldName: String;
begin

  if (ObjectPropertyName <> 'PeriodStart')
     and (ObjectPropertyName <> 'PeriodEnd')

  then begin

    Result := inherited CanBeValueAssignedToObjectProperty(
                          ObjectPropertyName,
                          Value,
                          FieldName,
                          DataReader
                        );
    Exit;

  end;


  if ObjectPropertyName = 'PeriodStart' then
    OtherPeriodPartPropertyName := 'PeriodEnd'

  else OtherPeriodPartPropertyName := 'PeriodStart';

  OtherPeriodPartFieldName :=
    ColumnMappings.FindColumnMappingByObjectPropertyName(
      OtherPeriodPartPropertyName
    ).ColumnName;

  Result :=
    not VarIsNull(Value)
    and not VarIsNull(DataReader[OtherPeriodPartFieldName]);

end;

end.
