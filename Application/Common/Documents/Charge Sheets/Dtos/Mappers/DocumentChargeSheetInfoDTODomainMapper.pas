unit DocumentChargeSheetInfoDTODomainMapper;

interface

uses

  ApplicationService,
  DocumentChargeSheet,
  DocumentChargeSheetsInfoDTO,
  DocumentFlowEmployeeInfoDTOMapper,
  DocumentChargeSheetViewingAccountingService,
  DocumentChargeSheetAccessRights,
  Employee,
  IEmployeeRepositoryUnit,
  Disposable,
  SysUtils;

type

  IDocumentChargeSheetInfoDTODomainMapper = interface

    function MapDocumentChargeSheetInfoDTOFrom(
      DocumentChargeSheet: TDocumentChargeSheet
    ): TDocumentChargeSheetInfoDTO; overload;

    function MapDocumentChargeSheetInfoDTOFrom(
      DocumentChargeSheet: TDocumentChargeSheet;
      AccessRights: TDocumentChargeSheetAccessRights
    ): TDocumentChargeSheetInfoDTO; overload;

    procedure ChangeDocumentChargeSheetFromDTO(
      ChargeSheet: TDocumentChargeSheet;
      ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
      ChangingEmployee: TEmployee
    );

  end;

  { refactor: evaluate embeding ChargeInfoDTOMapper to this }
  TDocumentChargeSheetInfoDTODomainMapper =
    class (TInterfacedObject, IDocumentChargeSheetInfoDTODomainMapper)

      protected

        FEmployeeRepository: IEmployeeRepository;
        FDocumentChargeSheetViewingAccountingService: IDocumentChargeSheetViewingAccountingService;
        FDocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper;
        FFreeDocumentFlowEmployeeInfoDTOMapper: IDisposable;

        function MapDocumentChargeSheetAccessRightsFrom(
          AccessRights: TDocumentChargeSheetAccessRights
        ): TDocumentChargeSheetAccessRightsDTO;

        function CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO; virtual;

        procedure FillDocumentChargeSheetInfoDTO(
          ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
          DocumentChargeSheet: TDocumentChargeSheet
        ); virtual;

        function GetEmployeeOrRaise(
          const EmployeeId: Variant;
          const ErrorMessage: String = ''
        ): TEmployee;

      public

        constructor Create(
          EmployeeRepository: IEmployeeRepository;
          DocumentChargeSheetViewingAccountingService: IDocumentChargeSheetViewingAccountingService;
          DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
        );

        function MapDocumentChargeSheetInfoDTOFrom(
          DocumentChargeSheet: TDocumentChargeSheet
        ): TDocumentChargeSheetInfoDTO; overload; virtual;

        function MapDocumentChargeSheetInfoDTOFrom(
          DocumentChargeSheet: TDocumentChargeSheet;
          AccessRights: TDocumentChargeSheetAccessRights
        ): TDocumentChargeSheetInfoDTO; overload; virtual;

        procedure ChangeDocumentChargeSheetFromDTO(
          ChargeSheet: TDocumentChargeSheet;
          ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
          ChangingEmployee: TEmployee
        ); virtual;

    end;

implementation

uses

  VariantFunctions,
  DomainObjectUnit;

{ TDocumentChargeSheetInfoDTODomainMapper }

constructor TDocumentChargeSheetInfoDTODomainMapper.Create(
  EmployeeRepository: IEmployeeRepository;
  DocumentChargeSheetViewingAccountingService: IDocumentChargeSheetViewingAccountingService;
  DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
);
begin

  inherited Create;

  FEmployeeRepository := EmployeeRepository;
  
  FDocumentChargeSheetViewingAccountingService := DocumentChargeSheetViewingAccountingService;
  
  FDocumentFlowEmployeeInfoDTOMapper := DocumentFlowEmployeeInfoDTOMapper;
  FFreeDocumentFlowEmployeeInfoDTOMapper := FDocumentFlowEmployeeInfoDTOMapper;
  
end;

function TDocumentChargeSheetInfoDTODomainMapper.MapDocumentChargeSheetInfoDTOFrom(
  DocumentChargeSheet: TDocumentChargeSheet;
  AccessRights: TDocumentChargeSheetAccessRights
): TDocumentChargeSheetInfoDTO;
begin

  Result := MapDocumentChargeSheetInfoDTOFrom(DocumentChargeSheet);

  try

    Result.AccessRights := MapDocumentChargeSheetAccessRightsFrom(AccessRights);

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

function TDocumentChargeSheetInfoDTODomainMapper.MapDocumentChargeSheetInfoDTOFrom(
  DocumentChargeSheet: TDocumentChargeSheet): TDocumentChargeSheetInfoDTO;
begin

  Result := CreateDocumentChargeSheetInfoDTOInstance;

  try

    FillDocumentChargeSheetInfoDTO(Result, DocumentChargeSheet);

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentChargeSheetInfoDTODomainMapper
  .CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO;
begin

  Result := TDocumentChargeSheetInfoDTO.Create;

end;

procedure TDocumentChargeSheetInfoDTODomainMapper
  .FillDocumentChargeSheetInfoDTO(
    ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
    DocumentChargeSheet: TDocumentChargeSheet
  );
begin

  with DocumentChargeSheet do begin

    ChargeSheetInfoDTO.Id := Identity;
    ChargeSheetInfoDTO.KindId := KindId;
    ChargeSheetInfoDTO.KindName := KindName;
    ChargeSheetInfoDTO.ServiceKindName := ServiceKindName;
    ChargeSheetInfoDTO.TopLevelChargeSheetId := TopLevelChargeSheetId;
    ChargeSheetInfoDTO.DocumentId := DocumentId;
    ChargeSheetInfoDTO.DocumentKindId := DocumentKindId;
    ChargeSheetInfoDTO.TimeFrameStart := TimeFrameStart;
    ChargeSheetInfoDTO.TimeFrameDeadline := TimeFrameDeadline;
    ChargeSheetInfoDTO.IssuingDateTime := IssuingDateTime;
    ChargeSheetInfoDTO.PerformingDateTime := PerformingDateTime;
    ChargeSheetInfoDTO.IsForAcquaitance := IsForAcquaitance;

    if Assigned(Performer) then begin

      ChargeSheetInfoDTO.ViewingDateByPerformer :=
        FDocumentChargeSheetViewingAccountingService
          .GetDocumentChargeSheetViewDateByEmployee(
            Identity, Performer.Identity
          );

      ChargeSheetInfoDTO.PerformerInfoDTO :=
        FDocumentFlowEmployeeInfoDTOMapper
          .MapDocumentFlowEmployeeInfoDTOFrom(Performer);

    end;

    if Assigned(ActuallyPerformedEmployee) then begin

      ChargeSheetInfoDTO.ActuallyPerformedEmployeeInfoDTO :=
        FDocumentFlowEmployeeInfoDTOMapper
          .MapDocumentFlowEmployeeInfoDTOFrom(ActuallyPerformedEmployee);

    end;

    if Assigned(Issuer) then begin

      ChargeSheetInfoDTO.SenderEmployeeInfoDTO :=
        FDocumentFlowEmployeeInfoDTOMapper
          .MapDocumentFlowEmployeeInfoDTOFrom(Issuer);

    end;

  end;

end;

function TDocumentChargeSheetInfoDTODomainMapper.MapDocumentChargeSheetAccessRightsFrom(
  AccessRights: TDocumentChargeSheetAccessRights
): TDocumentChargeSheetAccessRightsDTO;
begin

  Result := TDocumentChargeSheetAccessRightsDTO.Create;

  with AccessRights do begin

    Result.ViewingAllowed := ViewingAllowed;
    Result.ChargeSectionAccessible := ChargeSectionAccessible;
    Result.ResponseSectionAccessible := ResponseSectionAccessible;
    Result.RemovingAllowed := RemovingAllowed;
    Result.PerformingAllowed := PerformingAllowed;
    
  end;

end;

procedure TDocumentChargeSheetInfoDTODomainMapper.ChangeDocumentChargeSheetFromDTO(
  ChargeSheet: TDocumentChargeSheet;
  ChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
  ChangingEmployee: TEmployee
);
begin

  ChargeSheet.EditingEmployee := ChangingEmployee;

  with ChargeSheetInfoDTO do begin

    ChargeSheet.KindId := KindId;
    ChargeSheet.KIndName := KindName;
    
    ChargeSheet.TopLevelChargeSheetId := TopLevelChargeSheetId;
    ChargeSheet.DocumentId := DocumentId;
    // { refactor } ChargeSheet.DocumentKindId := KindId;

    if not AnyVarIsNullOrEmpty([TimeFrameStart, TimeFrameDeadline]) then
      ChargeSheet.SetTimeFrameStartAndDeadline(TimeFrameStart, TimeFrameDeadline);

    ChargeSheet.IsForAcquaitance := IsForAcquaitance;
    ChargeSheet.ChargeText := ChargeText;
    ChargeSheet.PerformerResponse := PerformerResponse;

    if ChargeSheet.Performer.Identity <> PerformerInfoDTO.Id then begin
    
      ChargeSheet.Performer :=
        GetEmployeeOrRaise(
          PerformerInfoDTO.Id,
          '¬о врем€ изменени€ поручени€ не найден новый исполнитель'
        );

    end;

    if
      Assigned(ActuallyPerformedEmployeeInfoDTO)
      and (ChargeSheet.ActuallyPerformedEmployee.Identity <> ActuallyPerformedEmployeeInfoDTO.Id)
    then begin

      ChargeSheet.ActuallyPerformedEmployee :=
        GetEmployeeOrRaise(
          ActuallyPerformedEmployeeInfoDTO.Id,
          '¬о врем€ изменени€ поручени€ не найден ' +
          'новый фактически выполнивший сотрудник'
        );

    end;

    if ChargeSheet.Issuer.Identity <> SenderEmployeeInfoDTO.Id then begin

      ChargeSheet.Issuer :=
        GetEmployeeOrRaise(
          SenderEmployeeInfoDTO.Id,
          '¬о врем€ изменени€ поручени€ не найден ' +
          'новый выдавший сотрудник'
        );

    end;
    
  end;

end;

function TDocumentChargeSheetInfoDTODomainMapper.GetEmployeeOrRaise(
  const EmployeeId: Variant;
  const ErrorMessage: String
): TEmployee;
begin

  Result := FEmployeeRepository.FindEmployeeById(EmployeeId);

  if not Assigned(Result) then
    Raise TApplicationServiceException.Create(ErrorMessage);

end;

end.
