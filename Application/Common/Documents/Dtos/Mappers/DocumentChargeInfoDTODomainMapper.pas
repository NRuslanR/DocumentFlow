unit DocumentChargeInfoDTODomainMapper;

interface

uses

  DocumentCharges,
  SysUtils,
  IGetSelfUnit,
  DocumentChargeCreatingService,
  IDocumentUnit,
  DocumentFullInfoDTO,
  IEmployeeRepositoryUnit,
  DocumentFlowEmployeeInfoDTOMapper,
  VariantListUnit,
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

    function MapDocumentChargeInfoDTOFrom(
      Charge: IDocumentCharge
    ): TDocumentChargeInfoDTO;

  end;

  { refactor: evaluate embeding this to ChargeSheetInfoDTOMapper }
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

        function MapDocumentChargeInfoDTOFrom(
          Charge: IDocumentCharge
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

  with ChargeInfoDTO do begin

    Result.Identity := Id;
    Result.Response := PerformerResponse;

    if not AnyVarIsNullOrEmpty([TimeFrameStart, TimeFrameDeadline]) then
      Result.SetTimeFrameStartAndDeadline(TimeFrameStart, TimeFrameDeadline);

    Result.ChargeText := ChargeText;
    Result.PerformingDateTime := PerformingDateTime;
    Result.IsForAcquaitance := IsForAcquaitance;

    if
      Assigned(ActuallyPerformedEmployeeInfoDTO)
      and not VarIsNullOrEmpty(ActuallyPerformedEmployeeInfoDTO.Id)
    then begin

      Result.ActuallyPerformedEmployee :=
        FEmployeeRepository.FindEmployeeById(
          ActuallyPerformedEmployeeInfoDTO.Id
        );

    end;
    
  end;

end;

function TDocumentChargeInfoDTODomainMapper
  .MapDocumentChargeInfoDTOFrom(
    Charge: IDocumentCharge
  ): TDocumentChargeInfoDTO;
begin

  Result := CreateDocumentChargeInfoDTOInstance;

  try

    FillDocumentChargeInfoDTO(Result, Charge);

  except

    on E: Exception do begin

      FreeAndNil(Result);

      Raise;
      
    end;

  end;

end;

function TDocumentChargeInfoDTODomainMapper.CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargeInfoDTO.Create;
  
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

    PerformerInfoDTO :=
      FDocumentFlowEmployeeInfoDTOMapper.MapDocumentFlowEmployeeInfoDTOFrom(
        Charge.Performer
      );

    if Assigned(Charge.ActuallyPerformedEmployee) then begin

      ActuallyPerformedEmployeeInfoDTO :=
        FDocumentFlowEmployeeInfoDTOMapper.MapDocumentFlowEmployeeInfoDTOFrom(
          Charge.ActuallyPerformedEmployee
        );

    end;

  end;

end;

end.
