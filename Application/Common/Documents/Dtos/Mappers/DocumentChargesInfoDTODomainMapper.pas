unit DocumentChargesInfoDTODomainMapper;

interface

uses

  DocumentCharges,
  SysUtils,
  IGetSelfUnit,
  DocumentChargeCreatingService,
  DocumentFullInfoDTO,
  DocumentChargeInfoDTODomainMapperRegistry,
  DocumentChargeInfoDTODomainMapper,
  IEmployeeRepositoryUnit,
  DocumentChargeInterface,
  IDocumentUnit,
  VariantListUnit,
  Employee,
  Classes;

type

  IDocumentChargesInfoDTODomainMapper = interface (IGetSelf)

    function MapDocumentChargesFrom(
      DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
      Document: IDocument
    ): IDocumentCharges;

    function MapDocumentChargesInfoDTOFrom(Charges: IDocumentCharges): TDocumentChargesInfoDTO;

  end;

  TDocumentChargesInfoDTODomainMapper =
    class (TInterfacedObject, IDocumentChargesInfoDTODomainMapper)

      protected

        FEmployeeRepository: IEmployeeRepository;
        
        FChargeInfoDTODomainMapperRegistry:
          IDocumentChargeInfoDTODomainMapperRegistry;

      public

        constructor Create(
          EmployeeRepository: IEmployeeRepository;
          ChargeInfoDTODomainMapperRegistry: IDocumentChargeInfoDTODomainMapperRegistry
        );

        function GetSelf: TObject;
        
        function MapDocumentChargesFrom(
          DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
          Document: IDocument
        ): IDocumentCharges;
        
        function MapDocumentChargesInfoDTOFrom(Charges: IDocumentCharges): TDocumentChargesInfoDTO;
        
    end;

implementation

uses

  VariantFunctions,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;
  
{ TDocumentChargesInfoDTODomainMapper }

constructor TDocumentChargesInfoDTODomainMapper.Create(
  EmployeeRepository: IEmployeeRepository;
  ChargeInfoDTODomainMapperRegistry: IDocumentChargeInfoDTODomainMapperRegistry
);
begin

  inherited Create;

  FEmployeeRepository := EmployeeRepository;
  FChargeInfoDTODomainMapperRegistry := ChargeInfoDTODomainMapperRegistry;
  
end;

function TDocumentChargesInfoDTODomainMapper.MapDocumentChargesFrom(
  DocumentChargesInfoDTO: TDocumentChargesInfoDTO;
  Document: IDocument
): IDocumentCharges;
var
    PerformerIds: TVariantList;
    Performers: TEmployees;
    Performer: TEmployee;
    FreePerformers: IDomainObjectBaseList;
    ChargeInfoDTO: TDocumentChargeInfoDTO;
    ChargeMapper: IDocumentChargeInfoDTODomainMapper;
begin

  PerformerIds := DocumentChargesInfoDTO.ExtractPerformerIds;

  Result := TDocumentCharges.Create;
  
  try

    try

      Performers := FEmployeeRepository.FindEmployeesByIdentities(PerformerIds);

      if not Assigned(Performers) then Exit;

      FreePerformers := Performers;

      for Performer in Performers do begin

        ChargeInfoDTO :=
          DocumentChargesInfoDTO.FindChargeByPerformerId(Performer.Identity);

        ChargeMapper :=
          FChargeInfoDTODomainMapperRegistry
            .GetDocumentChargeInfoDTODomainMapper(ChargeInfoDTO.KindId);

        Result.AddCharge(
          ChargeMapper.MapDocumentChargeFrom(ChargeInfoDTO, Document, Performer)
        );

      end;

    except

      FreeAndNil(Result);

      Raise;

    end;

  finally

    FreeAndNil(PerformerIds);

  end;

end;

function TDocumentChargesInfoDTODomainMapper.MapDocumentChargesInfoDTOFrom(
  Charges: IDocumentCharges): TDocumentChargesInfoDTO;
var
    Charge: IDocumentCharge;
    ChargeInfoDTOMapper: IDocumentChargeInfoDTODomainMapper;
begin

  Result := TDocumentChargesInfoDTO.Create;

  try

    for Charge in Charges do begin

      ChargeInfoDTOMapper :=
        FChargeInfoDTODomainMapperRegistry
          .GetDocumentChargeInfoDTODomainMapper(
            TDocumentChargeClass(Charge.Self.ClassType)
          );

      Result.Add(
        ChargeInfoDTOMapper.MapDocumentChargeInfoDTOFrom(
          TDocumentCharge(Charge.Self)
        )
      );

    end;

  except

    FreeAndNil(Result);

    Raise;
    
  end;

end;

function TDocumentChargesInfoDTODomainMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

end.
