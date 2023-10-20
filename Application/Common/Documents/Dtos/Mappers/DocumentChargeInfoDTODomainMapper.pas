unit DocumentChargeInfoDTODomainMapper;

interface

uses

  DocumentCharges,
  SysUtils,
  IGetSelfUnit,
  DocumentChargeCreatingService,
  IDocumentUnit,
  DocumentChargeSheetsInfoDTO,
  IEmployeeRepositoryUnit,
  DocumentFlowEmployeeInfoDTOMapper,
  VariantListUnit,
  DocumentChargeAccessRights,
  DocumentChargeInterface,
  Employee,
  Classes;

type

  IDocumentChargeInfoDTODomainMapper = interface (IGetSelf)

    function MapDocumentChargeFrom(
      ChargeInfoDTO: TDocumentChargeInfoDTO;
      Document: IDocument;
      Performer: TEmployee
    ): IDocumentCharge;

    procedure FillDocumentChargeByDTO(
      DocumentCharge: IDocumentCharge;
      ChargeInfoDTO: TDocumentChargeInfoDTO
    );

    function MapDocumentChargeInfoDTOFrom(
      Charge: IDocumentCharge;
      AccessRights: TDocumentChargeAccessRights = nil
    ): TDocumentChargeInfoDTO;

  end;

  TDocumentChargeInfoDTODomainMapper =
    class (TInterfacedObject, IDocumentChargeInfoDTODomainMapper)

      protected

        FEmployeeRepository: IEmployeeRepository;
        FDocumentChargeCreatingService: IDocumentChargeCreatingService;

        FDocumentFlowEmployeeInfoDTOMapper: IDocumentFlowEmployeeInfoDTOMapper;

      protected

        function CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO; virtual;
        
        procedure FillDocumentChargeInfoDTO(
          ChargeInfoDTO: TDocumentChargeInfoDTO;
          Charge: IDocumentCharge
        ); virtual;

        function MapAccessRightsDto(AccessRights: TDocumentChargeAccessRights): TDocumentChargeAccessRightsDTO; virtual;
        
      public

        constructor Create(
          EmployeeRepository: IEmployeeRepository;
          DocumentChargeCreatingService: IDocumentChargeCreatingService;
          DocumentFlowEmployeeInfoDTOMapper: IDocumentFlowEmployeeInfoDTOMapper
        );

        function GetSelf: TObject;
        
        function MapDocumentChargeFrom(
          ChargeInfoDTO: TDocumentChargeInfoDTO;
          Document: IDocument;
          Performer: TEmployee
        ): IDocumentCharge;

        procedure FillDocumentChargeByDTO(
          DocumentCharge: IDocumentCharge;
          ChargeInfoDTO: TDocumentChargeInfoDTO
        );

        function MapDocumentChargeInfoDTOFrom(
          Charge: IDocumentCharge;
          AccessRights: TDocumentChargeAccessRights = nil
        ): TDocumentChargeInfoDTO;
        
    end;

implementation

uses

  VariantFunctions,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;
  
{ TDocumentChargeInfoDTODomainMapper }

constructor TDocumentChargeInfoDTODomainMapper.Create(
  EmployeeRepository: IEmployeeRepository;
  DocumentChargeCreatingService: IDocumentChargeCreatingService;
  DocumentFlowEmployeeInfoDTOMapper: IDocumentFlowEmployeeInfoDTOMapper
);
begin

  inherited Create;

  FEmployeeRepository := EmployeeRepository;
  FDocumentChargeCreatingService := DocumentChargeCreatingService;

  FDocumentFlowEmployeeInfoDTOMapper := DocumentFlowEmployeeInfoDTOMapper;
  
end;

function TDocumentChargeInfoDTODomainMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

function TDocumentChargeInfoDTODomainMapper.MapDocumentChargeFrom(
  ChargeInfoDTO: TDocumentChargeInfoDTO;
  Document: IDocument;
  Performer: TEmployee
): IDocumentCharge;
begin

  Result :=
    FDocumentChargeCreatingService.CreateDocumentCharge(
      ChargeInfoDTO.KindId, Document, Performer
    );

  FillDocumentChargeByDTO(Result, ChargeInfoDTO);

end;

function TDocumentChargeInfoDTODomainMapper
  .MapDocumentChargeInfoDTOFrom(
    Charge: IDocumentCharge;
    AccessRights: TDocumentChargeAccessRights
  ): TDocumentChargeInfoDTO;
begin

  Result := CreateDocumentChargeInfoDTOInstance;

  try

    FillDocumentChargeInfoDTO(Result, Charge);

    if Assigned(AccessRights) then
      Result.AccessRights := MapAccessRightsDto(AccessRights);
    
  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentChargeInfoDTODomainMapper.MapAccessRightsDto(
  AccessRights: TDocumentChargeAccessRights): TDocumentChargeAccessRightsDTO;
begin

  Result := TDocumentChargeAccessRightsDTO.Create;

  try

    with AccessRights do begin

      Result.ChargeSectionAccessible := ChargeSectionAccessible;
      Result.RemovingAllowed := RemovingAllowed;
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;

end;

function TDocumentChargeInfoDTODomainMapper.CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargeInfoDTO.Create;
  
end;

procedure TDocumentChargeInfoDTODomainMapper.FillDocumentChargeByDTO(
  DocumentCharge: IDocumentCharge;
  ChargeInfoDTO: TDocumentChargeInfoDTO
);
begin

  with ChargeInfoDTO do begin

    DocumentCharge.Identity := Id;
    DocumentCharge.Response := PerformerResponse;

    if not AnyVarIsNullOrEmpty([TimeFrameStart, TimeFrameDeadline]) then
      DocumentCharge.SetTimeFrameStartAndDeadline(TimeFrameStart, TimeFrameDeadline);

    DocumentCharge.ChargeText := ChargeText;
    DocumentCharge.PerformingDateTime := PerformingDateTime;
    DocumentCharge.IsForAcquaitance := IsForAcquaitance;

    if
      Assigned(ActuallyPerformedEmployeeInfoDTO)
      and not VarIsNullOrEmpty(ActuallyPerformedEmployeeInfoDTO.Id)
    then begin

      DocumentCharge.ActuallyPerformedEmployee :=
        FEmployeeRepository.FindEmployeeById(
          ActuallyPerformedEmployeeInfoDTO.Id
        );

    end;
    
  end;
  
end;

procedure TDocumentChargeInfoDTODomainMapper.FillDocumentChargeInfoDTO(
  ChargeInfoDTO: TDocumentChargeInfoDTO;
  Charge: IDocumentCharge
);
begin

  with ChargeInfoDTO do begin

    Id := Charge.Identity;
    KindId := Charge.KindId;
    KindName := Charge.KindName;
    ServiceKindName := Charge.ServiceKindName;
    ChargeText := Charge.ChargeText;
    PerformerResponse := Charge.Response;
    TimeFrameStart := Charge.TimeFrameStart;
    TimeFrameDeadline := Charge.TimeFrameDeadline;
    PerformingDateTime := Charge.PerformingDateTime;
    IsForAcquaitance := Charge.IsForAcquaitance;

    if Assigned(Charge.Performer) then begin

      PerformerInfoDTO :=
        FDocumentFlowEmployeeInfoDTOMapper.MapDocumentFlowEmployeeInfoDTOFrom(
          Charge.Performer
        );

    end;

    if Assigned(Charge.ActuallyPerformedEmployee) then begin

      ActuallyPerformedEmployeeInfoDTO :=
        FDocumentFlowEmployeeInfoDTOMapper.MapDocumentFlowEmployeeInfoDTOFrom(
          Charge.ActuallyPerformedEmployee
        );

    end;

  end;

end;

end.
