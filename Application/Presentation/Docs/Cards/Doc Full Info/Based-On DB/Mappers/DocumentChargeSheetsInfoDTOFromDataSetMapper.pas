unit DocumentChargeSheetsInfoDTOFromDataSetMapper;

interface

uses

  DocumentChargeSheetsInfoDTO,
  DocumentChargeSheetsInfoHolder,
  DocumentFlowEmployeeInfoDTO,
  DepartmentInfoDTO,
  DocumentChargesInfoDTOFromDataSetMapper,
  SysUtils,
  VariantListUnit,
  Disposable;

type

  TDocumentChargeSheetsInfoDTOFromDataSetMapper =
    class (TInterfacedObject, IDisposable)

      protected

        FChargesInfoDTOFromDataSetMapper: TDocumentChargesInfoDTOFromDataSetMapper;
        FFreeChargesInfoDTOFromDataSetMapper: IDisposable;
        
        function CreateDocumentChargeSheetsInfoDTOInstance: TDocumentChargeSheetsInfoDTO; virtual;
        function CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO; virtual;

      public

        constructor Create(ChargesInfoDTOFromDataSetMapper: TDocumentChargesInfoDTOFromDataSetMapper);

        function MapDocumentChargeSheetInfoDTOFrom(
          DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
        ): TDocumentChargeSheetInfoDTO;
        
        function MapDocumentChargeSheetsInfoDTOFrom(
          DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
        ): TDocumentChargeSheetsInfoDTO;

    end;
    
implementation

uses

  Variants, AbstractDataSetHolder;
  
{ TDocumentChargeSheetsInfoDTOFromDataSetMapper }

function TDocumentChargeSheetsInfoDTOFromDataSetMapper
  .MapDocumentChargeSheetsInfoDTOFrom(
    DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
  ): TDocumentChargeSheetsInfoDTO;

var
    HandledDocumentChargeSheetIds: TVariantList;
    DocumentChargeSheetInfoDTO: TDocumentChargeSheetInfoDTO;
begin

  HandledDocumentChargeSheetIds := TVariantList.Create;

  try

    Result := CreateDocumentChargeSheetsInfoDTOInstance;

    try

      with DocumentChargeSheetsInfoHolder do begin

        First;

        while not Eof do begin

          if not VarIsNull(IdFieldValue) and
             not HandledDocumentChargeSheetIds.Contains(IdFieldValue)
          then begin

            DocumentChargeSheetInfoDTO :=
              MapDocumentChargeSheetInfoDTOFrom(DocumentChargeSheetsInfoHolder);

            Result.Add(DocumentChargeSheetInfoDTO);

            HandledDocumentChargeSheetIds.Add(IdFieldValue);
            
          end;

          Next;
          
        end;

      end;

    except

      FreeAndNil(Result);
      
      raise;

    end;

  finally

    FreeAndNil(HandledDocumentChargeSheetIds);

  end;

end;

function TDocumentChargeSheetsInfoDTOFromDataSetMapper
  .MapDocumentChargeSheetInfoDTOFrom(
    DocumentChargeSheetsInfoHolder: TDocumentChargeSheetsInfoHolder
  ): TDocumentChargeSheetInfoDTO;
begin

  Result := CreateDocumentChargeSheetInfoDTOInstance;

  try

    Result.ChargeInfoDTO :=
      FChargesInfoDTOFromDataSetMapper
        .MapDocumentChargeInfoDTOFrom(
          DocumentChargeSheetsInfoHolder.ChargesInfoHolder
        );

    with DocumentChargeSheetsInfoHolder do begin

      Result.Id := IdFieldValue;
      Result.ChargeId := ChargeIdFieldValue;
      Result.TopLevelChargeSheetId := TopLevelChargeSheetIdFieldValue;
      Result.DocumentId := DocumentIdFieldValue;
      Result.DocumentKindId := DocumentKindIdFieldValue;
      Result.IssuingDateTime := IssuingDateTimeFieldValue;
      Result.ViewDateByPerformer := ViewDateByPerformerFieldValue;

      Result.IssuerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;

      Result.IssuerInfoDTO.Id := IssuerIdFieldValue;
      Result.IssuerInfoDTO.IsForeign := IssuerIsForeignFieldValue;
      Result.IssuerInfoDTO.FullName := IssuerNameFieldValue;
      Result.IssuerInfoDTO.Speciality := IssuerSpecialityFieldValue;

      Result.IssuerInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;
      
      Result.IssuerInfoDTO.DepartmentInfoDTO.Id := IssuerDepartmentIdFieldValue;
      Result.IssuerInfoDTO.DepartmentInfoDTO.Code := IssuerDepartmentCodeFieldValue;
      Result.IssuerInfoDTO.DepartmentInfoDTO.Name := IssuerDepartmentNameFieldValue;

      with Result.AccessRights do begin

        ViewingAllowed := ViewingAllowedFieldValue;
        ChargeSectionAccessible := ChargeSectionAccessibleFieldValue;
        ResponseSectionAccessible := ResponseSectionAccessibleFieldValue;
        RemovingAllowed := RemovingAllowedFieldValue;
        PerformingAllowed := PerformingAllowedFieldValue;
        IsEmployeePerformer := IsEmployeePerformerFieldValue;
        SubordinateChargeSheetsIssuingAllowed := SubordinateChargeSheetsIssuingAllowedFieldValue;

      end;
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

constructor TDocumentChargeSheetsInfoDTOFromDataSetMapper.Create(
  ChargesInfoDTOFromDataSetMapper: TDocumentChargesInfoDTOFromDataSetMapper);
begin

  inherited Create;

  FChargesInfoDTOFromDataSetMapper := ChargesInfoDTOFromDataSetMapper;
  FFreeChargesInfoDTOFromDataSetMapper := FChargesInfoDTOFromDataSetMapper;
  
end;

function TDocumentChargeSheetsInfoDTOFromDataSetMapper.
  CreateDocumentChargeSheetInfoDTOInstance: TDocumentChargeSheetInfoDTO;
begin

  Result := TDocumentChargeSheetInfoDTO.Create;

end;

function TDocumentChargeSheetsInfoDTOFromDataSetMapper.
  CreateDocumentChargeSheetsInfoDTOInstance: TDocumentChargeSheetsInfoDTO;
begin

  Result := TDocumentChargeSheetsInfoDTO.Create;

end;

end.
