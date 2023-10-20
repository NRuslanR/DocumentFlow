unit DocumentChargeSheetInfoDTODomainMapper;

interface

uses

  ApplicationService,
  DocumentChargeSheet,
  DocumentChargeSheetsInfoDTO,
  DocumentFlowEmployeeInfoDTOMapper,
  DocumentChargeSheetViewingAccountingService,
  DocumentChargeInfoDTODomainMapper,
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

  TDocumentChargeSheetInfoDTODomainMapper =
    class (TInterfacedObject, IDocumentChargeSheetInfoDTODomainMapper)

      protected

        FEmployeeRepository: IEmployeeRepository;
        FDocumentChargeSheetViewingAccountingService: IDocumentChargeSheetViewingAccountingService;

        FChargeInfoDTODomainMapper: IDocumentChargeInfoDTODomainMapper;
        
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
          ChargeInfoDTODomainMapper: TDocumentChargeInfoDTODomainMapper;
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
  ChargeInfoDTODomainMapper: TDocumentChargeInfoDTODomainMapper;
  DocumentFlowEmployeeInfoDTOMapper: TDocumentFlowEmployeeInfoDTOMapper
);
begin

  inherited Create;

  FEmployeeRepository := EmployeeRepository;
  
  FDocumentChargeSheetViewingAccountingService := DocumentChargeSheetViewingAccountingService;

  FChargeInfoDTODomainMapper := ChargeInfoDTODomainMapper;
  
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

  ChargeSheetInfoDTO.ChargeInfoDTO :=
    FChargeInfoDTODomainMapper
      .MapDocumentChargeInfoDTOFrom(DocumentChargeSheet.Charge);

  with DocumentChargeSheet do begin

    ChargeSheetInfoDTO.Id := Identity;
    ChargeSheetInfoDTO.ChargeId := Charge.Identity;
    ChargeSheetInfoDTO.TopLevelChargeSheetId := TopLevelChargeSheetId;
    ChargeSheetInfoDTO.DocumentId := DocumentId;
    ChargeSheetInfoDTO.DocumentKindId := DocumentKindId;
    ChargeSheetInfoDTO.IssuingDateTime := IssuingDateTime;

    if Assigned(Performer) then begin

      ChargeSheetInfoDTO.ViewDateByPerformer :=
        FDocumentChargeSheetViewingAccountingService
          .GetDocumentChargeSheetViewDateByEmployee(
            Identity, Performer.Identity
          );
          
    end;

    if Assigned(Issuer) then begin

      ChargeSheetInfoDTO.IssuerInfoDTO :=
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
    Result.SubordinateChargeSheetsIssuingAllowed := SubordinateChargeSheetsIssuingAllowed;
    
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
    ChargeSheet.KindName := KindName;
    ChargeSheet.TopLevelChargeSheetId := TopLevelChargeSheetId;
    ChargeSheet.PerformingDateTime := PerformingDateTime;

    // { refactor } ChargeSheet.DocumentKindId := KindId;

    if not AnyVarIsNullOrEmpty([TimeFrameStart, TimeFrameDeadline]) then
      ChargeSheet.SetTimeFrameStartAndDeadline(TimeFrameStart, TimeFrameDeadline);

    ChargeSheet.IsForAcquaitance := IsForAcquaitance;

    if ChargeSheet.ChargeText <> ChargeText then begin

      ChargeSheet.ChargeText := ChargeText;

      ChargeSheetInfoDTO.IsChargeTextChanged := True;

    end;

    if ChargeSheet.PerformerResponse <> PerformerResponse then begin

      ChargeSheet.PerformerResponse := PerformerResponse;

      ChargeSheetInfoDTO.IsPerformerResponseChanged := True;

    end;

    if ChargeSheet.Performer.Identity <> PerformerInfoDTO.Id then begin
    
      ChargeSheet.Performer :=
        GetEmployeeOrRaise(
          PerformerInfoDTO.Id,
          'Не найден исполнитель поручения'
        );

    end;

    if
      Assigned(ActuallyPerformedEmployeeInfoDTO)
      and (ChargeSheet.ActuallyPerformedEmployee.Identity <> ActuallyPerformedEmployeeInfoDTO.Id)
    then begin

      ChargeSheet.ActuallyPerformedEmployee :=
        GetEmployeeOrRaise(
          ActuallyPerformedEmployeeInfoDTO.Id,
          'Не найден сотрудник, фактически выполнивший поручение'
        );

    end;

    if ChargeSheet.Issuer.Identity <> IssuerInfoDTO.Id then begin

      ChargeSheet.Issuer :=
        GetEmployeeOrRaise(
          IssuerInfoDTO.Id,
          'Не найден сотрудник, выдавший поручение'
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
