unit StandardEmployeeDocumentKindAccessRightsAppService;

interface

uses

  EmployeeDocumentKindAccessRightsInfo,
  EmployeeDocumentKindAccessRightsInfoDto,
  EmployeeDocumentKindAccessRightsService,
  EmployeeDocumentKindAccessRightsAppService,
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
        FDocumentKindsMapper: TDocumentKindsMapper;

        function MapEmployeeDocumentKindAccessRightsInfoDtoFrom(
          EmployeeDocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
        ): TEmployeeDocumentKindAccessRightsInfoDto;

        function GetEmployeeFromRepository(const EmployeeId: Variant): TEmployee;
    
      public

        destructor Destroy; override;
        
        constructor Create(
          Session: ISession;
          EmployeeRepository: IEmployeeRepository;
          EmployeeDocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService
        );
        
        function GetDocumentKindAccessRightsInfoForEmployee(
          const DocumentKind: TDocumentKindClass;
          const EmployeeId: Variant
        ): TEmployeeDocumentKindAccessRightsInfoDto; virtual;

        function EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
          DocumentKind: TClass;
          const EmployeeId: Variant
        ): TEmployeeDocumentKindAccessRightsInfoDto; virtual;

        
    end;


implementation

uses

  IDomainObjectBaseUnit;
  
{ TStandardEmployeeDocumentKindAccessRightsAppService }

constructor TStandardEmployeeDocumentKindAccessRightsAppService.Create(
  Session: ISession;
  EmployeeRepository: IEmployeeRepository;
  EmployeeDocumentKindAccessRightsService: IEmployeeDocumentKindAccessRightsService
);
begin

  inherited Create(Session);

  FEmployeeRepository := EmployeeRepository;
  FEmployeeDocumentKindAccessRightsService := EmployeeDocumentKindAccessRightsService;

  FDocumentKindsMapper := TDocumentKindsMapper.Create;
  
end;

destructor TStandardEmployeeDocumentKindAccessRightsAppService.Destroy;
begin

  FreeAndNil(FDocumentKindsMapper);
  
  inherited;

end;

function TStandardEmployeeDocumentKindAccessRightsAppService.
  EnsureThatEmployeeCanCreateDocumentsAndGetAllAccessRightsInfo(
    DocumentKind: TClass;
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

  Result.EmployeeCanCreateDocuments :=
    EmployeeDocumentKindAccessRightsInfo.CanCreateDocuments;

  Result.EmployeeCanMarkDocumentsAsSelfRegistered :=
    EmployeeDocumentKindAccessRightsInfo.CanMarkDocumentsAsSelfRegistered;

end;

end.
