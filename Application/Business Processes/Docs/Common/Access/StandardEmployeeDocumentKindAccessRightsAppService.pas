unit StandardEmployeeDocumentKindAccessRightsAppService;

interface

uses

  EmployeeDocumentKindAccessRightsInfo,
  EmployeeDocumentKindAccessRightsInfoDto,
  EmployeeDocumentKindAccessRightsService,
  EmployeeDocumentKindAccessRightsAppService,
  NativeDocumentKindsReadService,
  DocumentKinds,
  DocumentKindsMapper,
  BusinessProcessService,
  IEmployeeRepositoryUnit,
  Employee,
  Session,
  SysUtils,
  Classes;

type

  TStandardEmployeeDocumentKindAccessRightsAppService =
    class (TBusinessProcessService, IEmployeeDocumentKindAccessRightsAppService)

      protected

        FEmployeeRepository: IEmployeeRepository;
        FEmployeeDocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService;

        FNativeDocumentKindsReadService: INativeDocumentKindsReadService;
        FDocumentKindsMapper: IDocumentKindsMapper;

        function MapEmployeeDocumentKindAccessRightsInfoDtoFrom(
          EmployeeDocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
        ): TEmployeeDocumentKindAccessRightsInfoDto;

        function GetEmployeeFromRepository(const EmployeeId: Variant): TEmployee;
    
      public
        
        constructor Create(
          Session: ISession;
          EmployeeRepository: IEmployeeRepository;
          EmployeeDocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService;
          NativeDocumentKindsReadService: INativeDocumentKindsReadService;
          DocumentKindsMapper: IDocumentKindsMapper
        );
        
        function GetDocumentKindAccessRightsInfoForEmployee(
          const DocumentKind: TDocumentKindClass;
          const EmployeeId: Variant
        ): TEmployeeDocumentKindAccessRightsInfoDto; virtual;

        function EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
          DocumentKind: TClass;
          const EmployeeId: Variant
        ): TEmployeeDocumentKindAccessRightsInfoDto; overload; virtual;

        function EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
          const DocumentKindId: Variant;
          const EmployeeId: Variant
        ): TEmployeeDocumentKindAccessRightsInfoDto; overload;

        function EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
          const DocumentKindClass: TDocumentKindClass;
          const EmployeeId: Variant
        ): TEmployeeDocumentKindAccessRightsInfoDto; overload;

        function EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
          const DocumentKindId: Variant;
          const EmployeeId: Variant
        ): TEmployeeDocumentKindAccessRightsInfoDto; overload;
        
    end;

implementation

uses

  DocumentKindDto,
  IDomainObjectBaseUnit;
  
{ TStandardEmployeeDocumentKindAccessRightsAppService }

constructor TStandardEmployeeDocumentKindAccessRightsAppService.Create(
  Session: ISession;
  EmployeeRepository: IEmployeeRepository;
  EmployeeDocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService;
  NativeDocumentKindsReadService: INativeDocumentKindsReadService;
  DocumentKindsMapper: IDocumentKindsMapper
);
begin

  inherited Create(Session);

  FEmployeeRepository := EmployeeRepository;
  FEmployeeDocumentKindAccessRightsService := EmployeeDocumentKindAccessRightsService;

  FNativeDocumentKindsReadService := NativeDocumentKindsReadService;
  FDocumentKindsMapper := DocumentKindsMapper;
  
end;

function TStandardEmployeeDocumentKindAccessRightsAppService
    .EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
      const DocumentKindId,
      EmployeeId: Variant
    ): TEmployeeDocumentKindAccessRightsInfoDto;
var
    DocumentKindDto: TDocumentKindDto;
begin

  DocumentKindDto :=
    FNativeDocumentKindsReadService
      .GetNativeDocumentKindDtos
        .FindByIdOrRaise(DocumentKindId);

  Result :=
    EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
      DocumentKindDto.ServiceType,
      EmployeeId
    );

end;

function TStandardEmployeeDocumentKindAccessRightsAppService
  .EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
    const DocumentKindId: Variant;
    const EmployeeId: Variant
  ): TEmployeeDocumentKindAccessRightsInfoDto;
var
    DocumentKindDto: TDocumentKindDto;
begin

  DocumentKindDto :=
    FNativeDocumentKindsReadService
      .GetNativeDocumentKindDtos
        .FindByIdOrRaise(DocumentKindId);

  Result :=
    EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
      DocumentKindDto.ServiceType, EmployeeId
    );
    
end;

function TStandardEmployeeDocumentKindAccessRightsAppService
  .EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
    const DocumentKindClass: TDocumentKindClass;
    const EmployeeId: Variant
  ): TEmployeeDocumentKindAccessRightsInfoDto;
var
    DocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo;
    FreeDocumentKindAccessRightsInfo: IDomainObjectBase;

    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;
begin

  Employee := GetEmployeeFromRepository(EmployeeId);

  FreeEmployee := Employee;

  DocumentKindAccessRightsInfo :=
    FEmployeeDocumentKindAccessRightsService
      .EnsureThatEmployeeHasAnyDocumentKindAccessRightsAndGetAll(
        FDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(DocumentKindClass),
        Employee
      );

  FreeDocumentKindAccessRightsInfo := DocumentKindAccessRightsInfo;

  Result :=
    MapEmployeeDocumentKindAccessRightsInfoDtoFrom(
      DocumentKindAccessRightsInfo
    );

end;

function TStandardEmployeeDocumentKindAccessRightsAppService.
  EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
    DocumentKind: TClass;
    const EmployeeId: Variant
  ): TEmployeeDocumentKindAccessRightsInfoDto;
var
    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;

    EmployeeDocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo;
    FreeEmployeeDocumentKindAccessRightsInfo: IDomainObjectBase;
begin

  Employee := GetEmployeeFromRepository(EmployeeId);

  FreeEmployee := Employee;

  EmployeeDocumentKindAccessRightsInfo :=
    FEmployeeDocumentKindAccessRightsService.
      EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
        FDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
          TDocumentKindClass(DocumentKind)
        ),
        Employee
      );

  FreeEmployeeDocumentKindAccessRightsInfo :=
    EmployeeDocumentKindAccessRightsInfo;

  Result :=
    MapEmployeeDocumentKindAccessRightsInfoDtoFrom(
      EmployeeDocumentKindAccessRightsInfo
    );
  
end;

function TStandardEmployeeDocumentKindAccessRightsAppService.
  GetDocumentKindAccessRightsInfoForEmployee(
    const DocumentKind: TDocumentKindClass;
    const EmployeeId: Variant
  ): TEmployeeDocumentKindAccessRightsInfoDto;
var Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;

    EmployeeDocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo;
    FreeEmployeeDocumentKindAccessRightsInfo: IDomainObjectBase;
begin

  Employee := GetEmployeeFromRepository(EmployeeId);

  FreeEmployee := Employee;

  EmployeeDocumentKindAccessRightsInfo :=
    FEmployeeDocumentKindAccessRightsService.
      GetDocumentKindAccessRightsInfoForEmployee(
        FDocumentKindsMapper.MapDocumentKindToDomainDocumentKind(
          TDocumentKindClass(DocumentKind)
        ),
        Employee
      );

  FreeEmployeeDocumentKindAccessRightsInfo :=
    EmployeeDocumentKindAccessRightsInfo;

  Result :=
    MapEmployeeDocumentKindAccessRightsInfoDtoFrom(
      EmployeeDocumentKindAccessRightsInfo
    );

end;

function TStandardEmployeeDocumentKindAccessRightsAppService.
  GetEmployeeFromRepository(
    const EmployeeId: Variant
  ): TEmployee;
begin

  Result := FEmployeeRepository.FindEmployeeById(EmployeeId);

  if not Assigned(Result) then begin

    raise TEmployeeDocumentKindAccessRightsAppServiceException.Create(
      'Информация о сотруднике, проверяемом ' +
      'на доступ к виду документов, не найдена'
    );
    
  end;

end;

function TStandardEmployeeDocumentKindAccessRightsAppService.
  MapEmployeeDocumentKindAccessRightsInfoDtoFrom(
    EmployeeDocumentKindAccessRightsInfo:
      TEmployeeDocumentKindAccessRightsInfo
  ): TEmployeeDocumentKindAccessRightsInfoDto;
begin

  Result := TEmployeeDocumentKindAccessRightsInfoDto.Create;

  with EmployeeDocumentKindAccessRightsInfo do begin

    Result.CanViewDocuments := CanViewDocuments;
    Result.CanCreateDocuments := CanCreateDocuments;
    Result.CanCreateRespondingDocuments := CanCreateRespondingDocuments;
    Result.CanEditDocuments := CanEditDocuments;
    Result.CanRemoveDocuments := CanRemoveDocuments;
    Result.CanMarkDocumentsAsSelfRegistered := CanMarkDocumentsAsSelfRegistered;
    Result.DocumentNumberPrefixPatternType :=
      TDocumentNumberPrefixPatternTypeDto(
        DocumentNumberPrefixPatternType
      );

  end;

end;

end.
