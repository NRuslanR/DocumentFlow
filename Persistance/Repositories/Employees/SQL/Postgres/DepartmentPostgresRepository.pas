unit DepartmentPostgresRepository;

interface

uses

  AbstractRepositoryCriteriaUnit,
  AbstractDBRepository,
  AbstractRepository,
  AbstractPostgresRepository,
  DBTableMapping,
  DomainObjectUnit,
  DomainObjectListUnit,
  DepartmentRepository,
  QueryExecutor,
  DataReader,
  DepartmentUnit,
  Classes,
  SysUtils;

type

  TDepartmentPostgresRepository =
    class (TAbstractPostgresRepository, IDepartmentRepository)

      protected

        procedure Initialize; override;

        procedure CustomizeTableMapping(
          TableMapping: TDBTableMapping
        ); override;

      protected

        procedure PrepareFindDomainObjectsByCriteria(
          Criteria: TAbstractRepositoryCriterion;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        ); override;

        procedure PrepareFindAllDepartmentsBeginningWithQuery(
          const StartDepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure PrepareFindAllKindredDepartmentsBeginningWithQuery(
          const StartDepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure PrepareFindHeadKindredDepartmentForGivenDepartmentQuery(
          const DepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );

        procedure PrepareFindAllNotKindredInnerDepartmentsForDepartmentQuery(
          const DepartmentId: Variant;
          var QueryPattern: String;
          var QueryParams: TQueryParams
        );
      
      public

        function LoadAllDepartments: TDepartments;
        function FindDepartmentById(const Id: Variant): TDepartment;

        function IsDepartmentIncludesOtherDepartment(
          const TargetDepartmentId, OtherDepartmentId: Variant
        ): Boolean;

        function FindDepartmentByCode(const Code: String): TDepartment;
        function FindHeadKindredDepartmentForGivenDepartment(
          const DepartmentId: Variant
        ): TDepartment;
      
        function FindAllDepartmentsBeginningWith(
          const TargetDepartmentId: Variant
        ): TDepartments;

        function FindAllKindredDepartmentsBeginningWith(
          const TargetDepartmentId: Variant
        ): TDepartments;

        function FindAllNotKindredInnerDepartmentsForDepartment(
          const TargetDepartmentId: Variant
        ): TDepartments;

        procedure AddDepartment(Department: TDepartment);
        procedure UpdateDepartment(Department: TDepartment);
        procedure RemoveDepartment(Department: TDepartment);

    end;

implementation

uses

  DB,
  Variants,
  DepartmentTableDef,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;

type

  TFindDepartmentByCodeCriterion = class (TAbstractRepositoryCriterion)

    private

      FCode: String;
      FRepository: TDepartmentPostgresRepository;

    protected

      function GetExpression: String; override;
      
    public

      constructor Create(
        const Code: String;
        Repository: TDepartmentPostgresRepository
      );

  end;
  
  TFindHeadKindredDepartmentForGivenDepartmentCriterion =
    class (TAbstractRepositoryCriterion)

      private

        FDepartmentId: Variant;
        FRepository: TDepartmentPostgresRepository;
        
      protected

        function GetExpression: String; override;

      public

        constructor Create(
          const DepartmentId: Variant;
          Repository: TDepartmentPostgresRepository
        );

      published

        property DepartmentId: Variant read FDepartmentId;

    end;

    TFindAllDepartmentsBeginningWithCriterion =
    class (TAbstractRepositoryCriterion)

      private

        FStartDepartmentId: Variant;
        FRepository: TDepartmentPostgresRepository;
        
      protected

        function GetExpression: String; override;

      public

        constructor Create(
          DepartmentPostgresRepository: TDepartmentPostgresRepository;
          const StartDepartmentId: Variant
        );

        property StartDepartmentId: Variant
        read FStartDepartmentId write FStartDepartmentId;

    end;

    TFindAllKindredDepartmentsBeginningWithCriterion =
      class (TFindAllDepartmentsBeginningWithCriterion)

      end;

    TFindAllNotKindredInnerDepartmentsForDepartmentCriterion =
      class (TFindAllDepartmentsBeginningWithCriterion)

      end;

{ TDepartmentPostgresRepository }

procedure TDepartmentPostgresRepository.CustomizeTableMapping(
  TableMapping: TDBTableMapping);
begin

  TableMapping.SetTableNameMapping(DEPARTMENT_TABLE_NAME, TDepartment, TDepartments);

  TableMapping.AddColumnMappingForSelect(DEPARTMENT_TABLE_ID_FIELD, 'Identity');
  TableMapping.AddColumnMappingForSelect(DEPARTMENT_TABLE_CODE_FIELD, 'Code');
  TableMapping.AddColumnMappingForSelect(DEPARTMENT_TABLE_SHORT_NAME_FIELD, 'ShortName');
  TableMapping.AddColumnMappingForSelect(DEPARTMENT_TABLE_FULL_NAME_FIELD, 'FullName');

  TableMapping.AddColumnMappingForModification(DEPARTMENT_TABLE_CODE_FIELD, 'Code');
  TableMapping.AddColumnMappingForModification(DEPARTMENT_TABLE_SHORT_NAME_FIELD, 'ShortName');
  TableMapping.AddColumnMappingForModification(DEPARTMENT_TABLE_FULL_NAME_FIELD, 'FullName');

  TableMapping.AddPrimaryKeyColumnMapping(DEPARTMENT_TABLE_ID_FIELD, 'Identity');

end;

function TDepartmentPostgresRepository.LoadAllDepartments: TDepartments;
var DomainObjectList: TDomainObjectList;
begin

  DomainObjectList := LoadAll;

  ThrowExceptionIfErrorIsNotUnknown;
  
  if DomainObjectList = nil then
    Result := nil

  else Result := DomainObjectList as TDepartments;
  
end;

procedure TDepartmentPostgresRepository.PrepareFindAllDepartmentsBeginningWithQuery(
  const StartDepartmentId: Variant;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  QueryPattern :=
    'SELECT * FROM ' +
    'doc.get_department_tree_starting_with(:start_department_id)';

  QueryParams := TQueryParams.Create;

  QueryParams.Add('start_department_id', StartDepartmentId);

end;

procedure TDepartmentPostgresRepository.
  PrepareFindAllKindredDepartmentsBeginningWithQuery(
    const StartDepartmentId: Variant;
    var QueryPattern: String;
    var QueryParams: TQueryParams
  );
begin

  QueryPattern :=
    'SELECT * FROM ' +
    'doc.get_kindred_department_tree_starting_with(:start_department_id)';

  QueryParams := TQueryParams.Create;

  QueryParams.Add('start_department_id', StartDepartmentId);
  
end;

procedure TDepartmentPostgresRepository.PrepareFindAllNotKindredInnerDepartmentsForDepartmentQuery(
  const DepartmentId: Variant;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  QueryPattern :=
    'SELECT * FROM ' +
    'doc.get_not_kindred_inner_department_tree_for_department(:department_id)';

  QueryParams := TQueryParams.Create;

  QueryParams.Add('department_id', DepartmentId);
  
end;

procedure TDepartmentPostgresRepository.PrepareFindDomainObjectsByCriteria(
  Criteria: TAbstractRepositoryCriterion;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
var
    FindAllDepartmentsBeginningWithCriterion:
      TFindAllDepartmentsBeginningWithCriterion;

    FindHeadKindredDepartmentForGivenDepartmentCriterion:
      TFindHeadKindredDepartmentForGivenDepartmentCriterion;
begin

  if Criteria is TFindAllDepartmentsBeginningWithCriterion then begin

    FindAllDepartmentsBeginningWithCriterion :=
      Criteria as TFindAllDepartmentsBeginningWithCriterion;

    if Criteria is TFindAllKindredDepartmentsBeginningWithCriterion
    then begin

      PrepareFindAllKindredDepartmentsBeginningWithQuery(
        FindAllDepartmentsBeginningWithCriterion.StartDepartmentId,
        QueryPattern,
        QueryParams
      );

    end

    else begin

      PrepareFindAllDepartmentsBeginningWithQuery(
        FindAllDepartmentsBeginningWithCriterion.StartDepartmentId,
        QueryPattern,
        QueryParams
      );

    end;

  end

  else if Criteria is TFindHeadKindredDepartmentForGivenDepartmentCriterion then
  begin

    FindHeadKindredDepartmentForGivenDepartmentCriterion :=
      Criteria as TFindHeadKindredDepartmentForGivenDepartmentCriterion;

    PrepareFindHeadKindredDepartmentForGivenDepartmentQuery(
      FindHeadKindredDepartmentForGivenDepartmentCriterion.DepartmentId,
      QueryPattern,
      QueryParams
    );
    
  end

  else inherited;

end;

procedure TDepartmentPostgresRepository.PrepareFindHeadKindredDepartmentForGivenDepartmentQuery(
  const DepartmentId: Variant;
  var QueryPattern: String;
  var QueryParams: TQueryParams
);
begin

  QueryPattern :=
    'SELECT ' +
    't2.* ' +
    'FROM doc.find_head_kindred_department_for_inner(:department_id) t1(id) ' +
    'JOIN doc.departments t2 ON t2.id = t1.id';

  QueryParams := TQueryParams.Create;

  QueryParams.Add('department_id', DepartmentId);
  
end;

function TDepartmentPostgresRepository.FindAllDepartmentsBeginningWith(
  const TargetDepartmentId: Variant): TDepartments;
var Criterion: TFindAllDepartmentsBeginningWithCriterion;
    DomainObjectList: TDomainObjectList;
begin

  Criterion :=
    TFindAllDepartmentsBeginningWithCriterion.Create(
      Self, TargetDepartmentId
    );

  try

    DomainObjectList := FindDomainObjectsByCriteria(Criterion);

    ThrowExceptionIfErrorIsNotUnknown;
    
    if not Assigned(DomainObjectList) then
      Result := nil

    else Result := DomainObjectList as TDepartments;

  finally

    FreeAndNil(Criterion);
    
  end;

end;

function TDepartmentPostgresRepository.FindAllKindredDepartmentsBeginningWith(
  const TargetDepartmentId: Variant
): TDepartments;
var Criteria: TFindAllKindredDepartmentsBeginningWithCriterion;
    DomainObjectList: TDomainObjectList;
begin

  Criteria :=
    TFindAllKindredDepartmentsBeginningWithCriterion.Create(
      Self, TargetDepartmentId
    );

  try

    DomainObjectList := FindDomainObjectsByCriteria(Criteria);

    ThrowExceptionIfErrorIsNotUnknown;
    
    if Assigned(DomainObjectList) then
      Result := DomainObjectList as TDepartments

    else
      Result := nil;
      
  finally

    FreeAndNil(Criteria);
    
  end;

end;

function TDepartmentPostgresRepository.
  FindAllNotKindredInnerDepartmentsForDepartment(
    const TargetDepartmentId: Variant
  ): TDepartments;
var Criteria: TFindAllNotKindredInnerDepartmentsForDepartmentCriterion;
    DomainObjectList: TDomainObjectList;
begin

  Criteria :=
    TFindAllNotKindredInnerDepartmentsForDepartmentCriterion.Create(
      Self, TargetDepartmentId
    );

  try

    DomainObjectList := FindDomainObjectsByCriteria(Criteria);

    ThrowExceptionIfErrorIsNotUnknown;
    
    if Assigned(DomainObjectList) then
      Result := DomainObjectList as TDepartments

    else
      Result := nil;
      
  finally

    FreeAndNil(Criteria);
    
  end;

end;

function TDepartmentPostgresRepository.FindDepartmentByCode(
  const Code: String
): TDepartment;
var
    FindDepartmentByCodeCriterion: TFindDepartmentByCodeCriterion;

    DomainObjectList: TDomainObjectList;
    Free: IDomainObjectBaseList;
begin

  FindDepartmentByCodeCriterion := TFindDepartmentByCodeCriterion.Create(Code, Self);

  try

    DomainObjectList := FindDomainObjectsByCriteria(FindDepartmentByCodeCriterion);

    Free := DomainObjectList;

    ThrowExceptionIfErrorIsNotUnknown;
    
    if not Assigned(DomainObjectList) or DomainObjectList.IsEmpty then
      Result := nil

    else if DomainObjectList.Count = 1 then
      Result := TDepartment(DomainObjectList[0].Clone)

    else begin

      raise Exception.CreateFmt(
        'Для кода %s в базе данных ' +
        'было найдено более одного подразделения',
        [Code]
      );

    end;

  finally

    FreeAndNil(FindDepartmentByCodeCriterion);
    
  end;

end;

function TDepartmentPostgresRepository.FindDepartmentById(
  const Id: Variant): TDepartment;
var DomainObject: TDomainObject;
begin

  DomainObject := FindDomainObjectByIdentity(Id);

  ThrowExceptionIfErrorIsNotUnknown;
  
  if DomainObject = nil then
    Result := nil

  else Result := DomainObject as TDepartment;
  
end;

function TDepartmentPostgresRepository.FindHeadKindredDepartmentForGivenDepartment(
  const DepartmentId: Variant): TDepartment;
var Criteria: TFindHeadKindredDepartmentForGivenDepartmentCriterion;
    DomainObjectList: TDomainObjectList;
begin

  Criteria :=
    TFindHeadKindredDepartmentForGivenDepartmentCriterion.Create(
      DepartmentId,
      Self
    );

  try

    DomainObjectList := FindDomainObjectsByCriteria(Criteria);

    ThrowExceptionIfErrorIsNotUnknown;
    
    if not Assigned(DomainObjectList) then
      Result := nil

    else begin

      if DomainObjectList.Count > 1 then
        raise Exception.Create(
                'Для подразделения было ' +
                'найдено несколько головных ' +
                'подразделений'
              );

      Result := DomainObjectList[0] as TDepartment;
      
    end;

  finally

    FreeAndNil(Criteria);

  end;
  
end;

procedure TDepartmentPostgresRepository.Initialize;
begin

  inherited;

  ReturnIdOfDomainObjectAfterAdding := True;

end;

function TDepartmentPostgresRepository.IsDepartmentIncludesOtherDepartment(
  const TargetDepartmentId, OtherDepartmentId: Variant
): Boolean;
var
    VariantResult: Variant;
    DataReader: IDataReader;
    QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams
      .AddFluently('ptarget_department_id', TargetDepartmentId)
      .AddFluently('pother_department_id', OtherDepartmentId);

    DataReader :=
      SafeQueryExecutor.ExecuteSelectionQuery(
        'select doc.is_department_includes_other_department(' +
        ':ptarget_department_id, :pother_department_id) as result',
        QueryParams
      );

    if DataReader.RecordCount = 0 then
      Result := False

    else Result := DataReader['result'];
    
  finally

    FreeAndNil(QueryParams);
    
  end;

end;

procedure TDepartmentPostgresRepository.AddDepartment(Department: TDepartment);
begin

  Add(Department);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TDepartmentPostgresRepository.UpdateDepartment(
  Department: TDepartment);
begin

  Update(Department);

  ThrowExceptionIfErrorIsNotUnknown;
  
end;

procedure TDepartmentPostgresRepository.RemoveDepartment(
  Department: TDepartment);
begin

  Remove(Department);
  
  ThrowExceptionIfErrorIsNotUnknown;
  
end;

{ TFindAllDepartmentsBeginningWithCriterion }

constructor TFindAllDepartmentsBeginningWithCriterion.Create(
  DepartmentPostgresRepository: TDepartmentPostgresRepository;
  const StartDepartmentId: Variant);
begin

  inherited Create;

  FRepository := DepartmentPostgresRepository;
  FStartDepartmentId := StartDepartmentId;
  
end;

function TFindAllDepartmentsBeginningWithCriterion.GetExpression: String;
begin

  Result := VarToStr(FStartDepartmentId);
  
end;

{ TFindHeadKindredDepartmentForGivenDepartmentCriterion }

constructor TFindHeadKindredDepartmentForGivenDepartmentCriterion.Create(
  const DepartmentId: Variant; Repository: TDepartmentPostgresRepository);
begin

  inherited Create;

  FDepartmentId := DepartmentId;
  FRepository := Repository;
  
end;

function TFindHeadKindredDepartmentForGivenDepartmentCriterion.GetExpression: String;
begin

  Result := '';
  
end;

{ TFindDepartmentByCodeCriterion }

constructor TFindDepartmentByCodeCriterion.Create(const Code: String;
  Repository: TDepartmentPostgresRepository);
begin

  inherited Create;

  FCode := Code;
  FRepository := Repository;
  
end;

function TFindDepartmentByCodeCriterion.GetExpression: String;
var
    CodeColumnName: String;
begin

  CodeColumnName :=
    FRepository
      .TableMapping
        .FindSelectColumnMappingByObjectPropertyName('Code')
          .ColumnName;

  Result :=
    (CodeColumnName + '=' + QuotedStr(FCode)) +
    ' AND ' + DEPARTMENT_TABLE_INACTIVE_STATUS_FIELD + ' IS NULL';
  
end;

end.
