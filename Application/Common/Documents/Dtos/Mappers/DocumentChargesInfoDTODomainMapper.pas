unit DocumentChargesInfoDTODomainMapper;

interface

uses

  DocumentCharges,
  SysUtils,
  IGetSelfUnit,
  DocumentChargeCreatingService,
  DocumentChargeSheetsInfoDTO,
  DocumentChargeInfoDTODomainMapperRegistry,
  DocumentChargeInfoDTODomainMapper,
  IEmployeeRepositoryUnit,
  DocumentChargeInterface,
  DocumentChargeAccessRights,
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

    function MapDocumentChargesInfoDTOFrom(
      Charges: IDocumentCharges;
      AccessRightsList: TDocumentChargeAccessRightsList = nil 
    ): TDocumentChargesInfoDTO;

    function MapDocumentChargeInfoDTOFrom(
      Charge: IDocumentCharge;
      AccessRights: TDocumentChargeAccessRights = nil
    ): TDocumentChargeInfoDTO;

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
        
        function MapDocumentChargesInfoDTOFrom(
          Charges: IDocumentCharges;
          AccessRightsList: TDocumentChargeAccessRightsList = nil
        ): TDocumentChargesInfoDTO;

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
  Charges: IDocumentCharges;
  AccessRightsList: TDocumentChargeAccessRightsList
): TDocumentChargesInfoDTO;
var
    AccessRights: TDocumentChargeAccessRights;
    I: Integer;
begin

  if Assigned(AccessRightsList) and (Charges.Count <> AccessRightsList.Count)
  then begin

    raise Exception.Create(
      'Программная ошибка. Количество поручений не совпадает ' +
      'с количеством наборов прав доступа'
    );
    
  end;

  Result := TDocumentChargesInfoDTO.Create;

  try

    for I := 0 to Charges.Count - 1 do begin

      if Assigned(AccessRightsList) then
        AccessRights := AccessRightsList[I]

      else AccessRights := nil;
      
      Result.Add(MapDocumentChargeInfoDTOFrom(Charges[I], AccessRights));

    end;

  except

    FreeAndNil(Result);

    Raise;
    
  end;

end;

function TDocumentChargesInfoDTODomainMapper.MapDocumentChargeInfoDTOFrom(
  Charge: IDocumentCharge;
  AccessRights: TDocumentChargeAccessRights
): TDocumentChargeInfoDTO;
var
    ChargeInfoDTOMapper: IDocumentChargeInfoDTODomainMapper;
begin

  ChargeInfoDTOMapper :=
    FChargeInfoDTODomainMapperRegistry
      .GetDocumentChargeInfoDTODomainMapper(
        TDocumentChargeClass(Charge.Self.ClassType)
      );

  Result :=
    ChargeInfoDTOMapper.MapDocumentChargeInfoDTOFrom(
      TDocumentCharge(Charge.Self), AccessRights
    );

end;

function TDocumentChargesInfoDTODomainMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

end.
