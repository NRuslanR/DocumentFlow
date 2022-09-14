unit DocumentChargesInfoDTOFromDataSetMapper;

interface

uses

  DocumentFullInfoDTO,
  DocumentChargesInfoHolder,
  DocumentFlowEmployeeInfoDTO,
  DepartmentInfoDTO,
  VariantListUnit,
  SysUtils,
  Disposable;

type

  TDocumentChargesInfoDTOFromDataSetMapper = class (TInterfacedObject, IDisposable)

    protected

      function CreateDocumentChargesInfoDTOInstance: TDocumentChargesInfoDTO; virtual;
      function CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO; virtual;

    protected

      function MapDocumentChargeInfoDTOFrom(DocumentChargesInfoHolder: TDocumentChargesInfoHolder): TDocumentChargeInfoDTO;

    public

    function MapDocumentChargesInfoDTOFrom(DocumentChargesInfoHolder: TDocumentChargesInfoHolder): TDocumentChargesInfoDTO;

  end;

implementation

uses

  Variants;

{ TDocumentChargesInfoDTOFromDataSetMapper }

function TDocumentChargesInfoDTOFromDataSetMapper
  .MapDocumentChargesInfoDTOFrom(
    DocumentChargesInfoHolder: TDocumentChargesInfoHolder
  ): TDocumentChargesInfoDTO;

var
    HandledDocumentChargeIds: TVariantList;
    DocumentChargeInfoDTO: TDocumentChargeInfoDTO;
begin

  HandledDocumentChargeIds := TVariantList.Create;

  try

    Result := CreateDocumentChargesInfoDTOInstance;

    try

      with DocumentChargesInfoHolder do begin

        First;

        while not Eof do begin

          if
              not VarIsNull(DocumentChargeIdFieldValue) and
              not HandledDocumentChargeIds.Contains(DocumentChargeIdFieldValue)
          then begin

            DocumentChargeInfoDTO :=
              MapDocumentChargeInfoDTOFrom(DocumentChargesInfoHolder);

            Result.Add(DocumentChargeInfoDTO);

            HandledDocumentChargeIds.Add(DocumentChargeIdFieldValue);

          end;

          Next;

        end;

      end;

    except

      on e: Exception do begin

        FreeAndNil(Result);
        raise;
        
      end;

    end;

  finally

    FreeAndNil(HandledDocumentChargeIds);

  end;

end;

function TDocumentChargesInfoDTOFromDataSetMapper.CreateDocumentChargesInfoDTOInstance: TDocumentChargesInfoDTO;
begin

  Result := TDocumentChargesInfoDTO.Create;

end;

function TDocumentChargesInfoDTOFromDataSetMapper.MapDocumentChargeInfoDTOFrom(
  DocumentChargesInfoHolder: TDocumentChargesInfoHolder): TDocumentChargeInfoDTO;
begin

  Result := CreateDocumentChargeInfoDTOInstance;

  try

    with DocumentChargesInfoHolder do begin

      Result.Id := DocumentChargeIdFieldValue;
      Result.KindId := DocumentChargeKindIdFieldValue;
      Result.KindName := DocumentChargeKindNameFieldValue;
      Result.ServiceKindName := DocumentChargeServiceKindNameFieldValue;
      Result.ChargeText := DocumentChargeTextFieldValue;
      Result.PerformerResponse := DocumentChargeResponseFieldValue;
      Result.TimeFrameStart := DocumentChargePeriodStartFieldValue;
      Result.TimeFrameDeadline := DocumentChargePeriodEndFieldValue;
      Result.PerformingDateTime := DocumentChargePerformingDateTimeFieldValue;
      Result.IsForAcquaitance := DocumentChargeIsForAcquaitanceFieldValue;

      Result.PerformerInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;

      Result.PerformerInfoDTO.Id := DocumentChargePerformerIdFieldValue;
      Result.PerformerInfoDTO.LeaderId := DocumentChargePerformerLeaderIdFieldValue;
      Result.PerformerInfoDTO.IsForeign := DocumentChargePerformerIsForeignFieldValue;
      Result.PerformerInfoDTO.FullName := DocumentChargePerformerNameFieldValue;
      Result.PerformerInfoDTO.Speciality := DocumentChargePerformerSpecialityFieldValue;

      Result.PerformerInfoDTO.DepartmentInfoDTO := TDepartmentInfoDTO.Create;

      Result.PerformerInfoDTO.DepartmentInfoDTO.Id :=
        DocumentChargePerformerDepartmentIdFieldValue;

      Result.PerformerInfoDTO.DepartmentInfoDTO.Code :=
        DocumentChargePerformerDepartmentCodeFieldValue;

      Result.PerformerInfoDTO.DepartmentInfoDTO.Name :=
        DocumentChargePerformerDepartmentNameFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO := TDocumentFlowEmployeeInfoDTO.Create;

      Result.ActuallyPerformedEmployeeInfoDTO.Id :=
        DocumentChargeActualPerformerIdFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.LeaderId :=
        DocumentChargeActualPerformerLeaderIdFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.IsForeign :=
        DocumentChargeActualPerformerIsForeignFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.FullName :=
        DocumentChargeActualPerformerNameFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.FullName :=
        DocumentChargeActualPerformerSpecialityFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO :=
        TDepartmentInfoDTO.Create;

      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO.Id :=
        DocumentChargeActualPerformerDepartmentIdFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO.Code :=
        DocumentChargeActualPerformerDepartmentCodeFieldValue;

      Result.ActuallyPerformedEmployeeInfoDTO.DepartmentInfoDTO.Name :=
        DocumentChargeActualPerformerDepartmentNameFieldValue;

    end;

  except

    on e: Exception do begin

      FreeAndNil(Result);
      raise;

    end;

  end;

end;

function TDocumentChargesInfoDTOFromDataSetMapper.CreateDocumentChargeInfoDTOInstance: TDocumentChargeInfoDTO;
begin

  Result := TDocumentChargeInfoDTO.Create;
  
end;

end.
