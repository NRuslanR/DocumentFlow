unit BasedOnDatabaseDocumentCreatingDefaultInfoReadService;

interface

uses

  DocumentCreatingDefaultInfoDTO,
  DocumentCreatingDefaultInfoDataSetHolder,
  DocumentCreatingDefaultInfoReadService,
  EmployeeFinder,
  QueryExecutor,
  EmployeeSubordinationService,
  AbstractQueryExecutor,
  DataReader,
  AbstractDataReader,
  AbstractDataSetHolder,
  AbstractApplicationService,
  Employee,
  DB,
  SysUtils,
  Classes;

type

  TDocumentCreatingDefaultInfoWithSignerInfoFetchingQueryPatternInfo = record

    QueryPattern: String;
    EmployeeIdParamName: String;
    SignerIdParamName: String;
            
  end;

  TDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQueryPatternInfo = record

    QueryPattern: String;
    EmployeeIdParamName: String;
            
  end;

  TDocumentCreatingDefaultInfoFetchingQueryBuilder = class abstract

    public

      function BuildDocumentCreatingDefaultInfoWithSignerInfoFetchingQuery(
        const FieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames;
        const ResponsibleIdParamName: String;
        const SignerIdParamName: String
      ): String; virtual; abstract;

      function BuildDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQuery(
        const FieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames;
        const ResponsibleIdParamName: String
      ): String; virtual; abstract;
      
  end;

  TBasedOnDatabaseDocumentCreatingDefaultInfoReadService =
    class (TAbstractApplicationService, IDocumentCreatingDefaultInfoReadService)

      protected

        FEmployeeFinder: IEmployeeFinder;
        FEmployeeSubordinationService: IEmployeeSubordinationService;

      protected

        FDocumentCreatingDefaultInfoWithSignerInfoFetchingQueryPatternInfo:
          TDocumentCreatingDefaultInfoWithSignerInfoFetchingQueryPatternInfo;

        FDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQueryPatternInfo:
          TDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQueryPatternInfo;
          
        FQueryExecutor: IQueryExecutor;
        FQueryBuilder: TDocumentCreatingDefaultInfoFetchingQueryBuilder;
        
      protected

        function PrepareDocumentCreatingDefaultInfoWithSignerInfoFetchingQueryPattern:
          TDocumentCreatingDefaultInfoWithSignerInfoFetchingQueryPatternInfo; virtual; abstract;

        function PrepareDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQueryPattern:
          TDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQueryPatternInfo; virtual; abstract;

        function ExecuteDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQuery(

          const QueryPattern: String;
          const ResponsibleIdParamName: String;
          const ResponsibleId: Variant

        ): IDataReader; virtual;
        
        function ExecuteDocumentCreatingDefaultInfoWithSignerInfoFetchingQuery(

          const QueryPattern: String;
          const ResponsibleIdParamName, SignerIdParamName: String;
          const ResponsibleId, SignerId: Variant

        ): IDataReader; virtual;
        
      protected

        function CreateDocumentCreatingDefaultInfoDataSetHolderFrom(
          const EmployeeId: Variant;
          const DefaultSignerId: Variant
        ): TDocumentCreatingDefaultInfoDataSetHolder; virtual;

        function CreateDocumentCreatingDefaultInfoDataSetHolderInstance:
          TDocumentCreatingDefaultInfoDataSetHolder; virtual;

        function CreateDocumentCreatingDefaultInfoDataSetFieldNames:
          TDocumentCreatingDefaultInfoDataSetFieldNames; virtual;

        function CreateDocumentCreatingDefaultInfoDataSetFieldNamesInstance:
          TDocumentCreatingDefaultInfoDataSetFieldNames; virtual;

        procedure FillDocumentCreatingDefaultInfoDataSetFieldNames(
          FieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames
        ); virtual;

      protected

        function CreateDocumentCreatingDefaultInfoDTOInstance:
          TDocumentCreatingDefaultInfoDTO; virtual;

      protected

        function GetDefaultDocumentSignerForEmployee(const EmployeeId: Variant): TEmployee; virtual;

        function FindDefaultDocumentSignerForEmployee(const Employee: TEmployee): TEmployee; virtual;
        
      protected

        function MapDocumentCreatingDefaultInfoDTOFrom(

          DocumentCreatingDefaultInfoDataSetHolder:
            TDocumentCreatingDefaultInfoDataSetHolder;

          const DefaultSignerId: Variant

        ): TDocumentCreatingDefaultInfoDTO; virtual;

      public

        destructor Destroy; override;
        
        constructor Create(
          EmployeeFinder: IEmployeeFinder;
          EmployeeSubordinationService: IEmployeeSubordinationService;
          QueryExecutor: TAbstractQueryExecutor;
          QueryBuilder: TDocumentCreatingDefaultInfoFetchingQueryBuilder
        );
        
        function GetDocumentCreatingDefaultInfoForEmployee(
          const EmployeeId: Variant
        ): TDocumentCreatingDefaultInfoDTO; virtual;
        
    end;
    
implementation

uses

  IDomainObjectUnit,
  IDomainObjectListUnit,
  Variants,
  DepartmentInfoDTO,
  DocumentResponsibleInfoDTO,
  DocumentFlowEmployeeInfoDTO;
  
{ TBasedOnDatabaseDocumentCreatingDefaultInfoReadService }

constructor TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.Create(
  EmployeeFinder: IEmployeeFinder;
  EmployeeSubordinationService: IEmployeeSubordinationService;
  QueryExecutor: TAbstractQueryExecutor;
  QueryBuilder: TDocumentCreatingDefaultInfoFetchingQueryBuilder
);
begin

  inherited Create;

  FEmployeeFinder := EmployeeFinder;
  FEmployeeSubordinationService := EmployeeSubordinationService;
  FQueryExecutor := QueryExecutor;
  FQueryBuilder := QueryBuilder;

  {
  FDocumentCreatingDefaultInfoWithSignerInfoFetchingQueryPatternInfo :=
    PrepareDocumentCreatingDefaultInfoWithSignerInfoFetchingQueryPattern;

  FDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQueryPatternInfo :=
    PrepareDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQueryPattern;
   }
end;

function TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.
  GetDefaultDocumentSignerForEmployee(const EmployeeId: Variant): TEmployee;
var
    Employee: TEmployee;
    FreeEmployee: IDomainObject;
begin

  Employee := FEmployeeFinder.FindEmployee(EmployeeId);

  FreeEmployee := Employee;

  Result := FindDefaultDocumentSignerForEmployee(Employee);

end;

function TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.
GetDocumentCreatingDefaultInfoForEmployee(
  const EmployeeId: Variant
): TDocumentCreatingDefaultInfoDTO;
var DocumentCreatingDefaultInfoDataSetHolder:
      TDocumentCreatingDefaultInfoDataSetHolder;
      
    HighestLeader: TEmployee;
    FreeHighestLeader: IDomainObject;

    TopLevelEmployees: TEmployees;
    TopLevelEmployee: TEmployee;
    FreeTopLevelEmployees: IDomainObjectList;

    TopLevelLeaders: TEmployees;
    FreeTopLevelLeaders: IDomainObjectList;

    DefaultSignerId: Variant;
begin

  HighestLeader := GetDefaultDocumentSignerForEmployee(EmployeeId);

  FreeHighestLeader := HighestLeader;

  if Assigned(HighestLeader) then
    DefaultSignerId := HighestLeader.Identity

  else DefaultSignerId := Null;

  DocumentCreatingDefaultInfoDataSetHolder :=
    CreateDocumentCreatingDefaultInfoDataSetHolderFrom(
      EmployeeId,
      DefaultSignerId
    );
    
  try

    Result :=
      MapDocumentCreatingDefaultInfoDTOFrom(
        DocumentCreatingDefaultInfoDataSetHolder,
        DefaultSignerId
      );

  finally

    FreeAndNil(DocumentCreatingDefaultInfoDataSetHolder);
    
  end;

end;

function TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.
  CreateDocumentCreatingDefaultInfoDataSetFieldNames:
    TDocumentCreatingDefaultInfoDataSetFieldNames;
begin

  Result := CreateDocumentCreatingDefaultInfoDataSetFieldNamesInstance;

  try

    FillDocumentCreatingDefaultInfoDataSetFieldNames(Result);

  except

    on E: Exception do begin

      FreeAndNil(Result);

      raise;

    end;

  end;

end;

function TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.
  CreateDocumentCreatingDefaultInfoDataSetFieldNamesInstance:
    TDocumentCreatingDefaultInfoDataSetFieldNames;
begin

  Result := TDocumentCreatingDefaultInfoDataSetFieldNames.Create;

end;

function TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.
  CreateDocumentCreatingDefaultInfoDataSetHolderFrom(
    const EmployeeId,
    DefaultSignerId: Variant
  ): TDocumentCreatingDefaultInfoDataSetHolder;
var DataReader: IDataReader;
    DocumentCreatingDefaultInfoDataSet: TDataSet;
    DocumentCreatingDefaultInfoDataSetFieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames;
begin

  Result := nil;
  DocumentCreatingDefaultInfoDataSet := nil;

  DocumentCreatingDefaultInfoDataSetFieldNames :=
    CreateDocumentCreatingDefaultInfoDataSetFieldNames;
  
  try

    if not VarIsNull(DefaultSignerId) then begin

      DataReader :=
        ExecuteDocumentCreatingDefaultInfoWithSignerInfoFetchingQuery(
          FQueryBuilder.BuildDocumentCreatingDefaultInfoWithSignerInfoFetchingQuery(
            DocumentCreatingDefaultInfoDataSetFieldNames,
            'presponsible_id',
            'psigner_id'
          ),
          'presponsible_id', 'psigner_id',
          EmployeeId, DefaultSignerId
          //FDocumentCreatingDefaultInfoWithSignerInfoFetchingQueryPatternInfo
        );

    end

    else begin

      DataReader :=
        ExecuteDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQuery(
          FQueryBuilder.BuildDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQuery(
            DocumentCreatingDefaultInfoDataSetFieldNames,
            'presponsible_id'
          ),
          'presponsible_id',
          EmployeeId
          //FDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQueryPatternInfo
        );
        
    end;

    DocumentCreatingDefaultInfoDataSet :=
      TAbstractDataReader(DataReader.Self).ToDataSet;

    Result :=
      CreateDocumentCreatingDefaultInfoDataSetHolderInstance;

    Result.DataSet := DocumentCreatingDefaultInfoDataSet;
    Result.FieldNames := DocumentCreatingDefaultInfoDataSetFieldNames;
    
  except

    on e: Exception do begin

      if Assigned(Result) then
        FreeAndNil(Result)

      else begin

        FreeAndNil(DocumentCreatingDefaultInfoDataSet);
        FreeAndNil(DocumentCreatingDefaultInfoDataSetFieldNames);

      end;

      Raise;

    end;

  end;

end;

function TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.
  CreateDocumentCreatingDefaultInfoDataSetHolderInstance:
    TDocumentCreatingDefaultInfoDataSetHolder;
begin

  Result := TDocumentCreatingDefaultInfoDataSetHolder.Create;

end;

function TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.
  CreateDocumentCreatingDefaultInfoDTOInstance: TDocumentCreatingDefaultInfoDTO;
begin

  Result := TDocumentCreatingDefaultInfoDTO.Create;

end;

destructor TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.Destroy;
begin

  FreeAndNil(FQueryBuilder);
  
  inherited;

end;

function TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.
  ExecuteDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQuery(

    const QueryPattern: String;
    const ResponsibleIdParamName: String;
    const ResponsibleId: Variant
                              {
    const DocumentCreatingDefaultInfoFetchingQueryPatternInfo:
      TDocumentCreatingDefaultInfoWithoutSignerInfoFetchingQueryPatternInfo   }

  ): IDataReader;
var QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams.Add(ResponsibleIdParamName, ResponsibleId);

    Result := FQueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);
      
  finally

    FreeAndNil(QueryParams);

  end;

end;

function TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.
  ExecuteDocumentCreatingDefaultInfoWithSignerInfoFetchingQuery(
    const QueryPattern: String;
    const ResponsibleIdParamName, SignerIdParamName: String;
    const ResponsibleId, SignerId: Variant
    {
    const DocumentCreatingDefaultInfoFetchingQueryPatternInfo:
      TDocumentCreatingDefaultInfoWithSignerInfoFetchingQueryPatternInfo }
  ): IDataReader;
var QueryParams: TQueryParams;
begin

  QueryParams := TQueryParams.Create;

  try

    QueryParams
      .AddFluently(ResponsibleIdParamName, ResponsibleId)
      .AddFluently(SignerIdParamName, SignerId);

    Result := FQueryExecutor.ExecuteSelectionQuery(QueryPattern, QueryParams);

  finally

    FreeAndNil(QueryParams);

  end;

end;

procedure TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.FillDocumentCreatingDefaultInfoDataSetFieldNames(
  FieldNames: TDocumentCreatingDefaultInfoDataSetFieldNames);
begin

  FieldNames.DocumentResponsibleIdFieldName :=  'doc_responsible_id';
  FieldNames.DocumentResponsibleNameFieldName := 'doc_responsible_name';
  FieldNames.DocumentResponsibleTelephoneNumberFieldName := 'doc_responsible_telephone_number';
  FieldNames.DocumentResponsibleDepartmentIdFieldName := 'doc_responsible_dep_id';
  FieldNames.DocumentResponsibleDepartmentCodeFieldName := 'doc_responsible_dep_code';
  FieldNames.DocumentResponsibleDepartmentNameFieldName := 'doc_responsible_dep_name';

  FieldNames.DocumentSignerIdFieldName := 'doc_signer_id';
  FieldNames.DocumentSignerLeaderIdFieldName := 'doc_signer_leader_id';
  FieldNames.DocumentSignerRoleIdFieldName := 'doc_signer_role_id';
  FieldNames.DocumentSignerIsForeignFieldName := 'doc_signer_is_foreign';
  FieldNames.DocumentSignerNameFieldName := 'doc_signer_name';
  FieldNames.DocumentSignerSpecialityFieldName := 'doc_signer_speciality';
  FieldNames.DocumentSignerDepartmentIdFieldName := 'doc_signer_dep_id';
  FieldNames.DocumentSignerDepartmentCodeFieldName := 'doc_signer_dep_code';
  FieldNames.DocumentSignerDepartmentNameFieldName := 'doc_signer_dep_name';
  
end;

function TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.FindDefaultDocumentSignerForEmployee(
  const Employee: TEmployee): TEmployee;
begin

  Result :=
    FEmployeeSubordinationService
      .FindHighestSameHeadKindredDepartmentBusinessLeaderForEmployee(Employee);

end;

function TBasedOnDatabaseDocumentCreatingDefaultInfoReadService.
  MapDocumentCreatingDefaultInfoDTOFrom(

    DocumentCreatingDefaultInfoDataSetHolder:
      TDocumentCreatingDefaultInfoDataSetHolder;

    const DefaultSignerId: Variant

  ): TDocumentCreatingDefaultInfoDTO;
begin

  Result := CreateDocumentCreatingDefaultInfoDTOInstance;
  
  try

    with DocumentCreatingDefaultInfoDataSetHolder do begin

      Result.DocumentResponsibleInfoDTO := TDocumentResponsibleInfoDTO.Create;

      Result.DocumentResponsibleInfoDTO.Id :=
        DocumentResponsibleIdFieldValue;

      Result.DocumentResponsibleInfoDTO.Name :=
        DocumentResponsibleNameFieldValue;

      if not VarIsNull(DocumentResponsibleTelephoneNumberFieldValue)
      then begin

        Result.DocumentResponsibleInfoDTO.TelephoneNumber :=
          DocumentResponsibleTelephoneNumberFieldValue;

      end;

      Result.DocumentResponsibleInfoDTO.DepartmentInfoDTO :=
        TDepartmentInfoDTO.Create;
        
      Result.DocumentResponsibleInfoDTO.DepartmentInfoDTO.Id :=
        DocumentResponsibleDepartmentIdFieldValue;

      Result.DocumentResponsibleInfoDTO.DepartmentInfoDTO.Code :=
        DocumentResponsibleDepartmentCodeFieldValue;

      Result.DocumentResponsibleInfoDTO.DepartmentInfoDTO.Name :=
        DocumentResponsibleDepartmentNameFieldValue;

      if VarIsNull(DefaultSignerId) then Exit;

      Result.DocumentSignerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;

      Result.DocumentSignerInfoDTO.Id :=
        DocumentSignerIdFieldValue;

      Result.DocumentSignerInfoDTO.RoleId :=
        DocumentSignerRoleIdFieldValue;

      Result.DocumentSignerInfoDTO.IsForeign :=
        DocumentSignerIsForeignFieldValue;

      Result.DocumentSignerInfoDTO.LeaderId :=
        DocumentSignerLeaderIdFieldValue;

      Result.DocumentSignerInfoDTO.FullName :=
        DocumentSignerNameFieldValue;

      Result.DocumentSignerInfoDTO.Speciality :=
        DocumentSignerSpecialityFieldValue;

      Result.DocumentSignerInfoDTO.DepartmentInfoDTO :=
        TDepartmentInfoDTO.Create;

      Result.DocumentSignerInfoDTO.DepartmentInfoDTO.Id :=
        DocumentSignerDepartmentIdFieldValue;

      Result.DocumentSignerInfoDTO.DepartmentInfoDTO.Code :=
        DocumentSignerDepartmentCodeFieldValue;

      Result.DocumentSignerInfoDTO.DepartmentInfoDTO.Name :=
        DocumentSignerDepartmentNameFieldValue;
        
    end;

  except

    FreeAndNil(Result);

    Raise;
      
  end;

end;

end.
