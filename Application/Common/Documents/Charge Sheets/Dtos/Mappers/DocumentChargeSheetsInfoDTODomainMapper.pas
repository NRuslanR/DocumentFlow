unit DocumentChargeSheetsInfoDTODomainMapper;

interface

uses

  DocumentChargeSheet,
  SysUtils,
  IGetSelfUnit,
  DocumentChargeCreatingService,
  DocumentFullInfoDTO,
  IDocumentChargeSheetUnit,
  DocumentChargeSheetsInfoDTO,
  DocumentChargeSheetInfoDTODomainMapperRegistry,
  DocumentChargeSheetInfoDTODomainMapper,
  IEmployeeRepositoryUnit,
  VariantListUnit,
  Employee,
  Classes;

type

  IDocumentChargeSheetsInfoDTODomainMapper = interface (IGetSelf)

    function MapDocumentChargeSheetsInfoFrom(
      ChargeSheets: TDocumentChargeSheets
    ): TDocumentChargeSheetsInfoDTO;

  end;

  TDocumentChargeSheetsInfoDTODomainMapper =
    class (TInterfacedObject, IDocumentChargeSheetsInfoDTODomainMapper)

      protected

        FEmployeeRepository: IEmployeeRepository;
        
        FChargeSheetInfoDTODomainMapperRegistry:
          IDocumentChargeSheetInfoDTODomainMapperRegistry;

      public

        constructor Create(
          EmployeeRepository: IEmployeeRepository;
          ChargeSheetInfoDTODomainMapperRegistry: IDocumentChargeSheetInfoDTODomainMapperRegistry
        );

        function GetSelf: TObject;
        
        function MapDocumentChargeSheetsInfoFrom(
          ChargeSheets: TDocumentChargeSheets
        ): TDocumentChargeSheetsInfoDTO;
        
    end;

implementation

uses

  VariantFunctions,
  DocumentChargeInterface,
  IDomainObjectBaseUnit,
  IDomainObjectBaseListUnit;
  
{ TDocumentChargeSheetsInfoDTODomainMapper }

constructor TDocumentChargeSheetsInfoDTODomainMapper.Create(
  EmployeeRepository: IEmployeeRepository;
  ChargeSheetInfoDTODomainMapperRegistry: IDocumentChargeSheetInfoDTODomainMapperRegistry
);
begin

  inherited Create;

  FEmployeeRepository := EmployeeRepository;
  FChargeSheetInfoDTODomainMapperRegistry := ChargeSheetInfoDTODomainMapperRegistry;
  
end;

function TDocumentChargeSheetsInfoDTODomainMapper.MapDocumentChargeSheetsInfoFrom(
  ChargeSheets: TDocumentChargeSheets
): TDocumentChargeSheetsInfoDTO;
var
    ChargeSheet: IDocumentChargeSheet;
    ChargeSheetObj: TDocumentChargeSheet;
    
    ChargeSheetInfoDTOMapper: IDocumentChargeSheetInfoDTODomainMapper;
begin

  Result := TDocumentChargeSheetsInfoDTO.Create;

  if not Assigned(ChargeSheets) then Exit;
  
  try

    for ChargeSheet in ChargeSheets do begin

      ChargeSheetObj := TDocumentChargeSheet(ChargeSheet.Self);
      
      ChargeSheetInfoDTOMapper :=
        FChargeSheetInfoDTODomainMapperRegistry
          .GetDocumentChargeSheetInfoDTODomainMapper(
            ChargeSheetObj.ClassType
          );

      Result.Add(
        ChargeSheetInfoDTOMapper.MapDocumentChargeSheetInfoDTOFrom(ChargeSheetObj)
      );

    end;

  except

    FreeAndNil(Result);

    Raise;
    
  end;

end;

function TDocumentChargeSheetsInfoDTODomainMapper.GetSelf: TObject;
begin

  Result := Self;
  
end;

end.
