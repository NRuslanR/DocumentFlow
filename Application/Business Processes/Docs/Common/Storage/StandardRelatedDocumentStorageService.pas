unit StandardRelatedDocumentStorageService;

interface

uses
  BusinessProcessService,
  RelatedDocumentStorageService,
  DocumentRepositoryRegistry,
  DocumentDirectory,
  DocumentInfoReadService,
  DocumentUsageEmployeeAccessRightsService,
  IEmployeeRepositoryUnit,
  DocumentStorageServiceCommandsAndRespones,
  Session,
  DocumentKindsMapper,
  DocumentKindRepository,
  DocumentUsageEmployeeAccessRightsInfoDTO,
  DocumentUsageEmployeeAccessRightsInfo,
  DocumentUsageEmployeeAccessRightsInfoDTOMapper,
  DocumentKind,
  DocumentFullInfoDTO,
  Document,
  Employee,
  IDocumentUnit,
  SysUtils,
  Classes;
  
type

  TStandardRelatedDocumentStorageService =
    class (
      TBusinessProcessService,
      IRelatedDocumentStorageService
    )

      private

        FDocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper;

        FSourceDocumentDirectory: IDocumentDirectory;
        FDocumentKindRepository: IDocumentKindRepository;
        FDocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;
        FEmployeeRepository: IEmployeeRepository;

      private

        FDocumentKindsMapper: TDocumentKindsMapper;

        function MapRelatedDocumentUsageEmployeeAccessRightsInfoDTOFrom(
          DocumentUsageEmployeeAccessRightsInfo: TDocumentUsageEmployeeAccessRightsInfo
        ): IDocumentUsageEmployeeAccessRightsInfoDTO;

      protected

        function GetSourceDocumentFromRepository(
          const SourceDocumentId: Variant
        ): IDocument;
        
      public

        constructor Create(
          Session: ISession;
          SourceDocumentDirectory: IDocumentDirectory;
          DocumentKindRepository: IDocumentKindRepository;
          DocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;
          EmployeeRepository: IEmployeeRepository;
          DocumentKindsMapper: TDocumentKindsMapper;
          DocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper
        );

        function GetRelatedDocumentFullInfo(
          RelatedDocumentFullInfoCommand: TGettingRelatedDocumentFullInfoCommand
        ): TGettingDocumentFullInfoCommandResult;
        
    end;
  
implementation

uses

  IDomainObjectBaseUnit,
  DocumentChargeKindDtoDomainMapper,
  DocumentRuleRegistry,
  DocumentStorageServiceRegistry,
  ApplicationServiceRegistries;
  
{ TStandardRelatedDocumentStorageService }

constructor TStandardRelatedDocumentStorageService.Create(
  Session: ISession;
  SourceDocumentDirectory: IDocumentDirectory;
  DocumentKindRepository: IDocumentKindRepository;
  DocumentUsageEmployeeAccessRightsService: IDocumentUsageEmployeeAccessRightsService;
  EmployeeRepository: IEmployeeRepository;
  DocumentKindsMapper: TDocumentKindsMapper;
  DocumentUsageEmployeeAccessRightsInfoDTOMapper: TDocumentUsageEmployeeAccessRightsInfoDTOMapper
);
begin

  inherited Create(Session);

  FSourceDocumentDirectory := SourceDocumentDirectory;
  FDocumentKindRepository := DocumentKindRepository;
  FDocumentUsageEmployeeAccessRightsService := DocumentUsageEmployeeAccessRightsService;
  FEmployeeRepository := EmployeeRepository;

  FDocumentKindsMapper := DocumentKindsMapper;
  FDocumentUsageEmployeeAccessRightsInfoDTOMapper := DocumentUsageEmployeeAccessRightsInfoDTOMapper;

end;

function TStandardRelatedDocumentStorageService.GetRelatedDocumentFullInfo(
  RelatedDocumentFullInfoCommand: TGettingRelatedDocumentFullInfoCommand
): TGettingDocumentFullInfoCommandResult;
var FreeCommand: IGettingRelatedDocumentFullInfoCommand;

    SourceDocument: IDocument;

    RelatedDocumentKind: TDocumentKind;
    FreeRelatedDocumentKind: IDomainObjectBase;
    
    RelatedDocument: IDocument;

    RelatedDocumentDirectory: IDocumentDirectory;
    RelatedDocumentInfoReadService: IDocumentInfoReadService;
    RelatedDocumentUsageAccessRightsInfo: TDocumentUsageEmployeeAccessRightsInfo;
    FreeRelatedDocumentUsageAccessRightsInfo: IDomainObjectBase;
    
    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;

    RelatedDocumentUsageAccessRightsInfoDTO: IDocumentUsageEmployeeAccessRightsInfoDTO;
    RelatedDocumentFullInfoDTO: TDocumentFullInfoDTO;
begin

  FreeCommand := RelatedDocumentFullInfoCommand;

  try

    FSession.Start;

    RelatedDocumentKind :=
      FDocumentKindRepository.FindDocumentKindByIdentity(
        RelatedDocumentFullInfoCommand.RelatedDocumentKindId
      );

    FreeRelatedDocumentKind := RelatedDocumentKind;
    
    if not Assigned(RelatedDocumentKind) then begin

      RaiseFailedBusinessProcessServiceException(
        '»нформаци€ о типе св€занного ' +
        'документа не найдена'
      );
      
    end;

    Employee :=
      FEmployeeRepository.FindEmployeeById(
        RelatedDocumentFullInfoCommand.EmployeeId
      );

    FreeEmployee := Employee;

    if not Assigned(Employee) then begin

      RaiseFailedBusinessProcessServiceException(
        '«апрашивающий св€занный документ ' +
        'сотрудник не найден'
      );
      
    end;
    
    SourceDocument :=
      GetSourceDocumentFromRepository(
        RelatedDocumentFullInfoCommand.SourceDocumentId
      );

    if not Assigned(SourceDocument) then begin

      RaiseFailedBusinessProcessServiceException(
        '»сходный документ, через который ' +
        'осуществл€лс€ доступ к св€занному, ' +
        'не найден'
      );
      
    end;

    RelatedDocumentDirectory :=
      TDocumentStorageServiceRegistry.Instance.GetDocumentDirectory(
        RelatedDocumentKind.DocumentClass
      );
      
    if not Assigned(RelatedDocumentDirectory) then begin

      RaiseFailedBusinessProcessServiceException(
        'Ќе найдено хранилище дл€ документов ' +
        'типа "%s"',
        [RelatedDocumentKind.Name]
      );
      
    end;

    RelatedDocument :=
      RelatedDocumentDirectory.FindDocumentById(
        RelatedDocumentFullInfoCommand.RelatedDocumentId
      );

    if not Assigned(RelatedDocument) then begin

      RaiseFailedBusinessProcessServiceException(
        '—в€занный документ не найден'
      );
      
    end;

    RelatedDocumentUsageAccessRightsInfo := 
      FDocumentUsageEmployeeAccessRightsService.
        EnsureThatEmployeeHasRelatedDocumentUsageAccessRights(
          SourceDocument,
          RelatedDocument,
          RelatedDocumentKind,
          Employee
        );

    FreeRelatedDocumentUsageAccessRightsInfo :=
      RelatedDocumentUsageAccessRightsInfo;
      
    FSession.Commit;

    { Refactor: внедр€ть через конструктор
      реестр служб чтени€ информации о документах }
      
    RelatedDocumentInfoReadService :=
      TApplicationServiceRegistries
      .Current
      .GetPresentationServiceRegistry
      .GetDocumentInfoReadService(
        FDocumentKindsMapper.MapDomainDocumentKindToDocumentKind(
          RelatedDocumentKind.DocumentClass
        )
      );

    RelatedDocumentFullInfoDTO :=
      RelatedDocumentInfoReadService.GetDocumentFullInfo(
        RelatedDocumentFullInfoCommand.RelatedDocumentId
      );

    RelatedDocumentUsageAccessRightsInfoDTO :=
      MapRelatedDocumentUsageEmployeeAccessRightsInfoDTOFrom(
        RelatedDocumentUsageAccessRightsInfo
      );
      
    Result :=
      TGettingDocumentFullInfoCommandResult.Create(
        RelatedDocumentFullInfoDTO,
        RelatedDocumentUsageAccessRightsInfoDTO
      );
      
  except

    on e: Exception do begin

      FSession.Rollback;

      RaiseFailedBusinessProcessServiceException(e.Message);
      
    end;

  end;
  
end;

function TStandardRelatedDocumentStorageService.GetSourceDocumentFromRepository(
  const SourceDocumentId: Variant): IDocument;
begin

  Result := FSourceDocumentDirectory.FindDocumentById(SourceDocumentId);

end;

function TStandardRelatedDocumentStorageService.
  MapRelatedDocumentUsageEmployeeAccessRightsInfoDTOFrom(
    DocumentUsageEmployeeAccessRightsInfo: TDocumentUsageEmployeeAccessRightsInfo
  ): IDocumentUsageEmployeeAccessRightsInfoDTO;
begin

  Result :=
    FDocumentUsageEmployeeAccessRightsInfoDTOMapper.
      MapDocumentUsageEmployeeAccessRightsInfoDTOFrom(
        DocumentUsageEmployeeAccessRightsInfo
      );
    
end;

end.
