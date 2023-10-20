unit StandardDocumentChargeControlAppService;

interface

uses

  DocumentChargeCreatingService,
  DocumentChargeControlAppService,
  DocumentChargeAccessRightsService,
  AbstractApplicationService,
  DocumentFullInfoDTO,
  DocumentChargeSheetsInfoDTO,
  EmployeeDocumentOperationService,
  Session,
  DocumentChargeControlService,
  Document,
  IDocumentUnit,
  Employee,
  DocumentChargeInterface,
  DocumentDirectory,
  DocumentChargeAccessRights,
  IEmployeeRepositoryUnit,
  VariantListUnit,
  DocumentChargesInfoDTODomainMapper,
  SysUtils;

type

  TStandardDocumentChargeControlAppService =
    class (TEmployeeDocumentOperationService, IDocumentChargeControlAppService)

      protected

        FChargeControlService: IDocumentChargeControlService;
        FChargesInfoDTODomainMapper: IDocumentChargesInfoDTODomainMapper;

        function CreateChargeInfoDTOs(
          DocumentCharges: IDocumentCharges;
          AccessRightsList: TDocumentChargeAccessRightsList
        ): TDocumentChargesInfoDTO;

        function CreateChargeInfoDTO(
          DocumentCharge: IDocumentCharge;
          AccessRights: TDocumentChargeAccessRights
        ): TDocumentChargeInfoDTO;
        
      public

        constructor Create(
          Session: ISession;
          DocumentDirectory: IDocumentDirectory;
          EmployeeRepository: IEmployeeRepository;
          ChargeControlService: IDocumentChargeControlService;
          ChargesInfoDTODomainMapper: IDocumentChargesInfoDTODomainMapper
        );

        function CreateDocumentCharges(
          const ChargeKindId: Variant;
          const AssigningId: Variant;
          const DocumentId: Variant;
          const PerformerIds: TVariantList
        ): TDocumentChargesInfoDTO;

        function GetDocumentCharge(
          const ChargeId: Variant;
          const DocumentId: Variant;
          const EmployeeId: Variant
        ): TDocumentChargeInfoDTO;

        procedure EnsureEmployeeMayRemoveDocumentCharges(
          const EmployeeId: Variant;
          const ChargeIds: TVariantList;
          const DocumentId: Variant
        );

    end;

implementation

uses

  DocumentOperationService,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;

{ TStandardDocumentChargeControlAppService }

constructor TStandardDocumentChargeControlAppService.Create(
  Session: ISession;
  DocumentDirectory: IDocumentDirectory;
  EmployeeRepository: IEmployeeRepository;
  ChargeControlService: IDocumentChargeControlService;
  ChargesInfoDTODomainMapper: IDocumentChargesInfoDTODomainMapper
);
begin

  inherited Create(Session, DocumentDirectory, EmployeeRepository);

  FChargeControlService := ChargeControlService;
  FChargesInfoDTODomainMapper := ChargesInfoDTODomainMapper;

end;

function TStandardDocumentChargeControlAppService.CreateDocumentCharges(
  const ChargeKindId: Variant;
  const AssigningId: Variant;
  const DocumentId: Variant;
  const PerformerIds: TVariantList
): TDocumentChargesInfoDTO;
var
    Document: IDocument;

    Assigning: TEmployee;
    FreeAssigning: IDomainObjectBase;
    
    Performers: TEmployees;
    FreePerformers: IDomainObjectBaseList;

    DocumentCharges: IDocumentCharges;

    AccessRightsList: TDocumentChargeAccessRightsList;
    FreeAccessRightsList: IDomainObjectBaseList;
begin

  Document := GetDocument(DocumentId);

  Assigning :=
    GetEmployeeOrRaise(
      AssigningId,
      'Информация о сотруднике, запрашивающем создание поручений, не найдена'
    );

  FreeAssigning := Assigning;
  
  Performers :=
    GetEmployeesOrRaise(
      PerformerIds,
      'Для назначения поручений информация об исполнителях не найдена'
    );

  FreePerformers := Performers;

  FChargeControlService.CreateDocumentCharges(
    ChargeKindId, Assigning, Document, Performers, DocumentCharges, AccessRightsList
  );

  FreeAccessRightsList := AccessRightsList;

  TDocument(Document.Self)
    .WorkingRules
      .ChargeListChangingRule
        .EnsureThatEmployeeMayAssignDocumentCharges(Assigning, Document, DocumentCharges);

  Result := CreateChargeInfoDTOs(DocumentCharges, AccessRightsList);

end;

procedure TStandardDocumentChargeControlAppService.EnsureEmployeeMayRemoveDocumentCharges(
  const EmployeeId: Variant;
  const ChargeIds: TVariantList;
  const DocumentId: Variant
);
var
    Employee: TEmployee;
    FreeEmployee: IDomainObjectBase;

    Document: IDocument;
begin

  Employee :=
    GetEmployeeOrRaise(
      EmployeeId,
      'Информация о сотруднике, запрашивающем удаление поручения, не найдена'
    );

  Document := GetDocument(DocumentId);

  try

    FChargeControlService
      .EnsureEmployeeMayRemoveDocumentCharges(Employee, ChargeIds, Document);

  except

    on E: TFailedRemovingDocumentChargesEnsuringException do begin

      raise TDocumentChargesRemovingEnsuringException.Create(
        FChargesInfoDTODomainMapper.MapDocumentChargesInfoDTOFrom(E.FailedDocumentCharges),
        E.Message
      );

    end;

  end;

end;

function TStandardDocumentChargeControlAppService.GetDocumentCharge(
  const ChargeId, DocumentId, EmployeeId: Variant
): TDocumentChargeInfoDTO;
var
    Document: IDocument;

    Employee: TEmployee;
    Free: IDomainObjectBase;

    Charge: IDocumentCharge;

    AccessRights: TDocumentChargeAccessRights;
    FreeAccessRights: IDomainObjectBase;
begin

  Document := GetDocument(DocumentId);

  Employee :=
    GetEmployeeOrRaise(
      EmployeeId,
      'Информация о сотруднике, запросившем поручение, не найдена'
    );

  Free := Employee;

  FChargeControlService.GetDocumentCharge(
    ChargeId, Document, Employee, Charge, AccessRights
  );

  FreeAccessRights := AccessRights;

  Result := CreateChargeInfoDTO(Charge, AccessRights);

end;

function TStandardDocumentChargeControlAppService.CreateChargeInfoDTOs(
  DocumentCharges: IDocumentCharges;
  AccessRightsList: TDocumentChargeAccessRightsList
): TDocumentChargesInfoDTO;
begin

  Result :=
    FChargesInfoDTODomainMapper.MapDocumentChargesInfoDTOFrom(
      DocumentCharges, AccessRightsList
    );

end;

function TStandardDocumentChargeControlAppService.CreateChargeInfoDTO(
  DocumentCharge: IDocumentCharge;
  AccessRights: TDocumentChargeAccessRights
): TDocumentChargeInfoDTO;
begin

  Result := FChargesInfoDTODomainMapper.MapDocumentChargeInfoDTOFrom(DocumentCharge, AccessRights);

end;

end.
